// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           reset,
    input   logic[31:0]     n_length,
    input   logic[1:0]      n_chan,
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



    
    logic[3:0] state, next_state;
    always_ff @(posedge clk) state <= next_state;
    
    always_comb begin
        // defaults
        next_state = state;
        case (state)
        
            0: begin
            end
             
        endcase
    end
    
    
    logic[31:0] length_counter;
    logic[1:0]  chan_counter;
    always_ff @(posedge clk) begin
        if (reset) begin
        end else begin
        end
    end
    
    
endmodule
