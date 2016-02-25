`include "signed_mult.v"
`include "integrator.v"

module eulersillator
#(
parameter vga_width = 640;
parameter x1_height = 160;
parameter x2_height = 480;
)
(
input CLOCK_50,
input VGA_CTRL_CLK,
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

//VGA interface
input  wire [9:0] o_xCoord,
input  wire [8:0] o_yCoord,
output wire [9:0] vga_xCoord,
output wire [8:0] vga_yCoord,
output wire       w_en,
output wire       disp_bit 
);

reg [4:0] count;
reg [1:0] VGA_flag;
wire AnalogClock;

// analog update divided clock
always @ (posedge CLOCK_50) 
begin
  count <= count + 1; 
end  

// figure out your VGA life
always @ (posedge VGA_CTRL_CLK)
begin
  if (nios_reset || reset)
  begin
    w_en = 1;
    vga_xCoord = o_xCoord;
    vga_yCoord = o_yCoord;
    disp_bit = 1;
    vga_xCoord = 0;
  end
  else if (vga_xCoord > 640)
  begin
    w_en = 0;
  end
  else if (VGA_flag == 2'd2)
  begin
    VGA_flag = 2'd1;
    vga_xCoord = vga_xCoord + 1;
    vga_yCoord = x1_height + x1[17:13];
    w_en = 1;
    disp_bit = 0;
  end
  else if (VGA_flag == 2'd1)
  begin
    VGA_flag == 2'd0;
    vga_yCoord = x2_height + x2[17:13];
    w_en = 1;
    disp_bit = 0;
  end
end

always @(posedge AnalogClock)
begin
  VGA_flag = 2'd2;  
end

assign AnalogClock = (count==0);  

signed wire [17:0] g1 = 18'h3FF;
signed wire [17:0] g2 = 18'h3FF;

signed reg  [17:0] v1 = 18'h3FF;
signed reg  [17:0] v2 = 18'h3FF;

assign w_en = vga_xCoord < vga_width;

signed wire [17:0] x1_d2;
signed wire [17:0] x1_d1;
signed wire [17:0] x2_d2;
signed wire [17:0] x2_d1;

// mid term multiplication
signed wire [17:0] kmid_x2minusx1;
signed_mult kmid_x2minusx1_mul(kmid_x2minusx1,kmid,(x2-x1);

// x1 term multiplication
signed wire [17:0] k1_x1;
signed_mult k1_x1_mul(k1_x1,k1,x1);
signed wire [17:0] g1_x1_d1;
signed_mult g1_x1_d1_mul(g1_x1_d1,g1,x1_d1);

// x2 term multiplication
signed wire [17:0] k2_x2;
signed_mult k1_x1_mul(k2_x2,k2,x2);
signed wire [17:0] g2_x2_d1;
signed_mult g2_x2_d1_mul(g2_x2_d1,g2,x2_d1);

integrator i_x1_21(
  .out(x1_d1),         //the state variable V
  .funct(kmid_x2minusx1+k1_x1+g1_x1_d1),    //the dV/dt function
  .dt(9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(v1_init)
  );

integrator i_x1_10(
  .out(x1),         //the state variable V
  .funct(x1_d1),      //the dV/dt function
  .dt(9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(x1_init)
  );

integrator i_x2_21(
  .out(x2_d1),         //the state variable V
  .funct(kmid_x2minusx1+k2_x2+g2_x2_d1),      //the dV/dt function
  .dt(9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(v2_init)
  );

integrator i_x2_10(
  .out(x2),         //the state variable V
  .funct(x2_d1),      //the dV/dt function
  .dt(9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(x1_init)
  );
endmodule
