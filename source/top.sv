//
module top (
    output  logic           pl_led1,
    output  logic           fan_pwm,
    input   logic           clkin200_p,
    input   logic           clkin200_n  
);

    logic [39:0]    M00_AXI_araddr;
    logic [2:0]     M00_AXI_arprot;
    logic           M00_AXI_arready;
    logic           M00_AXI_arvalid;
    logic [39:0]    M00_AXI_awaddr;
    logic [2:0]     M00_AXI_awprot;
    logic           M00_AXI_awready;
    logic           M00_AXI_awvalid;
    logic           M00_AXI_bready;
    logic [1:0]     M00_AXI_bresp;
    logic           M00_AXI_bvalid;
    logic [31:0]    M00_AXI_rdata;
    logic           M00_AXI_rready;
    logic [1:0]     M00_AXI_rresp;
    logic           M00_AXI_rvalid;
    logic [31:0]    M00_AXI_wdata;
    logic           M00_AXI_wready;
    logic [3:0]     M00_AXI_wstrb;
    logic           M00_AXI_wvalid;

    logic           axi_aclk;
    logic [0:0]     axi_aresetn;
    
    logic[3:0]       bram_clk, bram_rst, bram_en;
    logic[3:0][3:0]  bram_we;
    logic[3:0][15:0] bram_addr;
    logic[3:0][31:0] bram_din, bram_dout;
    
    system system_i (
        // AXI to register file
        .M00_AXI_araddr     (M00_AXI_araddr),
        .M00_AXI_arprot     (M00_AXI_arprot),
        .M00_AXI_arready    (M00_AXI_arready),
        .M00_AXI_arvalid    (M00_AXI_arvalid),
        .M00_AXI_awaddr     (M00_AXI_awaddr),
        .M00_AXI_awprot     (M00_AXI_awprot),
        .M00_AXI_awready    (M00_AXI_awready),
        .M00_AXI_awvalid    (M00_AXI_awvalid),
        .M00_AXI_bready     (M00_AXI_bready),
        .M00_AXI_bresp      (M00_AXI_bresp),
        .M00_AXI_bvalid     (M00_AXI_bvalid),
        .M00_AXI_rdata      (M00_AXI_rdata),
        .M00_AXI_rready     (M00_AXI_rready),
        .M00_AXI_rresp      (M00_AXI_rresp),
        .M00_AXI_rvalid     (M00_AXI_rvalid),
        .M00_AXI_wdata      (M00_AXI_wdata),
        .M00_AXI_wready     (M00_AXI_wready),
        .M00_AXI_wstrb      (M00_AXI_wstrb),
        .M00_AXI_wvalid     (M00_AXI_wvalid),  
        //
        .axi_aclk           (axi_aclk),
        .axi_aresetn        (axi_aresetn),
        // interfaces to data bram
        .bram3_clk          (bram_clk [3]),
        .bram3_addr         (bram_addr[3]),
        .bram3_rst          (bram_rst [3]),
        .bram3_we           (bram_we  [3]),
        .bram3_en           (bram_en  [3]),
        .bram3_din          (bram_din [3]),
        .bram3_dout         (bram_dout[3]),

        .bram2_clk          (bram_clk [2]),
        .bram2_addr         (bram_addr[2]),
        .bram2_rst          (bram_rst [2]),
        .bram2_we           (bram_we  [2]),
        .bram2_en           (bram_en  [2]),
        .bram2_din          (bram_din [2]),
        .bram2_dout         (bram_dout[2]),

        .bram1_clk          (bram_clk [1]),
        .bram1_addr         (bram_addr[1]),
        .bram1_rst          (bram_rst [1]),
        .bram1_we           (bram_we  [1]),
        .bram1_en           (bram_en  [1]),
        .bram1_din          (bram_din [1]),
        .bram1_dout         (bram_dout[1]),

        .bram0_clk          (bram_clk [0]),
        .bram0_addr         (bram_addr[0]),
        .bram0_rst          (bram_rst [0]),
        .bram0_we           (bram_we  [0]),
        .bram0_en           (bram_en  [0]),
        .bram0_din          (bram_din [0]),
        .bram0_dout         (bram_dout[0])
    );
    
    // data generator for the DMA
    logic dg_enable, dg_ready, dg_clear;
    logic[15:0] dg_length;
    logic[31:0] dg_period;
    datagen datagen_inst (
        .clk        (axi_aclk), 
        .enable     (dg_enable),
        .ready      (dg_ready),
        .clear      (dg_clear),
        .period     (dg_period),
        .length     (dg_length),
        //
        .bram_clk   (bram_clk),
        .bram_addr  (bram_addr),
        .bram_rst   (bram_rst),
        .bram_we    (bram_we),
        .bram_en    (bram_en),
        .bram_din   (bram_din),
        .bram_dout  (bram_dout)
    );	    
    
    // This register file gives software control over unit under test (UUT).
    localparam int Nregs = 16;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hcafebabe;
    assign slv_read[1] = 32'h76543210;
    
    assign dg_enable = slv_reg[2][0];
    assign slv_read[2][3:0] = slv_reg[2][3:0];
    assign slv_read[2][4] = dg_ready;
    assign dg_clear = slv_reg[2][8];
    assign slv_read[2][31:5] = slv_reg[2][31:5];
            
    assign dg_length = slv_reg[3][15:0];
    assign slv_read[3] = slv_reg[3];

    assign dg_period = slv_reg[4];
    assign slv_read[4] = slv_reg[4];

    assign slv_read[Nregs-1:5] = slv_reg[Nregs-1:5];

	axi_regfile_v1_0_S00_AXI #	(
		.C_S_AXI_DATA_WIDTH(32),
		.C_S_AXI_ADDR_WIDTH($clog2(Nregs)+2) 
	) axi_regfile_inst (
        // register interface
        .slv_read(slv_read), 
        .slv_reg (slv_reg),  
        // axi interface
		.S_AXI_ACLK    (axi_aclk),
		.S_AXI_ARESETN (axi_aresetn),
        //
		.S_AXI_ARADDR  (M00_AXI_araddr ),
		.S_AXI_ARPROT  (M00_AXI_arprot ),
		.S_AXI_ARREADY (M00_AXI_arready),
		.S_AXI_ARVALID (M00_AXI_arvalid),
		.S_AXI_AWADDR  (M00_AXI_awaddr ),
		.S_AXI_AWPROT  (M00_AXI_awprot ),
		.S_AXI_AWREADY (M00_AXI_awready),
		.S_AXI_AWVALID (M00_AXI_awvalid),
		.S_AXI_BREADY  (M00_AXI_bready ),
		.S_AXI_BRESP   (M00_AXI_bresp  ),
		.S_AXI_BVALID  (M00_AXI_bvalid ),
		.S_AXI_RDATA   (M00_AXI_rdata  ),
		.S_AXI_RREADY  (M00_AXI_rready ),
		.S_AXI_RRESP   (M00_AXI_rresp  ),
		.S_AXI_RVALID  (M00_AXI_rvalid ),
		.S_AXI_WDATA   (M00_AXI_wdata  ),
		.S_AXI_WREADY  (M00_AXI_wready ),
		.S_AXI_WSTRB   (M00_AXI_wstrb  ),
		.S_AXI_WVALID  (M00_AXI_wvalid )
	);
	
	
	logic[26:0] led_count;
    always_ff @(posedge axi_aclk) begin
        led_count <= led_count + 1;
	    pl_led1 <= led_count[26];
	    fan_pwm <= led_count[17] & led_count[16] & led_count[15];
	end


    // let us use the 200MHz differential clock
    logic clkin200, clk200;
    IBUFDS IBUFDS_inst (.O(clkin200 ), .I(clkin200_p),  .IB(clkin200_n));
    BUFG BUFG_inst (.O(clk200), .I(clkin200));
    
	logic[26:0] clk200_count;
    always_ff @(posedge clk200) clk200_count <= clk200_count + 1;
    //top_ila clk200_ila_inst (.clk(clk200), .probe0(clk200_count)); // 27
    
    
    //top_ila top_ila_inst (.clk(axi_aclk), .probe0({s_axis_s2mm_tdata,s_axis_s2mm_tdest,s_axis_s2mm_tid,s_axis_s2mm_tkeep,s_axis_s2mm_tlast,s_axis_s2mm_tready,s_axis_s2mm_tuser,s_axis_s2mm_tvalid})); // 32+4+8+4+16+3=67
           
endmodule

/*
  
*/    
