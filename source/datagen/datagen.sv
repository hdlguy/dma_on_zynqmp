// data generator to feed AXI Multichannel DMA core
module datagen(
    input   logic           clk,
    //
    input   logic           run,
    output  logic           done,
    input   logic[31:0]     length,  // lenght of transfer minus 1.
    input   logic[3:0]      chan,    // which channels to generate
    //
    output  logic[31:0]     m_axis_tdata,
    output  logic[3:0]      m_axis_tdest,
    output  logic[7:0]      m_axis_tid,
    output  logic[3:0]      m_axis_tkeep,
    output  logic           m_axis_tlast,
    input   logic           m_axis_tready,
    output  logic[15:0]     m_axis_tuser,
    output  logic           m_axis_tvalid
);


    logic[3:0] state=0, next_state;
    always_ff @(posedge clk) state <= next_state;
    
    logic length_count_inc;
    logic length_count_clr;
    logic[31:0] length_count;
    always_comb begin
        // defaults
        next_state = state;
        done = 0;
        length_count_inc = 0;
        length_count_clr = 0;
        m_axis_tvalid = 0;
        m_axis_tlast = 0;
        
        case (state)
        
            0: begin
                done = 1;
                next_state = 1;
            end
            
            1: begin
                length_count_clr = 1;
                done = 1;
                if (run) begin
                    next_state = 2;
                end
            end 
            
            2: begin
                m_axis_tvalid = 1;
                if (m_axis_tready) begin
                    length_count_inc = 1;
                    if (length_count == length) begin
                        next_state = 3;
                    end
                end                
                if (length_count == length) begin
                    m_axis_tlast = 1;
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
        if (length_count_clr) begin
            length_count <= 0;
        end else begin
            if (length_count_inc) begin
                length_count <= length_count + 1;
            end
        end
    end

    assign m_axis_tdata = length_count;
    assign m_axis_tdest = 0; 
    assign m_axis_tid = 0;   
    assign m_axis_tkeep = 4'b1111; 
    assign m_axis_tuser = 0; 
            
endmodule
