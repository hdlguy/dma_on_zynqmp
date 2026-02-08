`timescale 1ns / 1ps

module datagen_tb ();

    logic[31:0]     period;
    logic[15:0]     length;
    logic           enable;
    logic           ready;
    logic           clear=0;   
     
    logic[3:0]       bram_clk, bram_rst, bram_en;
    logic[3:0][3:0]  bram_we;
    logic[3:0][15:0] bram_addr=0;
    logic[3:0][31:0] bram_din=0;
    logic[3:0][31:0] bram_dout;

    localparam time clk_period=10; logic clk=0; always #(clk_period/2) clk=~clk;
    
    assign bram_clk = {4{clk}};

    datagen uut (.*);
    
    localparam int P = 991;
    localparam int L = 10;
    
    initial begin
        enable = 0;
        period = P-1;
        length = L-1;
        #(clk_period*10);
        enable = 1;
        #(clk_period*10000);
        enable = 0;
        #(clk_period*10000);
        $stop();
    end
    
    always_ff @(posedge clk) clear <= ready;
    
    assign addr_clear = clear;    
    assign bram_en = 4'b1111;
    assign bram_we = 4'b0000;
    
    logic[15:0] addr_count=0;
    always_ff @(posedge clk) begin
        if (addr_clear) begin
            bram_addr <= 0;
        end else begin
            for (int i=0; i<4; i++) begin
                bram_addr[i] <= bram_addr[i] + 4;
            end
        end
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
