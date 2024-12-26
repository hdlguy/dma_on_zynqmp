`timescale 1ns / 1ps

module datagen_tb ();

    logic[31:0]      period;
    logic            enable;
    logic            ready;
    logic            clear;    
    logic[3:0]       bram_clk, bram_rst, bram_en;
    logic[3:0][3:0]  bram_we;
    logic[3:0][15:0] bram_addr;
    logic[3:0][31:0] bram_din;
    logic[3:0][31:0] bram_dout;

    localparam time clk_period=10; logic clk=0; always #(clk_period/2) clk=~clk;

    datagen uut (.*);
    
    initial begin
        enable = 0;
        period = 1000-1;
        clear = 0;
        #(clk_period*10);
        enable = 1;
        #(clk_period*10000);
        enable = 0;
        #(clk_period*100);
        $stop();
    end

endmodule


/*
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
*/
