
module DE2_115_Basic_Computer (
// Clock Inputs
  input         CLOCK_50,    // 50MHz Input 1
  input         CLOCK2_50,   // 50MHz Input 2
  input         CLOCK3_50,   // 50MHz Input 3
  output        SMA_CLKOUT,  // External Clock Output
  input         SMA_CLKIN,   // External Clock Input

  // Push Button
  input  [3:0]  KEY,         // Pushbutton[3:0]

  // DPDT Switch
  input  [17:0] SW,          // Toggle Switch[17:0]

  // 7-SEG Display
  output [6:0]  HEX0,        // Seven Segment Digit 0
  output [6:0]  HEX1,        // Seven Segment Digit 1
  output [6:0]  HEX2,        // Seven Segment Digit 2
  output [6:0]  HEX3,        // Seven S egment Digit 3
  output [6:0]  HEX4,        // Seven Segment Digit 4
  output [6:0]  HEX5,        // Seven Segment Digit 5
  output [6:0]  HEX6,        // Seven Segment Digit 6
  output [6:0]  HEX7,        // Seven Segment Digit 7

  // LED
  output [8:0]  LEDG,        // LED Green[8:0]
  output [17:0] LEDR,        // LED Red[17:0]

  // UART
  output        UART_TXD,    // UART Transmitter
  input         UART_RXD,    // UART Receiver
  output        UART_CTS,    // UART Clear to Send
  input         UART_RTS,    // UART Request to Send

  // IRDA
  input         IRDA_RXD,    // IRDA Receiver

  // SDRAM Interface
  inout  [31:0] DRAM_DQ,     // SDRAM Data bus 32 Bits
  output [12:0] DRAM_ADDR,   // SDRAM Address bus 13 Bits
  output [1:0]  DRAM_BA,     // SDRAM Bank Address
  output [3:0]  DRAM_DQM,    // SDRAM Byte Data Mask 
  output        DRAM_RAS_N,  // SDRAM Row Address Strobe
  output        DRAM_CAS_N,  // SDRAM Column Address Strobe
  output        DRAM_CKE,    // SDRAM Clock Enable
  output        DRAM_CLK,    // SDRAM Clock
  output        DRAM_WE_N,   // SDRAM Write Enable
  output        DRAM_CS_N,   // SDRAM Chip Select

  // Flash Interface
  inout  [7:0]  FL_DQ,       // FLASH Data bus 8 Bits
  output [22:0] FL_ADDR,     // FLASH Address bus 23 Bits
  output        FL_WE_N,     // FLASH Write Enable
  output        FL_WP_N,     // FLASH Write Protect / Programming Acceleration
  output        FL_RST_N,    // FLASH Reset
  output        FL_OE_N,     // FLASH Output Enable
  output        FL_CE_N,     // FLASH Chip Enable
  input         FL_RY,       // FLASH Ready/Busy output

  // SRAM Interface
  inout  [15:0] SRAM_DQ,     // SRAM Data bus 16 Bits
  output [19:0] SRAM_ADDR,   // SRAM Address bus 20 Bits
  output        SRAM_OE_N,   // SRAM Output Enable
  output        SRAM_WE_N,   // SRAM Write Enable
  output        SRAM_CE_N,   // SRAM Chip Enable
  output        SRAM_UB_N,   // SRAM High-byte Data Mask 
  output        SRAM_LB_N,   // SRAM Low-byte Data Mask 

  // ISP1362 Interface
  inout  [15:0] OTG_DATA,    // ISP1362 Data bus 16 Bits
  output [1:0]  OTG_ADDR,    // ISP1362 Address 2 Bits
  output        OTG_CS_N,    // ISP1362 Chip Select
  output        OTG_RD_N,    // ISP1362 Write
  output        OTG_WR_N,    // ISP1362 Read
  output        OTG_RST_N,   // ISP1362 Reset
  input  [1:0]  OTG_INT,     // ISP1362 Interrupts
  inout         OTG_FSPEED,  // USB Full Speed, 0 = Enable, Z = Disable
  inout         OTG_LSPEED,  // USB Low Speed,  0 = Enable, Z = Disable
  input  [1:0]  OTG_DREQ,    // ISP1362 DMA Request
  output [1:0]  OTG_DACK_N,  // ISP1362 DMA Acknowledge

  // LCD Module 16X2
  inout  [7:0]  LCD_DATA,    // LCD Data bus 8 bits
  output        LCD_ON,      // LCD Power ON/OFF
  output        LCD_BLON,    // LCD Back Light ON/OFF
  output        LCD_RW,      // LCD Read/Write Select, 0 = Write, 1 = Read
  output        LCD_EN,      // LCD Enable
  output        LCD_RS,      // LCD Command/Data Select, 0 = Command, 1 = Data

  // SD Card Interface
  inout  [3:0]  SD_DAT,      // SD Card Data
  inout         SD_CMD,      // SD Card Command Line
  output        SD_CLK,      // SD Card Clock
  input         SD_WP_N,     // SD Write Protect

  // EEPROM Interface
  output        EEP_I2C_SCLK, // EEPROM Clock
  inout         EEP_I2C_SDAT, // EEPROM Data

  // PS2
  inout         PS2_DAT,     // PS2 Data
  inout         PS2_CLK,     // PS2 Clock
  inout         PS2_DAT2,    // PS2 Data 2 (use for 2 devices and y-cable)
  inout         PS2_CLK2,    // PS2 Clock 2 (use for 2 devices and y-cable)

  // I2C  
  inout         I2C_SDAT,    // I2C Data
  output        I2C_SCLK,    // I2C Clock

  // Audio CODEC
  inout         AUD_ADCLRCK, // Audio CODEC ADC LR Clock
  input         AUD_ADCDAT,  // Audio CODEC ADC Data
  inout         AUD_DACLRCK, // Audio CODEC DAC LR Clock
  output        AUD_DACDAT,  // Audio CODEC DAC Data
  inout         AUD_BCLK,    // Audio CODEC Bit-Stream Clock
  output        AUD_XCK,     // Audio CODEC Chip Clock

  // Ethernet Interface (88E1111)
  input         ENETCLK_25,    // Ethernet clock source

  output        ENET0_GTX_CLK, // GMII Transmit Clock 1
  input         ENET0_INT_N,   // Interrupt open drain output 1
  input         ENET0_LINK100, // Parallel LED output of 100BASE-TX link 1
  output        ENET0_MDC,     // Management data clock ref 1
  inout         ENET0_MDIO,    // Management data 1
  output        ENET0_RST_N,   // Hardware Reset Signal 1
  input         ENET0_RX_CLK,  // GMII and MII receive clock 1
  input         ENET0_RX_COL,  // GMII and MII collision 1
  input         ENET0_RX_CRS,  // GMII and MII carrier sense 1
  input   [3:0] ENET0_RX_DATA, // GMII and MII receive data 1
  input         ENET0_RX_DV,   // GMII and MII receive data valid 1
  input         ENET0_RX_ER,   // GMII and MII receive error 1
  input         ENET0_TX_CLK,  // MII Transmit clock 1
  output  [3:0] ENET0_TX_DATA, // MII Transmit data 1
  output        ENET0_TX_EN,   // GMII and MII transmit enable 1
  output        ENET0_TX_ER,   // GMII and MII transmit error 1

  output        ENET1_GTX_CLK, // GMII Transmit Clock 1
  input         ENET1_INT_N,   // Interrupt open drain output 1
  input         ENET1_LINK100, // Parallel LED output of 100BASE-TX link 1
  output        ENET1_MDC,     // Management data clock ref 1
  inout         ENET1_MDIO,    // Management data 1
  output        ENET1_RST_N,   // Hardware Reset Signal 1
  input         ENET1_RX_CLK,  // GMII and MII receive clock 1
  input         ENET1_RX_COL,  // GMII and MII collision 1
  input         ENET1_RX_CRS,  // GMII and MII carrier sense 1
  input   [3:0] ENET1_RX_DATA, // GMII and MII receive data 1
  input         ENET1_RX_DV,   // GMII and MII receive data valid 1
  input         ENET1_RX_ER,   // GMII and MII receive error 1
  input         ENET1_TX_CLK,  // MII Transmit clock 1
  output  [3:0] ENET1_TX_DATA, // MII Transmit data 1
  output        ENET1_TX_EN,   // GMII and MII transmit enable 1
  output        ENET1_TX_ER,   // GMII and MII transmit error 1

  // Expansion Header
  inout   [6:0] EX_IO,       // 14-pin GPIO Header
  inout  [35:0] GPIO,        // 40-pin Expansion header

  // TV Decoder
  input  [8:0]  TD_DATA,     // TV Decoder Data
  input         TD_CLK27,    // TV Decoder Clock Input
  input         TD_HS,       // TV Decoder H_SYNC
  input         TD_VS,       // TV Decoder V_SYNC
  output        TD_RESET_N,  // TV Decoder Reset

  // VGA
  output        VGA_CLK,     // VGA Clock
  output        VGA_HS,      // VGA H_SYNC
  output        VGA_VS,      // VGA V_SYNC
  output        VGA_BLANK_N, // VGA BLANK
  output        VGA_SYNC_N,  // VGA SYNC
  output [7:0]  VGA_R,       // VGA Red[9:0]
  output [7:0]  VGA_G,       // VGA Green[9:0]
  output [7:0]  VGA_B       // VGA Blue[9:0]
);

