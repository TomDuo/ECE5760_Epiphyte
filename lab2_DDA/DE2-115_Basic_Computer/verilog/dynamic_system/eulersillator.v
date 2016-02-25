module eulersillator
#(
parameter vga_width = 640
)
(
input CLOCK_50,
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

reg [4:0] count;
wire AnalogClock;

// analog update divided clock
always @ (posedge CLOCK_50) 
begin
  count <= count + 1; 
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
signed_mult kmid_x2minusx1_mul(kmid_x2minusx1,kmid,(x2-x1));

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
