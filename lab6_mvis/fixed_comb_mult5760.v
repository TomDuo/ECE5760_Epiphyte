module fixed_comb_mult5760 (
  input  wire signed [26:0] a,
  input  wire signed [26:0] b,
  output wire signed [26:0] out
  );

  wire signed  [53:0]  mult_out;
  assign mult_out = a * b;
  assign out = {mult_out[53], mult_out[48:23]};
  endmodule