/*
  // Turn off all displays.
  assign HEX0 = 7'h7F;
  assign HEX1 = 7'h7F;
  assign HEX2 = 7'h7F;
  assign HEX3 = 7'h7F;
  assign HEX4 = 7'h7F;
  assign HEX5 = 7'h7F;
  assign HEX6 = 7'h7F;
  assign HEX7 = 7'h7F;
*/
  // Set all GPIO to tri-state.
  assign GPIO = 36'hzzzzzzzzz;
  assign EX_IO = 7'hzzzzzzzzz;

  // Disable audio codec.
  // assign AUD_DACDAT = 1'b0;
  // assign AUD_XCK    = 1'b0;


  // Disable flash.
  assign FL_ADDR  = 23'h0;
  assign FL_CE_N  = 1'b1;
  assign FL_DQ    = 8'hzz;
  assign FL_OE_N  = 1'b1;
  assign FL_RST_N = 1'b1;
  assign FL_WE_N  = 1'b1;
  assign FL_WP_N  = 1'b0;

  // Disable LCD.
  assign LCD_BLON = 1'b0;
  assign LCD_DATA = 8'hzz;
  assign LCD_EN   = 1'b0;
  assign LCD_ON   = 1'b0;
  assign LCD_RS   = 1'b0;
  assign LCD_RW   = 1'b0;

  // Disable OTG.
  assign OTG_ADDR    = 2'h0;
  assign OTG_CS_N    = 1'b1;
  assign OTG_DACK_N  = 2'b11;
  assign OTG_FSPEED  = 1'b1;
  assign OTG_DATA    = 16'hzzzz;
  assign OTG_LSPEED  = 1'b1;
  assign OTG_RD_N    = 1'b1;
  assign OTG_RST_N   = 1'b1;
  assign OTG_WR_N    = 1'b1;

  // Disable SD
  assign SD_DAT = 4'bzzzz;
  assign SD_CLK = 1'b0;
  assign SD_CMD = 1'b0;




