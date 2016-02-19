
module DE2_115_Basic_Computer (
	// Inputs
	CLOCK_50,
	KEY,
	SW,
	//  Communication
	UART_RXD,
	
/*****************************************************************************/
	// Bidirectionals
	GPIO,

	// Memory (SRAM)
	SRAM_DQ,
	
	// Memory (SDRAM)
	DRAM_DQ,

/*****************************************************************************/
	// Outputs
	// 	Simple
	LEDG,
	LEDR,

	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,
	
	// 	Memory (SRAM)
	SRAM_ADDR,

	SRAM_CE_N,
	SRAM_WE_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_LB_N,
	
	//  Communication
	UART_TXD,
	
	// Memory (SDRAM)
	DRAM_ADDR,
	
	DRAM_BA,
	DRAM_CAS_N,
	DRAM_RAS_N,
	DRAM_CLK,
	DRAM_CKE,
	DRAM_CS_N,
	DRAM_WE_N,
	DRAM_DQM,
	
	
	 VGA_CLK,     // VGA Clock
    VGA_HS,      // VGA H_SYNC
    VGA_VS,      // VGA V_SYNC
    VGA_BLANK,   // VGA BLANK
    VGA_SYNC,    // VGA SYNC
    VGA_R,       // VGA Red[9:0]
    VGA_G,       // VGA Green[9:0]
    VGA_B       // VGA Blue[9:0]
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/
// Inputs
input				CLOCK_50;
input		[ 3: 0]	KEY;
input		[17: 0]	SW;


//  Communication
input				UART_RXD;

// Bidirectionals
inout		[35: 0]	GPIO;

// 	Memory (SRAM)
inout		[15: 0]	SRAM_DQ;

//  Memory (SDRAM)
inout		[31: 0]	DRAM_DQ;

// Outputs
// 	Simple
output		[ 8: 0]	LEDG;
output		[17: 0]	LEDR;

output		[ 6: 0]	HEX0;
output		[ 6: 0]	HEX1;
output		[ 6: 0]	HEX2;
output		[ 6: 0]	HEX3;
output		[ 6: 0]	HEX4;
output		[ 6: 0]	HEX5;
output		[ 6: 0]	HEX6;
output		[ 6: 0]	HEX7;

// 	Memory (SRAM)
output		[19: 0]	SRAM_ADDR;

output				SRAM_CE_N;
output				SRAM_WE_N;
output				SRAM_OE_N;
output				SRAM_UB_N;
output				SRAM_LB_N;

//  Communication
output				UART_TXD;

//  Memory (SDRAM)
output		[12: 0]	DRAM_ADDR;

output		[ 1: 0]	DRAM_BA;
output				DRAM_CAS_N;
output				DRAM_RAS_N;
output				DRAM_CLK;
output				DRAM_CKE;
output				DRAM_CS_N;
output				DRAM_WE_N;
output		[ 3: 0]	DRAM_DQM;

output        VGA_CLK;     // VGA Clock
 output        VGA_HS;      // VGA H_SYNC
 output        VGA_VS;      // VGA V_SYNC
 output        VGA_BLANK;   // VGA BLANK
 output        VGA_SYNC;   // VGA SYNC
 output [9:0]  VGA_R;       // VGA Red[9:0]
 output [9:0]  VGA_G;       // VGA Green[9:0]
 output [9:0]  VGA_B;       // VGA Blue[9:0]
/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/
// Internal Wires
//  Used to connect the Nios II system clock to the non-shifted output of the PLL
wire				system_clock;

// Internal Registers

// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/


/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

// Output Assignments
assign GPIO[ 0]		= 1'bZ;
assign GPIO[ 2]		= 1'bZ;
assign GPIO[16]		= 1'bZ;
assign GPIO[18]		= 1'bZ;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/
nios_system NiosII (
	// 1) global signals:
	.clk									(system_clock),
	.reset_n								(KEY[0]),

	
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
	.zs_we_n_from_the_SDRAM					(DRAM_WE_N),
	

	// the_Serial_port
	.UART_RXD_to_the_Serial_Port			(UART_RXD),
	.UART_TXD_from_the_Serial_Port			(UART_TXD),
	);

sdram_pll neg_3ns (CLOCK_50, DRAM_CLK, system_clock);

wire	VGA_CTRL_CLK;
wire	DLY_RST;


Reset_Delay			r0	(	.iCLK(CLOCK_50),.oRESET(DLY_RST)	);

vga_pll 		p1	(	.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(VGA_CLK));


VGA_Controller		u1	(	//	Host Side
							.iCursor_RGB_EN(4'b0111),
							.oAddress(mVGA_ADDR),
							.oCoord_X(Coord_X),
							.oCoord_Y(Coord_Y),
							.iRed(mVGA_R),
							.iGreen(mVGA_G),
							.iBlue(mVGA_B),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST)	);

wire [9:0]	mVGA_R;				//memory output to VGA
wire [9:0]	mVGA_G;
wire [9:0]	mVGA_B;
wire [19:0]	mVGA_ADDR;			//video memory address
wire [9:0]  Coord_X, Coord_Y;	//display coods
reg [9:0]  edit_X;
reg [8:0]  edit_Y;	

////////////////////////////////////
//CA state machine variables
wire reset;
wire generation;
assign generation = ~KEY[1];
reg [1:0] state;	//state machine
reg [1:0] nextState;


localparam s_init = 2'b00;
localparam s_generate = 2'b01;
localparam s_write = 2'b10;
localparam s_debounce = 2'b11;
reg [8:0] vCounter;
reg [9:0] hCounter;

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


wire mem_bit ; //current data from m4k to VGA
reg disp_bit ; // registered data from m4k to VGA
wire state_bit ; // current data from m4k to state machine
reg we ; // write enable for a
reg [18:0] addr_reg ; // for a
reg data_reg ; // for a
reg [31:0] LFSR;
reg generation_old;

// make the color white
assign  mVGA_R = 10'h3FF;
assign  mVGA_G = 10'h3FF;

assign  mVGA_B = 10'h3FF;
//assign HEX0 = 7'h7F;

// DLA state machine
assign reset = ~KEY[0];

//right-most bit for rand number shift regs
//your basic XOR random # gen
	 //Drive LEDs
hex_7seg(SW[3:0],HEX5);
hex_7seg(SW[7:4],HEX6);
hex_7seg({2'b00,state},HEX7);

assign LEDR[7] = reset;
assign LEDR[6] = generation;


always @ (negedge VGA_CTRL_CLK)
begin
	// register the m4k output for better timing on VGA
	// negedge seems to work better than posedge
	disp_bit <= mem_bit;
end


endmodule //top module

