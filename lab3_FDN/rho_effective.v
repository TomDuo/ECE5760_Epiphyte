module rho_effective (
  // clk reset
  input        clk,
  input        reset,

  // inputs for rho, constants, and middle position
  input        tension_effect_enable,
  input [17:0] rho_0,
  input [17:0] u_mid,

  // output the effective rho value for drum
  output reg [17:0] rho_eff
);

wire signed [17:0] u_sq;
fixed_comb_mult5760 multy_jr(u_mid,u_mid,u_sq);

always @(posedge clk) begin
  if (tension_effect_enable) begin
    rho_eff <= rho_0 + (u_sq>>>3); // note that the constant temr just divides by 2
  end
  else begin
    rho_eff <= rho_0;
  end
end

endmodule