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
	 
	 assign red = 10'h000;
	 assign green = 10'h000;
	 assign blue = 10'h3FF; //{10{oCoord_X[0]}};
	 
VGA_Controller vga_driver( // Host Side
//    .iCursor_RGB_EN(),
//    .iCursor_X(),
//    .iCursor_Y(),
//    .iCursor_R(),
//    .iCursor_G(),
//    .iCursor_B(),
    .iRed(red),
    .iGreen(green),
    .iBlue(blue),
    //.oAddress(),
    .oCoord_X(oCoord_X),
    .oCoord_Y(oCoord_Y),
    // VGA Side
    .oVGA_R(oVGA_R),
    .oVGA_G(oVGA_G),
    .oVGA_B(oVGA_B),
    .oVGA_H_SYNC(oVGA_H_SYNC),
    .oVGA_V_SYNC(oVGA_V_SYNC),
    .oVGA_SYNC(oVGA_SYNC),
    .oVGA_BLANK(oVGA_BLANK),
    .oVGA_CLOCK(oVGA_CLOCK),
    // Control Signal
    .iCLK(clk),
    .iRST_N(vga_reset)
	 );
endmodule