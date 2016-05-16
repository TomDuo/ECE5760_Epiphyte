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

wire signed [26:0] y0;
reg signed  [26:0]  y1;
reg signed  [26:0]  y2;

wire  signed [26:0] x0;
reg  signed [26:0] x1;
reg  signed [26:0] x2;



wire signed [26:0] mul_x0_b0;
wire signed [26:0] mul_x1_b1;
wire signed [26:0] mul_x2_b2;

wire signed [26:0] mul_y1_a1;
wire signed [26:0] mul_y2_a2;

assign out = y0;
assign x0 = in;

assign y0 = mul_x0_b0 + mul_x1_b1 + mul_x2_b2 - mul_y1_a1 - mul_y2_a2; 

fixed_comb_mult5760 mulb0 (x0,b0,mul_x0_b0);
fixed_comb_mult5760 mulb1 (x1,b1,mul_x1_b1);
fixed_comb_mult5760 mulb2 (x2,b2,mul_x2_b2);

fixed_comb_mult5760 mula1 (y1,a1,mul_y1_a1);
fixed_comb_mult5760 mula2 (y2,a2,mul_y2_a2);


always @ (posedge aud_clk) begin
  if (reset) begin
      x1 <= 27'd0;
      x2 <= 27'd0;

      y1 <= 27'd0;
      y2 <= 27'd0;
  end
  else if (enable) begin
      x2 <= x1;
      x1 <= x0;
      
      y2 <= y1;
      y1 <= y0;




  end
end
endmodule
