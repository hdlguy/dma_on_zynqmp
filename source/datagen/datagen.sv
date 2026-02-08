// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           enable,
    output  logic           ready,
    input   logic           clear,
    input   logic[31:0]     period,
    input   logic[15:0]     length,
    //
    input   logic[3:0]       bram_clk, bram_rst, bram_en,
    input   logic[3:0][3:0]  bram_we,
    input   logic[3:0][15:0] bram_addr,
    input   logic[3:0][31:0] bram_din,
    output  logic[3:0][31:0] bram_dout
);

    logic[3:0][1:0] web;
    logic[3:0][14:0] addrb;
    logic[3:0][15:0] dinb,doutb;
    generate for (genvar i=0; i<4; i++) begin
        dgen_mem #(.size(2**16), .awidth(32), .bwidth(16)) mem_inst (
            .clka(bram_clk[i]), .wea(bram_we[i]), .addra(bram_addr[i][15:2]), .dina(bram_din[i]), .douta(bram_dout[i]), 
            .clkb(clk), .web(web[i]), .addrb(addrb[i]), .dinb(dinb[i]), .doutb(doutb[i]) 
        );
    end endgenerate

    logic[15:0] length_count;
    assign addrb = {4{length_count[14:0]}};
    assign dinb  = {4{length_count}};

    logic set_ready;
    logic length_clear;
    logic period_pulse=0;
    logic[3:0] state=0, next_state;
    always_ff @(posedge clk) state <= next_state;
    always_comb begin
        // defaults
        next_state = state;
        set_ready = 0;
        length_clear = 1;
        web = {4{2'b00}};
        
        case (state)
        
            0: begin
                next_state = 1;
            end
            
            1: begin
                if (enable) begin
                    next_state = 2;
                end
            end 
            
            2: begin
                if (enable) begin
                    if (period_pulse) begin
                        next_state = 3;
                    end
                end else begin
                    next_state = 0;
                end
            end
            
            3: begin
                length_clear = 0;
                web = {4{2'b11}};
                if (enable) begin
                    if (length_count == length) begin
                        next_state = 4;                        
                    end
                end else begin
                    next_state = 0;
                end
            end
            
            4: begin
                set_ready = 1;
                next_state = 1;
            end
            
            default: begin
                next_state = 0;
            end
             
        endcase
    end    
    
    
    always_ff @(posedge clk) begin
        if (length_clear) begin
            length_count <= 0;
        end else begin
            length_count <= length_count + 1;
        end
    end
    
    
    logic ready_int=0;
    always_ff @(posedge clk) begin
        if (clear) begin
            ready_int <= 0;
        end else begin
            if (set_ready) begin
                ready_int <= 1;
            end
        end
    end
    assign ready = ready_int;
    
    
    logic[31:0] period_count=-1;
    always_ff @(posedge clk) begin
        if (!enable) begin
            period_count <= period;
            period_pulse <= 0;
        end else begin
            if (period_count == 0) begin
                period_count <= period;
                period_pulse <= 1;
            end else begin
                period_count <= period_count - 1;
                period_pulse <= 0;
            end           
        end
    end
    
    dgen_ila ila_inst(.clk(clk), .probe0({enable, ready, clear, period_pulse, web[0], state, length_count[14:0], dinb[0]})); //41
            
endmodule


/*

*/
