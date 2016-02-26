
module eulersillator
#(
parameter vga_width = 640,
parameter x1_height = 160,
parameter x2_height = 480
)
(
input CLOCK_50,
input VGA_CTRL_CLK,
input reset,

//NIOS II Inputs
input nios_reset,

input signed [17:0] k1,
input signed [17:0] kmid,
input signed [17:0] k2,
input signed [17:0] kcubic,

input signed [17:0] x1_init,
input signed [17:0] x2_init,
input signed [17:0] v1_init,
input signed [17:0] v2_init,

output wire signed   [17:0] x1,
output wire signed   [17:0] x2,

//VGA interface
input  wire [9:0] o_xCoord,
input  wire [8:0] o_yCoord,
output reg  [9:0] vga_xCoord,
output reg  [8:0] vga_yCoord,
output reg       w_en,
output reg       disp_bit 
);

reg [4:0] count;
reg [1:0] VGA_flag;
wire AnalogClock;

// analog update divided clock
always @ (posedge CLOCK_50) 
begin
  if (nios_reset || reset)
  begin
      count <= 5'd0;
  end
  else begin
  count <= count + 1; 
  end
end  
assign AnalogClock = (count == 5'd0);

// figure out your VGA life
always @ (posedge VGA_CTRL_CLK)
begin
  if (nios_reset || reset)
  begin
    w_en <= 1;
    vga_xCoord <= o_xCoord;
    vga_yCoord <= o_yCoord;
    disp_bit <= 1;
    vga_xCoord <= 0;
  end
  else if (vga_xCoord > 640)
  begin
    w_en <= 0;
  end
  else if (VGA_flag == 2'd2)
  begin
    VGA_flag <= 2'd1;
    vga_xCoord <= vga_xCoord + 1;
    vga_yCoord <= x1_height + x1[17:13];
    w_en <= 1;
    disp_bit <= 0;
  end
  else if (VGA_flag == 2'd1)
  begin
    VGA_flag <= 2'd0;
    vga_yCoord <= x2_height + x2[17:13];
    w_en <= 1;
    disp_bit <= 0;
  end
  else
  begin
    w_en <= 0;
  end
end

always @(posedge AnalogClock)
begin
  VGA_flag <= 2'd2;  
end

assign AnalogClock = (count==0);  

wire signed [17:0] g1 = 18'h0_0800;
wire signed [17:0] g2 = 18'h0_0800;


wire signed [17:0] d2_x1_dt2;
wire signed [17:0] d2_x2_dt2;

wire signed [17:0] d_x1_dt;
wire signed [17:0] d_x2_dt;


// mid term multiplication
wire signed [17:0] kmid_x2minusx1;
signed_mult5760 kmid_x2minusx1_mul(kmid_x2minusx1,kmid,(x2-x1));

// x1 term multiplication
wire signed [17:0] k1_x1;
signed_mult5760 k1_x1_mul(k1_x1,k1,x1);
wire signed [17:0] g1_x1_d1;
signed_mult5760 g1_x1_d1_mul(g1_x1_d1,g1,d_x1_dt);

// x2 term multiplication
wire signed [17:0] k2_x2;
signed_mult5760 k2_x2_mul(k2_x2,k2,x2);
wire signed [17:0] g2_x2_d1;
signed_mult5760 g2_x2_d1_mul(g2_x2_d1,g2,d_x2_dt);

assign d2_x1_dt2 = kmid_x2minusx1+k1_x1+g1_x1_d1;
assign d2_x2_dt2 = kmid_x2minusx1+k2_x2+g2_x2_d1;

integrator i_x1_21(
  .out(d_x1_dt),         //the state variable V
  .funct(d2_x1_dt2),    //the dV/dt function
  .dt(4'd9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(v1_init)
  );

integrator i_x1_10(
  .out(x1),         //the state variable V
  .funct(d_x1_dt),      //the dV/dt function
  .dt(4'd9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(x1_init)
  );

integrator i_x2_21(
  .out(d_x2_dt),         //the state variable V
  .funct(d2_x2_dt2),      //the dV/dt function
  .dt(4'd9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(v2_init)
  );

integrator i_x2_10(
  .out(x2),         //the state variable V
  .funct(d_x2_dt),      //the dV/dt function
  .dt(4'd9),        // in units of SHIFT-right
  .clk(AnalogClock),
  .reset(nios_reset),
  .InitialOut(x1_init)
  );
endmodule
