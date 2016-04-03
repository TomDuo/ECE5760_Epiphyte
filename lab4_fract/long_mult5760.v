/*
*This module tries to multiply two 4.32 numbers into a 8.64, then truncate the results to 4.32
*/ 
module fixed_comb_mult5760 (
  input  wire signed [35:0] a,
  input  wire signed [35:0] b,
  output wire signed [35:0] out
  );

  wire signed  [71:0]  mult_out;
  assign mult_out = a * b;
  assign out = {mult_out[71], mult_out[66:32]};
  endmodule