//	For Delay Timer
wire			DLY0;
wire			DLY1;
wire			DLY2;


//	Reset Delay Timer
Reset_Delay			u3	(	.iCLK(CLOCK_50),
							.iRST(KEY[0]),
							.oRST_0(DLY0),  // Delay by 0.0026 sec
							.oRST_1(DLY1),  // Delay by 0.0039 sec
							.oRST_2(DLY2)); // Delay by 0.0838 sec

  ///////////////////////////////////////
  // Main program
  ///////////////////////////////////////

  assign TD_RESET_N = 1'b1;  // Enable 27MHz Clock

  /*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
//  Used to connect the Nios II system clock to the non-shifted output of the PLL
wire				system_clock;
wire        nios_opts;
nios_system NiosII (
	// 1) global signals:
	.clk									(system_clock),
	.reset_n								(KEY[0]),

	.dda_options_external_interface_export(nios_opts),
	// the_Green_LEDs
	.LEDG_from_the_Green_LEDs				(LEDG),

	// the_HEX3_HEX0
	.HEX0_from_the_HEX3_HEX0				(HEX0),
	.HEX1_from_the_HEX3_HEX0				(HEX1),
	.HEX2_from_the_HEX3_HEX0				(HEX2),
	.HEX3_from_the_HEX3_HEX0				(HEX3),
	



	// the_SDRAM
	.zs_addr_from_the_SDRAM					(DRAM_ADDR),
	.zs_ba_from_the_SDRAM					(DRAM_BA),
	.zs_cas_n_from_the_SDRAM				(DRAM_CAS_N),
	.zs_cke_from_the_SDRAM					(DRAM_CKE),
	.zs_cs_n_from_the_SDRAM					(DRAM_CS_N),
	.zs_dq_to_and_from_the_SDRAM			(DRAM_DQ),
	.zs_dqm_from_the_SDRAM					(DRAM_DQM),
	.zs_ras_n_from_the_SDRAM				(DRAM_RAS_N),
	.zs_we_n_from_the_SDRAM					(DRAM_WE_N)
	

	);

sdram_pll neg_3ns (CLOCK_50, DRAM_CLK, system_clock);

wire	VGA_CTRL_CLK;


vga_pll 		p1	(	.areset(),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1());

wire		[9:0]	VGA_X;
wire		[8:0]	VGA_Y;
 				
JULIE	julies_vga_ctrl	(	
	//	Host Side
	.iRed 		(mVGA_R),
	.iGreen 	   (mVGA_G),
	.iBlue 		(mVGA_B),
	.oCurrent_X (VGA_X),
	.oCurrent_Y (VGA_Y),
	//.oAddress 	(VGA_Addr_full_d0), 
	//.oRequest 	(VGA_Read),
	//	VGA Side
	.oVGA_R 	(VGA_R),
	.oVGA_G 	(VGA_G),
	.oVGA_B 	(VGA_B),
	.oVGA_HS 	(VGA_HS),
	.oVGA_VS 	(VGA_VS),
	.oVGA_SYNC 	(VGA_SYNC_N),
	.oVGA_BLANK (VGA_BLANK_N),
	.oVGA_CLOCK (VGA_CLK),
	//	Control Signal
	.iCLK 		(VGA_CTRL_CLK),
	.iRST_N 		(DLY2)	
);

wire [7:0]	mVGA_R;				//memory output to VGA
wire [7:0]	mVGA_G;
wire [7:0]	mVGA_B;

assign mVGA_R = (8'd179>>(negColorData));
assign mVGA_G = (8'd27>>(negColorData));
assign mVGA_B = (8'd27>>(negColorData));
wire [2:0] colorData;
reg  [2:0] negColorData;
////////////////////////////////////
//CA state machine variables
wire reset;


localparam SCREEN_WIDTH = 10'd640;
localparam SCREEN_HEIGHT= 10'd480;
reg [SCREEN_WIDTH-1:0] currentGen;
reg [SCREEN_WIDTH-1:0] nextGen;


////////////////////////////////////
/*From megaWizard:
	module vga_buffer (
	address_a, // use a for state machine
	address_b, // use b for VGA refresh
	clock_a,
	clock_b,
	data_a,
	data_b,
	wren_a,
	wren_b,
	q_a,
	q_b);*/
