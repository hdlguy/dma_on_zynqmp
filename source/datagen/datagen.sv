// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           enable,
    output  logic           ready,
    input   logic           clear,
    //
    input   logic[3:0]       bram_clk, bram_rst, bram_en,
    input   logic[3:0][3:0]  bram_we,
    input   logic[3:0][15:0] bram_addr,
    input   logic[3:0][31:0] bram_din,
    output  logic[3:0][31:0] bram_dout
);

    logic[3:0][1:0] web;
    logic[3:0][14:0] addrb;
    logic[3:0][15:0] dinb;
    generate for (genvar i=0; i<4; i++) begin
        dgen_mem #(.size(2**16), .awidth(32), .bwidth(16)) mem_inst (
            .clka(bram_clk[i]), .wea(bram_we[i]), .addra(bram_addr[i][15:2]), .dina(bram_din[i]), .douta(bram_dout[i]), 
            .clkb(clk), .web(web[i]), .addrb(addrb[i]), .dinb(dinb[i]), .doutb() 
        );
    end endgenerate

    assign web = 0;
    assign addrb = 0;
    assign dinb = 0;

    logic[3:0] state=0, next_state;
    always_ff @(posedge clk) state <= next_state;
    
    always_comb begin
        // defaults
        next_state = state;
        ready = 0;
        
        case (state)
        
            0: begin
                next_state = 1;
            end
            
            1: begin
                next_state = 0;
            end 
            
            default: begin
                next_state = 0;
            end
             
        endcase
    end    
    
            
endmodule


/*
module dgen_mem #(
    parameter int size   = 2**16,   // size in bytes
    parameter int awidth = 32,      // multiple of 8
    parameter int bwidth = 16,       // mutiple of 8
    parameter int Naddra = size*8/awidth,
    parameter int Naddrb = size*8/bwidth
) (
    input   logic               clka,
    input   logic[awidth/8-1:0] wea,
    input   logic[Naddra-1:0]   addra,
    input   logic[awidth-1:0]   dina,
    input   logic[awidth-1:0]   douta,
    input   logic               clkb,
    input   logic[bwidth/8-1:0] web,
    input   logic[Naddrb-1:0]   addrb,
    input   logic[bwidth-1:0]   dinb,
    input   logic[bwidth-1:0]   doutb
);
*/
