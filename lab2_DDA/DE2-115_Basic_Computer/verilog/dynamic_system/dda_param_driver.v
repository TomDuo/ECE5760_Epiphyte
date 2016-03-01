module dda_param_driver
(
	 input clk,
	 input reset,
    input [21:0] niosDDA_cmd,  
	 output reg signed [17:0] k1,
	 output reg signed [17:0] kmid,
	 output reg signed [17:0] k2,
	 output reg signed [17:0] kcubic,
	 output reg signed [17:0] x1_init,
	 output reg signed [17:0] x2_init,
	 output reg signed [17:0] v1_init,
	 output reg signed [17:0] v2_init,
	 output reg               start_stop
);

always @(posedge clk) begin
if (reset) begin
k1 <= 18'h1_0000;
k2 <= 18'h1_0000;
kmid <= 18'h1_0000;
kcubic <= 18'h0_8000;

x1_init <= 18'h3_8000;
x2_init <= 18'h0_8000;
v1_init <= 18'h1_0000;
v2_init <= 18'h1_0000;
start_stop <= 1'b0;
end
else begin
case(niosDDA_cmd[3:0])
4'b0000 : ; //Do nothing!
4'd1 :  k1 <= niosDDA_cmd[21:4];
4'd2 :  k2 <= niosDDA_cmd[21:4];
4'd3 :  kcubic <= niosDDA_cmd[21:4];
4'd4 :  kmid <= niosDDA_cmd[21:4];
4'd5 :  x1_init <= niosDDA_cmd[21:4];
4'd6 :  v1_init <= niosDDA_cmd[21:4];
4'd7 :  x2_init <= niosDDA_cmd[21:4];
4'd8 :  v2_init <= niosDDA_cmd[21:4];
4'd9 :  start_stop <= 1'b1;
4'd10 :  start_stop <= 1'b0;
default : ;// Do nothing!
endcase
end
end

endmodule