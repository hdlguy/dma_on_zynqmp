`timescale 1ns / 1ps

module datagen_tb ();

    logic           run;
    logic           busy;
    logic[31:0]     length;
    logic[1:0]      chan;
    logic[31:0]     s_axis_s2mm_tdata;
    logic[3:0]      s_axis_s2mm_tdest;
    logic[7:0]      s_axis_s2mm_tid;
    logic[3:0]      s_axis_s2mm_tkeep;
    logic           s_axis_s2mm_tlast;
    logic           s_axis_s2mm_tready;
    logic[15:0]     s_axis_s2mm_tuser;
    logic           s_axis_s2mm_tvalid;

    localparam time clk_period=10; logic clk=0; always #(clk_period/2) clk=~clk;

    datagen uut (.*);
    
    assign s_axis_s2mm_tready = 1;
    
    initial begin
        run = 0;
        length = 100-1;
        chan = 0;
        #(clk_period*10);
        run = 1;
        #(clk_period*1000);
        run = 0;
        #(clk_period*100);
        $stop();
    end

endmodule


/*
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
*/
