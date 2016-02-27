module dda_param_driver
(
	 input clk,
	 input reset,
    input [21:0] dest_clk,  
	 output reg signed [17:0] k1,
	 
);

always @(posedge clk)
if (reset) begin

end

.k1(18'h1_0000),
.kmid(18'h1_0000),
.k2(18'h1_0000),
.kcubic(18'd0),

.x1_init(18'h3_8000),
.x2_init(18'h0_8000),
.v1_init(18'h1_0000),
.v2_init(18'h1_0000),

endmodule