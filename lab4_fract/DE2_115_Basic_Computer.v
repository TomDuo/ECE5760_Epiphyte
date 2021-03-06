
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
wire							  system_clock;
wire unsigned [9:0]       nios_cursorx;
wire unsigned [8:0]       nios_cursory;
wire unsigned [4:0]       nios_zoom;
wire             			  cursor_update_clk;
assign LCD_ON = 1'b1;
assign LCD_BLON = 1'b1;

wire signed [35:0] nios_upper_leftx;
wire signed [35:0] nios_upper_lefty;

assign nios_upper_leftx[3:0] = 4'd0;
assign nios_upper_lefty[3:0] = 4'd0;

nios_system NiosII (
	// 1) global signals:
	.clk									(system_clock),
	.reset_n								(KEY[0]),
	
	.ps2_0_external_interface_CLK          (PS2_CLK),          //       ps2_0_external_interface.CLK
   .ps2_0_external_interface_DAT          (PS2_DAT),          //                               .DAT
	.lcd_16207_0_external_RS               (LCD_RS),               //           lcd_16207_0_external.RS
	.lcd_16207_0_external_RW               (LCD_RW),               //                               .RW
	.lcd_16207_0_external_data             (LCD_DATA),             //                               .data
	.lcd_16207_0_external_E                (LCD_EN),                 //                               .E
	// the_Green_LEDs
	.LEDG_from_the_Green_LEDs				(LEDG),

	// the_HEX3_HEX0
	.HEX0_from_the_HEX3_HEX0				(HEX0),
	.HEX1_from_the_HEX3_HEX0				(HEX1),
	.HEX2_from_the_HEX3_HEX0				(HEX2),
	.HEX3_from_the_HEX3_HEX0				(HEX3),
	
	.nios_cursorx_export                (nios_cursorx),
	.nios_cursory_export                (nios_cursory),
	.nios_zoom_export                   (nios_zoom),
	.cursor_update_clk_export           (cursor_update_clk),
	.nios_upper_leftx_export				(nios_upper_leftx[35:4]),
	.nios_upper_lefty_export            (nios_upper_lefty[35:4]),
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

reg [9:0]	mVGA_R;				//memory output to VGA
reg [9:0]	mVGA_G;
reg [9:0]	mVGA_B;

wire cursorNearX = (VGA_X-9'd1 == cursorX) || (VGA_X == cursorX) || (VGA_X+9'd1 == cursorX);
wire cursorNearY = (VGA_Y-8'd1 == cursorY) || (VGA_Y == cursorY) || (VGA_Y+8'd1 == cursorY);

  
reg unsigned [9:0] cursorX = 9'd50;
reg unsigned [8:0] cursorY = 9'd200;
reg signed [35:0] upperLeftX = ~(36'h2_0000_0001);
reg signed [35:0] upperLeftY = ~(36'h1_0000_0001);
reg unsigned [4:0] zoom = 5'd0;
reg unsigned [4:0] oldZoom = 5'd0;
reg drawTrigger;
always @(posedge cursor_update_clk) begin
	cursorX <= nios_cursorx;
	cursorY <= nios_cursory;
	upperLeftX <= nios_upper_leftx;
	upperLeftY <= nios_upper_lefty;
	zoom <= nios_zoom;
	if (reset) begin
	oldZoom <= nios_zoom;
	end
	else if (zoom != oldZoom) begin
	drawTrigger <= 1;
	oldZoom <= zoom;
	end
	else begin
	drawTrigger <= 0;
	oldZoom <= zoom;
	end
end
always @(*) begin
	if(cursorNearX && cursorNearY) begin
		mVGA_R = 10'd1023;
		mVGA_G = 10'd1023;
		mVGA_B = 10'd1023;
	end
	else begin
		mVGA_R = (10'd1023 - (negColorData<<5));
		mVGA_G = 10'd0; //(10'd100>>(negColorData));
		mVGA_B = 10'd0; //(10'd100>>(negColorData));
	end
end
wire [4:0] colorData;
reg  [4:0] negColorData;
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
	.rdaddress(VGA_X+(VGA_Y*640)),
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
  wire [15:0]  iProcReady;
  wire [15:0]  oDataVal;
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
  wire m4ProcReady;
  wire m5ProcReady;
  wire m6ProcReady;
  wire m7ProcReady;
  wire m8ProcReady;
  wire m9ProcReady;
  wire m10ProcReady;
  wire m11ProcReady;
  wire m12ProcReady;
  wire m13ProcReady;
  wire m14ProcReady;
  wire m15ProcReady;

  wire [18:0] iProc0VGA;
  wire [18:0] iProc1VGA;
  wire [18:0] iProc2VGA;
  wire [18:0] iProc3VGA;
  wire [18:0] iProc4VGA;
  wire [18:0] iProc5VGA;
  wire [18:0] iProc6VGA;
  wire [18:0] iProc7VGA;
  wire [18:0] iProc8VGA;
  wire [18:0] iProc9VGA;
  wire [18:0] iProc10VGA;
  wire [18:0] iProc11VGA;
  wire [18:0] iProc12VGA;
  wire [18:0] iProc13VGA;
  wire [18:0] iProc14VGA;
  wire [18:0] iProc15VGA;

  wire [7:0]  iProc0Color;
  wire [7:0]  iProc1Color;
  wire [7:0]  iProc2Color;
  wire [7:0]  iProc3Color;
  wire [7:0]  iProc4Color;
  wire [7:0]  iProc5Color;
  wire [7:0]  iProc6Color;
  wire [7:0]  iProc7Color;
  wire [7:0]  iProc8Color;
  wire [7:0]  iProc9Color;
  wire [7:0]  iProc10Color;
  wire [7:0]  iProc11Color;
  wire [7:0]  iProc12Color;
  wire [7:0]  iProc13Color;
  wire [7:0]  iProc14Color;
  wire [7:0]  iProc15Color;

  wire [15:0]  iProcVal;
  wire [15:0]  oProcRdy;

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;
  assign iProcReady[4] = m4ProcReady;
  assign iProcReady[5] = m5ProcReady;
  assign iProcReady[6] = m6ProcReady;
  assign iProcReady[7] = m7ProcReady;
  assign iProcReady[8] = m8ProcReady;
  assign iProcReady[9] = m9ProcReady;
  assign iProcReady[10] = m10ProcReady;
  assign iProcReady[11] = m11ProcReady;
  assign iProcReady[12] = m12ProcReady;
  assign iProcReady[13] = m13ProcReady;
  assign iProcReady[14] = m14ProcReady;
  assign iProcReady[15] = m15ProcReady;
  



  
  wire done;
  reg [16:0] timerCounter;
  reg [15:0] mSecCounter;
  

  
  
  always @(posedge CLOCK_50) begin
    if (~KEY[3]||drawTrigger) begin
      // reset
      timerCounter <= 0;
      mSecCounter  <= 0;
    end
    else if (~done && (mSecCounter == 16'd50000)) begin
      timerCounter <= timerCounter + 1;
      mSecCounter  <= 16'd0;
    end
    else begin
      mSecCounter <= mSecCounter + 1;
    end
  end

  hex_7seg hex7 (timerCounter[15:12],HEX7);
  hex_7seg hex6 (timerCounter[11:8],HEX6);
  hex_7seg hex5 (timerCounter[7:4],HEX5);
  hex_7seg hex4 (timerCounter[3:0],HEX4);


//////////////////////////// NOTE: CURRENTLY IGNORING NIOS INPUTS HERE ////////////////////////////
  coordGenerator c1 (
    .clk(clk),
    .reset(reset),

  // inputs from NIOS
  .zoomLevel(zoom),
  .upperLeftX(upperLeftX),
  .upperLeftY(upperLeftY),
  .draw(drawTrigger||~KEY[3]),

  // inputs from Load Dist
  .iLoadDistRdy(oCoordRdy),

  // outputs to Load Dist
  .oLoadDistVal(iCoordVal),
  .oVGAX(iVGAX),
  .oVGAY(iVGAY),
  .oCoordX(iCoordX),
  .oCoordY(iCoordY),
  .done(done)
  );

  loadBalancer #(16) lb1 (
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

  mandlebrotProcessor #(1200) m0 (
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

  mandlebrotProcessor #(1200) m1 (
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

  mandlebrotProcessor #(1200) m2 (
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

  mandlebrotProcessor #(1200) m3 (
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

  mandlebrotProcessor #(1200) m4 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[4]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m4ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[4]), 

  // signals sent to VGA buffer
    .oColor(iProc4Color),
    .oVGACoord(iProc4VGA),
    .oVGAVal(iProcVal[4])    
);
  mandlebrotProcessor #(1200) m5 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[5]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m5ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[5]), 

  // signals sent to VGA buffer
    .oColor(iProc5Color),
    .oVGACoord(iProc5VGA),
    .oVGAVal(iProcVal[5])    
);
  mandlebrotProcessor #(1200) m6 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[6]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m6ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[6]), 

  // signals sent to VGA buffer
    .oColor(iProc6Color),
    .oVGACoord(iProc6VGA),
    .oVGAVal(iProcVal[6])    
);
  mandlebrotProcessor #(1200) m7 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[7]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m7ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[7]), 

  // signals sent to VGA buffer
    .oColor(iProc7Color),
    .oVGACoord(iProc7VGA),
    .oVGAVal(iProcVal[7])    
);  
mandlebrotProcessor #(1200) m8 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[8]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m8ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[8]), 

  // signals sent to VGA buffer
    .oColor(iProc8Color),
    .oVGACoord(iProc8VGA),
    .oVGAVal(iProcVal[8])    
);  
mandlebrotProcessor #(1200) m9 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[9]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m9ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[9]), 

  // signals sent to VGA buffer
    .oColor(iProc9Color),
    .oVGACoord(iProc9VGA),
    .oVGAVal(iProcVal[9])    
);  
mandlebrotProcessor #(1200) m10 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[10]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m10ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[10]), 

  // signals sent to VGA buffer
    .oColor(iProc10Color),
    .oVGACoord(iProc10VGA),
    .oVGAVal(iProcVal[10])    
);
mandlebrotProcessor #(1200) m11 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[11]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m11ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[11]), 

  // signals sent to VGA buffer
    .oColor(iProc11Color),
    .oVGACoord(iProc11VGA),
    .oVGAVal(iProcVal[11])    
);
mandlebrotProcessor #(1200) m12 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[12]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m12ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[12]), 

  // signals sent to VGA buffer
    .oColor(iProc12Color),
    .oVGACoord(iProc12VGA),
    .oVGAVal(iProcVal[12])    
);
mandlebrotProcessor #(1200) m13 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[13]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m13ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[13]), 

  // signals sent to VGA buffer
    .oColor(iProc13Color),
    .oVGACoord(iProc13VGA),
    .oVGAVal(iProcVal[13])    
);
mandlebrotProcessor #(1200) m14 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[14]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m14ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[14]), 

  // signals sent to VGA buffer
    .oColor(iProc14Color),
    .oVGACoord(iProc14VGA),
    .oVGAVal(iProcVal[14])    
);
mandlebrotProcessor #(1200) m15 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[15]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m15ProcReady),

  // input from arbitor
    .valueStored(oProcRdy[15]), 

  // signals sent to VGA buffer
    .oColor(iProc15Color),
    .oVGACoord(iProc15VGA),
    .oVGAVal(iProcVal[15])    
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
  .iProc4VGA(iProc4VGA),
  .iProc5VGA(iProc5VGA),
  .iProc6VGA(iProc6VGA),
  .iProc7VGA(iProc7VGA),
  .iProc8VGA(iProc8VGA),
  .iProc9VGA(iProc9VGA),
  .iProc10VGA(iProc10VGA),
  .iProc11VGA(iProc11VGA),
  .iProc12VGA(iProc12VGA),
  .iProc13VGA(iProc13VGA),
  .iProc14VGA(iProc14VGA),
  .iProc15VGA(iProc15VGA),

  .iProc0Color(iProc0Color),
  .iProc1Color(iProc1Color),
  .iProc2Color(iProc2Color),
  .iProc3Color(iProc3Color),
  .iProc4Color(iProc4Color),
  .iProc5Color(iProc5Color),
  .iProc6Color(iProc6Color),
  .iProc7Color(iProc7Color),
  .iProc8Color(iProc8Color), 
  .iProc9Color(iProc9Color), 
  .iProc10Color(iProc10Color),  
  .iProc11Color(iProc11Color),  
  .iProc12Color(iProc12Color),  
  .iProc13Color(iProc13Color),  
  .iProc14Color(iProc14Color),  
  .iProc15Color(iProc15Color),  

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

