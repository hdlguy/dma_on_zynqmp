// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           run,
    output  logic           busy,
    input   logic[31:0]     length,
    input   logic[3:0]      chan,
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

    assign busy = run;
    assign s_axis_s2mm_tdata = 0;
    assign s_axis_s2mm_tdest = 0; 
    assign s_axis_s2mm_tid = 0;   
    assign s_axis_s2mm_tkeep = 4'b1111; 
    assign s_axis_s2mm_tlast = 0; 
    assign s_axis_s2mm_tuser = 0; 
    assign s_axis_s2mm_tvalid = 0;

    logic[3:0] state=0, next_state;
    always_ff @(posedge clk) state <= next_state;
    
    always_comb begin
        // defaults
        next_state = state;
        
        case (state)
        
            0: begin
            end
            
            default: begin
                next_state = 0;
            end
             
        endcase
    end    
    
    logic[31:0] length_counter;
    logic[1:0]  chan_counter;
    always_ff @(posedge clk) begin
    end
        
endmodule
