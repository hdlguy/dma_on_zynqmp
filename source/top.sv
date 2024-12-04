//
module top (
    output  logic           pl_led1,
    output  logic           fan_pwm,
    input   logic           clkin200_p,
    input   logic           clkin200_n,
    //
    input   logic           uart_rxd,
    output  logic           uart_txd        
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
    
    logic [31:0]s_axis_s2mm_tdata;
    logic [3:0]s_axis_s2mm_tdest;
    logic [7:0]s_axis_s2mm_tid;
    logic [3:0]s_axis_s2mm_tkeep;
    logic s_axis_s2mm_tlast;
    logic s_axis_s2mm_tready;
    logic [15:0]s_axis_s2mm_tuser;
    logic s_axis_s2mm_tvalid;    
    
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
        // axis to DMA
        .s_axis_s2mm_tdata  (s_axis_s2mm_tdata),
        .s_axis_s2mm_tdest  (s_axis_s2mm_tdest),
        .s_axis_s2mm_tid    (s_axis_s2mm_tid),
        .s_axis_s2mm_tkeep  (s_axis_s2mm_tkeep),
        .s_axis_s2mm_tlast  (s_axis_s2mm_tlast),
        .s_axis_s2mm_tready (s_axis_s2mm_tready),
        .s_axis_s2mm_tuser  (s_axis_s2mm_tuser),
        .s_axis_s2mm_tvalid (s_axis_s2mm_tvalid),      
        //
        .uart_rxd(uart_rxd),
        .uart_txd(uart_txd)        
    );
    
    // data generator for the DMA
    logic dg_run, dg_busy;
    logic[3:0] dg_chan;
    logic[31:0] dg_length;
	datagen datagen_inst (
	   .clk(clk), .run(dg_run), .busy(dg_busy), .length(dg_length), .chan(dg_chan), 	   
	   .s_axis_s2mm_tdata  (s_axis_s2mm_tdata),      
	   .s_axis_s2mm_tdest  (s_axis_s2mm_tdest),      
	   .s_axis_s2mm_tid    (s_axis_s2mm_tid),        
	   .s_axis_s2mm_tkeep  (s_axis_s2mm_tkeep),      
	   .s_axis_s2mm_tlast  (s_axis_s2mm_tlast),      
	   .s_axis_s2mm_tready (s_axis_s2mm_tready),     
	   .s_axis_s2mm_tuser  (s_axis_s2mm_tuser),      
	   .s_axis_s2mm_tvalid (s_axis_s2mm_tvalid)      	   
	);	    
    
    // This register file gives software control over unit under test (UUT).
    localparam int Nregs = 16;
    logic [Nregs-1:0][31:0] slv_reg, slv_read;

    assign slv_read[0] = 32'hdeadbeef;
    assign slv_read[1] = 32'h76543210;
    
    assign dg_run = slv_reg[2][0];
    assign slv_read[2][1] = dg_busy;
    assign dg_chan  = slv_reg[2][7:4];
    assign slv_read[2][0] = slv_reg[2][0];
    assign slv_read[2][31:2] = slv_reg[2][31:2];
            
    assign dg_length = slv_reg[3];
    assign slv_read[3] = slv_reg[3];

    assign slv_read[Nregs-1:4] = slv_reg[Nregs-1:4];

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
    top_ila clk200_ila_inst (.clk(clk200), .probe0(clk200_count)); // 27
    
    
    top_ila top_ila_inst (.clk(axi_aclk), .probe0({s_axis_s2mm_tdata,s_axis_s2mm_tdest,s_axis_s2mm_tid,s_axis_s2mm_tkeep,s_axis_s2mm_tlast,s_axis_s2mm_tready,s_axis_s2mm_tuser,s_axis_s2mm_tvalid})); // 32+4+8+4+16+3=67
           
endmodule

/*
//    logic [31:0]s_axis_s2mm_tdata;
//    logic [3:0]s_axis_s2mm_tdest;
//    logic [7:0]s_axis_s2mm_tid;
//    logic [3:0]s_axis_s2mm_tkeep;
//    logic s_axis_s2mm_tlast;
//    logic s_axis_s2mm_tready;
//    logic [15:0]s_axis_s2mm_tuser;
//    logic s_axis_s2mm_tvalid;     
*/    
