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
