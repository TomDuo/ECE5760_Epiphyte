module colorBlock #(
	parameter block_width = 100,
	parameter block_height = 100,
	parameter layer = 0,
	parameter color = 0
)
(
	input clk,
	input reset,
	
	input [1:0] powSpect,
	input [9:0] iVGA_X,
	input [8:0] iVGA_Y,
	input [9:0] topLeftX,
	input [8:0] topLeftY,
	
	output reg [5:0] oLayer,
	output reg oVal,
	output reg [7:0] R,
	output reg [7:0] G,
	output reg [7:0] B
);


always @ (posedge clk) begin
	if (reset) begin
		R<=8'd0;
		G<=8'd0;
		B<=8'd0;
		oVal<=1'b1;
	end
	else begin 
		oLayer <= layer;
		if ( (iVGA_X > topLeftX) && (iVGA_X < (topLeftX + block_width)) ) begin
			if ( (iVGA_Y > topLeftY) && (iVGA_Y < (topLeftY + block_height)) ) begin
				oVal  <= 1'b1;
				case(color)
				0: begin // white, 40 40 40
					R <= 8'd20 << (powSpect);
					G <= 8'd20 << (powSpect);
					B <= 8'd20 << (powSpect);
				end
				1: begin // red, 40 0 0
					R <= 8'd20 << (powSpect);
					G <= 8'd0 << (powSpect);
					B <= 8'd0 << (powSpect);
				end
				2: begin // brick, 45 8 8
					R <= 8'd22 << (powSpect);
					G <= 8'd4 << (powSpect);
					B <= 8'd4 << (powSpect);
				end
				3: begin // orange, 64 42 0
					R <= 8'd32 << (powSpect);
					G <= 8'd21 << (powSpect);
					B <= 8'd0 << (powSpect);
				end
				4: begin // yellow, 64 64 0
					R <= 8'd32 << (powSpect);
					G <= 8'd32 << (powSpect);
					B <= 8'd0 << (powSpect);
				end
				5: begin // khaki, 60 58 33
					R <= 8'd30 << (powSpect);
					G <= 8'd29 << (powSpect);
					B <= 8'd17 << (powSpect);
				end
				6: begin // olive, 27 34 9
					R <= 8'd14 << (powSpect);
					G <= 8'd17 << (powSpect);
					B <= 8'd5 << (powSpect);
				end
				7: begin // lime, 13 51 13
					R <= 8'd7 << (powSpect);
					G <= 8'd26 << (powSpect);
					B <= 8'd7 << (powSpect);
				end
				8: begin // green, 9 35 9
					R <= 8'd5 << (powSpect);
					G <= 8'd18 << (powSpect);
					B <= 8'd5 << (powSpect);
				end
				9: begin // aqua, 16 56 52
					R <= 8'd8 << (powSpect);
					G <= 8'd28 << (powSpect);
					B <= 8'd26 << (powSpect);
				end
				10: begin // cyan, 0 35 35
					R <= 8'd0 << (powSpect);
					G <= 8'd17 << (powSpect);
					B <= 8'd17 << (powSpect);
				end
				11: begin // lightblue, 8 36 64
					R <= 8'd4 << (powSpect);
					G <= 8'd18 << (powSpect);
					B <= 8'd32 << (powSpect);
				end
				12: begin // blue, 16 26 56
					R <= 8'd8 << (powSpect);
					G <= 8'd13 << (powSpect);
					B <= 8'd28 << (powSpect);
				end
				default: begin // blue, 16 26 56
					R <= 8'd8 << (powSpect);
					G <= 8'd13 << (powSpect);
					B <= 8'd28 << (powSpect);
				end
				endcase
			end
			else begin
				oVal <= 1'b0; // if not in the box, don't return valid
			end
		end
		else begin // if not in the box, don't return valid
			oVal <= 1'b0;
		end
	end // end reset case
end

endmodule