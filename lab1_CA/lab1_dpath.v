//=============================================================================
// Lab 1 - Cellular Automata Datapath File
//
// Authors:
//  Connor Archard
//  Kevin Kreher
//  Noah Levy
//
// Date:
//  Feb 3, 2016
//=============================================================================
module lab1_dpath(
input clk,
input vga_reset,
output wire [9:0] oVGA_R,
output wire [9:0] oVGA_G,
output wire [9:0] oVGA_B,
output wire oVGA_H_SYNC,
output wire oVGA_V_SYNC,
output wire oVGA_SYNC,
output wire oVGA_BLANK,
output wire oVGA_CLOCK
);

wire [9:0] oCoord_X;
wire [9:0] oCoord_Y;
wire [9:0] red;    
wire [9:0] green;  
wire [9:0] blue;   
	 
	 assign red = 10'h3C0;
	 assign green = 10'h3C0;
	 assign blue = 10'h3C0; //{10{oCoord_X[0]}};
	 
VGA_Controller vga_driver( 	//	Host Side
							.iCursor_RGB_EN(4'b0111),
							.oCoord_X(Coord_X),
							.oCoord_Y(Coord_Y),
							.iRed(red),
							.iGreen(green),
							.iBlue(blue),
							//	VGA Side
							.oVGA_R(VGA_R),
							.oVGA_G(VGA_G),
							.oVGA_B(VGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC),
							.oVGA_BLANK(VGA_BLANK),
							//	Control Signal
							.iCLK(clk),
							.iRST_N(vga_reset)	);
endmodule