// Show m4k on the VGA
// -- use m4k a for state machine
// -- use m4k b for VGA refresh

hotter_buffer buffbuffbuff(
	.data(arb_data),
	.rdaddress(VGAX+(VGAY*640)),
	.rdclock(VGA_CTRL_CLK),
	.wraddress(arb_addr),
	.wrclock(CLOCK_50),
	.wren(arb_wren),
	.q(colorData)
	);
	
// DLA state machine
assign reset = ~KEY[0];
assign clk   = CLOCK_50;
always @ (negedge VGA_CTRL_CLK)
begin
	// register the m9k output for better timing on VGA
	// negedge seems to work better than posedge
	negColorData <= colorData;
end

//////////////////////////////////////////////////////////////////////
//                           LAB 4 STUFF                            //
//////////////////////////////////////////////////////////////////////
  wire [3:0]  iProcReady;
  wire [3:0]  oDataVal;
  wire [35:0] oDataXSignal;
  wire [35:0] oDataYSignal;
  wire [9:0]  oVGAX;
  wire [8:0]  oVGAY;
  wire        oCoordRdy;
  wire [35:0] iCoordX;
  wire [35:0] iCoordY;
  wire        iCoordVal;
  wire [9:0]  iVGAX;
  wire [8:0]  iVGAY;

  wire m0ProcReady;
  wire m1ProcReady;
  wire m2ProcReady;
  wire m3ProcReady;

  wire [18:0] iProc0VGA;
  wire [18:0] iProc1VGA;
  wire [18:0] iProc2VGA;
  wire [18:0] iProc3VGA;

  wire [7:0]  iProc0Color;
  wire [7:0]  iProc1Color;
  wire [7:0]  iProc2Color;
  wire [7:0]  iProc3Color;

  wire [3:0]  iProcVal;
  wire [3:0]  oProcRdy;

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;
  
  wire [35:0] upperLeftX;
  wire [35:0] upperLeftY;
  wire [4:0]  zoomLevel;

  wire [17:0] niosUpperLeftX;
  wire [17:0] niosUpperLeftY;

  assign upperLeftX = {2'd0,niosUpperLeftX,16'd0};
  assign upperLeftY = {2'd0,niosUpperLeftY,16'd0};
  
  nios_param_driver npd1 (
   .clk(CLOCK_50),
   .reset(reset),
   .niosDDA_cmd(nios_opts),  
   .xCoord(niosUpperLeftX),
   .yCoord(niosUpperLeftY),
   .zoom(zoomLevel)
   );
