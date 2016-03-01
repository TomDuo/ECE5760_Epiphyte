
module eulersillator
#(
parameter vga_width = 640,
parameter x1_height = 180,
parameter x2_height = 300
)
(
input CLOCK_50,
input VGA_CTRL_CLK,
input reset,

//NIOS II Inputs
input nios_reset,
input triggerDraw,
input cube,
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
input  wire [9:0] display_xCoord,
input  wire [8:0] display_yCoord,
output reg  [9:0] write_xCoord,
output reg  [8:0] write_yCoord,
output reg        w_en,
output reg  [1:0] disp_bit 
);

reg [4:0] count;
wire AnalogClock;

wire signed [17:0] g1 = 18'h0_0800;
wire signed [17:0] g2 = 18'h0_0800;


wire signed [20:0] d2_x1_dt2;
wire signed [20:0] d2_x2_dt2;

wire signed [17:0] d_x1_dt;
wire signed [17:0] d_x2_dt;


// mid term multiplication
wire signed [17:0] kmid_x2minusx1;

reg [8:0] yTrace1 ;
reg [8:0] yTrace2 ;

reg [9:0] time_index ;
// x2 term multiplication
wire signed [17:0] k2_x2;
wire signed [17:0] g2_x2_d1;
// x1 term multiplication
wire signed [17:0] k1_x1;
wire signed [17:0] g1_x1_d1;
// cubic term multiplication
wire signed [17:0] x1minusLW;
wire signed [17:0] x1minusLW_sq;
wire signed [17:0] x1minusLW_cu;
wire signed [17:0] kcu_x1LWcu;
wire signed [17:0] k1_x1_cu;
reg [4:0] drawCount;
wire [19:0] positive_x1 = x1 + 19'h1_ffff;
wire [19:0] positive_x2 = x2 + 19'h1_ffff;
wire [8:0]  truncated_x1 = positive_x1[19:11]; 
wire [8:0]  truncated_x2 = positive_x2[19:11];



reg writeTraceSelect;
// analog update divided clock
always @ (posedge CLOCK_50) 
begin
  count <= count + 1; 
end  
assign AnalogClock = (count == 5'd0);

wire [17:0] x1_abs = x1[17] ? 17'd1 + ~x1 : x1;
wire [17:0] x2_abs = x2[17] ? 17'd1 + ~x2 : x2;
wire [8:0] yTrace1_vga_clk;
wire [8:0] yTrace2_vga_clk;
cross_clocker cc1(VGA_CTRL_CLK,yTrace1,yTrace1_vga_clk);
cross_clocker cc2(VGA_CTRL_CLK,yTrace2,yTrace2_vga_clk);
// figure out your VGA life
always @ (posedge VGA_CTRL_CLK)
begin
  if (nios_reset || reset)
	  begin
		 w_en <= 1;
		 write_xCoord <= display_xCoord;
		 write_yCoord <= display_yCoord;
		 disp_bit <= 2'b00;
		 writeTraceSelect <= 0;
		 //vga_xCoord <= 0;
	  end
  else if (~writeTraceSelect)
	  begin
		write_xCoord <= time_index;
		write_yCoord <= yTrace1_vga_clk;
		 disp_bit <= 2'b01;

		writeTraceSelect <= 1;
	  end
  else if (writeTraceSelect)
	  begin
	  	write_xCoord <= time_index;
		write_yCoord <= yTrace2_vga_clk;
		disp_bit <= 2'b10;

	  writeTraceSelect <= 0;
	  end
  else
	  begin
		 w_en <= 0;
	  end
end

always @(posedge AnalogClock)
begin
	if(triggerDraw || reset || nios_reset) begin
		time_index <= 10'd0;
		drawCount  <=0;
	end
	else if (time_index < vga_width && drawCount == 0) begin
		time_index <= time_index + 10'd1;
        yTrace1 <= x1[17] ? $unsigned(x1_height) - x1_abs[17:12] : $unsigned(x1_height)  + x1_abs[17:11]; 
        yTrace2 <= x2[17] ? $unsigned(x2_height) - x2_abs[17:12] : $unsigned(x2_height) + x2_abs[17:11];
		drawCount <= drawCount + 2'b1;
	end
	else begin
		drawCount <= drawCount + 2'b1;
	end
end


signed_mult5760 kmid_x2minusx1_mul(kmid_x2minusx1,kmid,(x2-x1));


signed_mult5760 k1_x1_mul(k1_x1,k1,x1minusLW);
signed_mult5760 k1_x1_cu_mul(k1_x1_cu,k1,(x1minusLW+kcu_x1LWcu));
signed_mult5760 g1_x1_d1_mul(g1_x1_d1,g1,d_x1_dt);

signed_mult5760 k2_x2_mul(k2_x2,k2,(18'h1_0000-x2));
signed_mult5760 g2_x2_d1_mul(g2_x2_d1,g2,d_x2_dt);

signed_mult5760 kcu1(x1minusLW_sq,x1minusLW,x1minusLW);
signed_mult5760 kcu2(x1minusLW_cu,x1minusLW_sq,x1minusLW);
signed_mult5760 kcu3(kcu_x1LWcu,x1minusLW_cu,kcubic);
assign x1minusLW = (x1-18'h3_0000);
// based on position of switch 3 include cubic term for x1
assign d2_x1_dt2 = cube ? kmid_x2minusx1-k1_x1-g1_x1_d1 : kmid_x2minusx1-k1_x1_cu-g1_x1_d1;
assign d2_x2_dt2 = k2_x2-g2_x2_d1-kmid_x2minusx1;

integrator #(.functwidth(21)) i_x1_21
(
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

integrator #(.functwidth(21)) i_x2_21 
(
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
  .InitialOut(x2_init)
  );
endmodule
