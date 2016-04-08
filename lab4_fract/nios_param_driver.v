module nios_param_driver
(
	 input clk,
	 input reset,
   input [21:0] niosDDA_cmd,  
	 output reg signed [17:0] xCoord,
	 output reg signed [17:0] yCoord,
	 output reg signed [4:0]  zoom
);

always @(posedge clk) begin
if (reset) begin
	xCoord <= 18'h3_0000;
	yCoord <= 18'h1_0000;
	zoom   <= 5'd0;
end
else begin
case(niosDDA_cmd[3:0])
4'b0000 : ; //Do nothing!
4'd1 :  xCoord <= niosDDA_cmd[21:4];
4'd2 :  yCoord <= niosDDA_cmd[21:4];
4'd3 :  zoom <= niosDDA_cmd[8:4];
default : ;// Do nothing!
endcase
end
end

endmodule