// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           run,
    output  logic           busy,
    input   logic[31:0]     length,
    input   logic[1:0]      chan,
    //
    output  logic[31:0]     s_axis_s2mm_tdata,
    output  logic[3:0]      s_axis_s2mm_tdest,
    output  logic[7:0]      s_axis_s2mm_tid,
    output  logic[3:0]      s_axis_s2mm_tkeep,
    output  logic           s_axis_s2mm_tlast,
    input   logic           s_axis_s2mm_tready,
    output  logic[15:0]     s_axis_s2mm_tuser,
    output  logic           s_axis_s2mm_tvalid
);

    assign s_axis_s2mm_tdata = 0;
    assign s_axis_s2mm_tdest = 0; 
    assign s_axis_s2mm_tid = 0;   
    assign s_axis_s2mm_tkeep = 4'b1111; 
    assign s_axis_s2mm_tlast = 0; 
    assign s_axis_s2mm_tuser = 0; 

    logic[3:0] state=0, next_state;
    always_ff @(posedge clk) state <= next_state;
    
    logic length_count_inc;
    logic length_count_clr;
    logic[31:0] length_count;
    always_comb begin
        // defaults
        next_state = state;
        busy = 0;
        length_count_inc = 0;
        length_count_clr = 0;
        s_axis_s2mm_tvalid = 0;
        
        case (state)
        
            0: begin
                next_state = 1;
            end
            
            1: begin
                length_count_clr = 1;
                if (run) begin
                    next_state = 2;
                end
            end 
            
            2: begin
                busy = 1;
                if (s_axis_s2mm_tready) begin
                    length_count_inc = 1;
                    if (length_count == length) begin
                        next_state = 3;
                    end else begin                    
                        s_axis_s2mm_tvalid = 1;
                    end
                end
            end
            
            3: begin
                next_state = 1;
            end
            
            default: begin
                next_state = 0;
            end
             
        endcase
    end    
    
    always_ff @(posedge clk) begin
    end
        
endmodule
