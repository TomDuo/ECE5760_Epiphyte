
module eulersillator
#(
parameter vga_width = 640,
parameter x1_height = 120,
parameter x2_height = 360
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


wire signed [17:0] d2_x1_dt2;
wire signed [17:0] d2_x2_dt2;

wire signed [17:0] d_x1_dt;
wire signed [17:0] d_x2_dt;


// mid term multiplication
wire signed [17:0] kmid_x2minusx1;

reg [8:0] yTrace1 ;
reg [8:0] yTrace2 ;

reg [9:0] time_index ;

reg writeTraceSelect;
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
		 write_xCoord <= display_xCoord;
		 write_yCoord <= display_yCoord;
		 disp_bit <= 2'b00;
		 writeTraceSelect <= 0;
		 //vga_xCoord <= 0;
	  end
  else if (~writeTraceSelect)
	  begin
		write_xCoord <= time_index;
		write_yCoord <= yTrace2;
		 disp_bit <= 2'b01;

		writeTraceSelect <= 1;
	  end
  else if (writeTraceSelect)
	  begin
	  	write_xCoord <= time_index;
		write_yCoord <= yTrace1;
		disp_bit <= 2'b10;

	  writeTraceSelect <= 0;
	  end
  else
	  begin
		 w_en <= 0;
	  end
end

reg [3:0] drawCount;

wire [8:0] sign_extended_x1 = { {2{x1[17]}}, x1[17:11]};
wire [8:0] sign_extended_x2 = { {2{x2[17]}}, x2[17:11]};

always @(posedge AnalogClock)
begin
	if(reset || nios_reset) begin
		time_index <= 10'd0;
		drawCount  <= 4'd0;
	end
	else if (time_index < vga_width && drawCount == 0) begin
		time_index <= time_index + 10'd1;
		yTrace1 <= x1_height + sign_extended_x1; //+ x1[17:11];
	   yTrace2 <= x2_height + sign_extended_x2;// + x2[17:11];
		drawCount <= drawCount + 2'b1;
	end
	else begin
		drawCount <= drawCount + 2'b1;
	end
end


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
