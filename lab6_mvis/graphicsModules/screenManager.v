module screenManager (
	input clk,
	input reset,
	input [9:0] iVGA_X,
	input [8:0] iVGA_Y,
	output reg [7:0] R,
	output reg [7:0] G,
	output reg [7:0] B
);

// TEST SECTION FOR STROBING THROUGH BRIGHTNESS ---------------------------------------------------
reg [15:0] count;
reg [15:0] count2;
reg [1:0] brightness;

always @(posedge clk) begin
	if (count < 16'd27000) begin
		count = count + 1;
	end
	else begin
		count <= 16'd0;
		if (count2 < 16'd1000) begin
			count2 <= count2 + 16'd1;
		end
		else begin
			count2 <= 16'd0;
			brightness <= brightness + 1;
		end
	end
end
// END TEST SECTION -------------------------------------------------------------------------------

wire [31:0] layer;
wire [31:0] layerOH;

wire [7:0] R0, G0, B0;
colorBlock #(100,100,0,5) cb0
(
	.clk(clk),
	.reset(reset),
	
	.powSpect(brightness),
	.iVGA_X(iVGA_X),
	.iVGA_Y(iVGA_Y),
	.topLeftX(10'd10),
	.topLeftY(9'd10),
	
	.oLayer(),
	.oVal(layer[0]),
	.R(R0),
	.G(G0),
	.B(B0)
);

wire [7:0] R1, G1, B1;
colorBlock #(20,120,0,9) cb1
(
	.clk(clk),
	.reset(reset),
	
	.powSpect(brightness),
	.iVGA_X(iVGA_X),
	.iVGA_Y(iVGA_Y),
	.topLeftX(10'd320),
	.topLeftY(9'd240),
	
	.oLayer(),
	.oVal(layer[1]),
	.R(R1),
	.G(G1),
	.B(B1)
);

wire [7:0] R2, G2, B2;
colorBlock #(300,300,0,4) cb2
(
	.clk(clk),
	.reset(reset),
	
	.powSpect(brightness),
	.iVGA_X(iVGA_X),
	.iVGA_Y(iVGA_Y),
	.topLeftX(10'd50),
	.topLeftY(9'd50),
	
	.oLayer(),
	.oVal(layer[2]),
	.R(R2),
	.G(G2),
	.B(B2)
);

msbOneHot msb0 (layer,layerOH);

always @(posedge clk) begin
	case(layerOH)
	(1<<2): begin
		R <= R2;
		B <= B2;
		G <= G2;
	end
	(1<<1): begin
		R <= R1;
		B <= B1;
		G <= G1;
	end
	(1<<0): begin
		R <= R0;
		G <= G0;
		B <= B0;
	end
	default: begin
		R <= 8'd0;
		G <= 8'd0;
		B <= 8'd0;
	end
	endcase
end

endmodule