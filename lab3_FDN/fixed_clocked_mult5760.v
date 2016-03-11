module fixed_clocked_mult5760 (
  input  wire clk,
  input  wire signed [17:0] a,
  input  wire signed [17:0] b,
  output wire signed [17:0] out
  );

  reg   signed  [35:0]  mult_out;
  always @(negedge clk)
  begin
  mult_out <= a * b;
  end
  assign out = {mult_out[35], mult_out[32:16]};
  endmodule
