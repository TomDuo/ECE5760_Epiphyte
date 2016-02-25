module eulersillator
#(
parameter vga_width = 640
)
(
input clk,
input reset,

//NIOS II Inputs
input nios_reset,

signed input [17:0] k1,
signed input [17:0] kmid,
signed input [17:0] k2,
signed input [17:0] kcubic,

signed input [17:0] x1_init,
signed input [17:0] x2_init,
signed input [17:0] v1_init,
signed input [17:0] v2_init,

signed output reg   [17:0] x1,
signed output reg   [17:0] x2,
output wire [9:0] vga_xCoord,
output wire       w_en 
);

wire [17:0] d1 = 18'h3FF;
wire [17:0] d2 = 18'h3FF;

reg  [17:0] v1 = 18'h3FF;
reg  [17:0] v2 = 18'h3FF;

assign w_en = vga_xCoord < vga_width;
endmodule
