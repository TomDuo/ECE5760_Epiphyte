module fixed_clocked_mult5760 (
  input  wire clk,
  input  wire signed [26:0] a,
  input  wire signed [26:0] b,
  output wire signed [26:0] out
  );

  reg signed  [53:0]  mult_out;
  always @( negedge clk ) begin
    mult_out = a*b;
  end
  assign out = {mult_out[53], mult_out[48:23]};
  endmodule
