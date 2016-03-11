module fixed_mult5760 (
  input  wire signed [17:0] a,
  input  wire signed [17:0] b,
  output wire signed [17:0] out);

  wire   signed  [35:0]  mult_out;
  assign mult_out = a * b;
  assign out = {mult_out[35], mult_out[32:16]};
endmodule