//////////////////////////// NOTE: CURRENTLY IGNORING NIOS INPUTS HERE ////////////////////////////
  coordGenerator c1 (
    .clk(clk),
    .reset(reset),

  // inputs from NIOS
  .zoomLevel(4'd0),
  .upperLeftX(36'hF_00000000),
  .upperLeftY(36'hF_00000000),
  .draw(~KEY[3]),

  // inputs from Load Dist
  .iLoadDistRdy(oCoordRdy),

  // outputs to Load Dist
  .oLoadDistVal(iCoordVal),
  .oVGAX(iVGAX),
  .oVGAY(iVGAY),
  .oCoordX(iCoordX),
  .oCoordY(iCoordY)
  );

  loadBalancer #(4) lb1 (
    .clk(clk),
    .reset(reset),

  // input ready signals from processors 
    .iProcReady(iProcReady),
  
  // input from coordinate generation
    .iCoordVal(iCoordVal),
    .iCoordX(iCoordX),
    .iCoordY(iCoordY),
    .iVGAX(iVGAX),
    .iVGAY(iVGAY),

  // output val, ready, signal groups to procs
    .oDataVal(oDataVal),
    .oDataXSignal(oDataXSignal),
    .oDataYSignal(oDataYSignal),
    .oVGAX(oVGAX),
    .oVGAY(oVGAY),

  // output ready, val signal groups to coordinate generator
    .oCoordRdy(oCoordRdy)
);

  mandlebrotProcessor #(100) m0 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[0]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m0ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[0]), 

  // signals sent to VGA buffer
    .oColor(iProc0Color),
    .oVGACoord(iProc0VGA),
    .oVGAVal(iProcVal[0])    
);

  mandlebrotProcessor #(100) m1 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[1]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m1ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[1]),

  // signals sent to VGA buffer
    .oColor(iProc1Color),
    .oVGACoord(iProc1VGA),
    .oVGAVal(iProcVal[1])
 );

  mandlebrotProcessor #(100) m2 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[2]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m2ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[2]),

  // signals sent to VGA buffer
    .oColor(iProc2Color),
    .oVGACoord(iProc2VGA),
    .oVGAVal(iProcVal[2])
 );

  mandlebrotProcessor #(100) m3 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[3]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m3ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[3]),

  // signals sent to VGA buffer
    .oColor(iProc3Color),
    .oVGACoord(iProc3VGA),
    .oVGAVal(iProcVal[3])
);

  wire [18:0] arb_addr;
  wire [2:0] arb_data;
  wire arb_wren;
  
proc2memArb p2m1 (
  .clk(clk),
  .reset(reset),

  // VGA data inputs from processors
  .iProc0VGA(iProc0VGA),
  .iProc1VGA(iProc1VGA),
  .iProc2VGA(iProc2VGA),
  .iProc3VGA(iProc3VGA),

  .iProc0Color(iProc0Color),
  .iProc1Color(iProc1Color),
  .iProc2Color(iProc2Color),
  .iProc3Color(iProc3Color), 

  // ready signals from processors
  .iProcRdy(iProcVal),

  // output signals to processors
  .oProcRdy(oProcRdy),

  // output signals to VGA buffer
  .addr(arb_addr),
  .data(arb_data),
  .w_en(arb_wren)
 );
  
endmodule //top module

