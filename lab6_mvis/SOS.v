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


wire  signed [26:0] v0;
reg  signed [26:0] v1;
reg  signed [26:0] v2;

/*
reg  signed [26:0] a0;
reg  signed [26:0] a1;
reg  signed [26:0] a2;


reg  signed [26:0] b0;
reg  signed [26:0] b1;
reg  signed [26:0] b2;
*/

wire signed [26:0] mul_v0_b0;
wire signed [26:0] mul_v1_b1;
wire signed [26:0] mul_v2_b2;

wire signed [26:0] mul_v1_a1;
wire signed [26:0] mul_v2_a2;


fixed_comb_mult5760 mulb0 (v0,b0,mul_v0_b0);
fixed_comb_mult5760 mulb1 (v1,b1,mul_v1_b1);
fixed_comb_mult5760 mulb2 (v2,b2,mul_v2_b2);

fixed_comb_mult5760 mula1 (v1,a1,mul_v1_a1);
fixed_comb_mult5760 mula2 (v2,a2,mul_v2_a2);

assign v0 = in - mul_v1_a1 - mul_v2_a2;
assign out = mul_v0_b0 + mul_v1_b1 + mul_v2_b2; 

always @ (posedge aud_clk) begin
  if (reset) begin
      v1 <= 27'd0;
      v2 <= 27'd0;
  end
  else if (enable) begin
      v2 <= v1;
      v1 <= v0;


  end
end
endmodule
