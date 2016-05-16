module SOS (
  input clk,
  input aud_clk,
  input reset,
  input enable,
    
  input signed [26:0] b0,
  input signed [26:0] b1,
  input signed [26:0] b2,
  input signed [26:0] a0,
  input signed [26:0] a1,
  input signed [26:0] a2,

  input signed [26:0] in,
  output signed [26:0] out
);

reg  signed [26:0] y;
reg  signed [26:0] y1;
reg  signed [26:0] y2;

assign out = y;

reg  signed [26:0] x;
reg  signed [26:0] x1;
reg  signed [26:0] x2;

/*
reg  signed [26:0] a0;
reg  signed [26:0] a1;
reg  signed [26:0] a2;


reg  signed [26:0] b0;
reg  signed [26:0] b1;
reg  signed [26:0] b2;
*/

wire signed [26:0] mul_b0_x0;
wire signed [26:0] mul_b1_x1;
wire signed [26:0] mul_b2_x2;

wire signed [26:0] mul_a0_y0;
wire signed [26:0] mul_a1_y1;
wire signed [26:0] mul_a2_y2;


fixed_comb_mult5760 mulb0 (x,b0,mul_b0_x0);
fixed_comb_mult5760 mulb1 (x1,b1,mul_b1_x1);
fixed_comb_mult5760 mulb2 (x2,b2,mul_b2_x2);

fixed_comb_mult5760 mula1 (y1,a1,mul_a1_y1);
fixed_comb_mult5760 mula2 (y2,a2,mul_a2_y2);

  always @ (posedge aud_clk) begin
  if (reset) begin
      x  <= 27'd0;
      x1 <= 27'd0;
      x2 <= 27'd0;

      y  <= 27'd0;
      y1 <= 27'd0;
      y2 <= 27'd0;
  end
  else if (enable) begin
      x <= in;
      x1 <= x;
      x2 <= x1;
      
      y1 <= y;
      y2 <= y1; 

      y <= mul_b0_x0 + mul_b1_x1 + mul_b2_x2 - mul_a1_y1 - mul_a2_y2;
  end
end
endmodule
