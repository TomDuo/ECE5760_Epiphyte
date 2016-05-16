module autoGen_BPF #(
	parameter filterID= 0,
	parameter aowidth=13
	// lower num<= lower BP4
	// 0 -> [10Hz 100Hz]
	// 1 -> [100Hz 500Hz]
	// 2 -> [500Hz 1000Hz]
	// 3 -> [1000Hz 5000Hz]
	// 4 -> [5000Hz 10000Hz]
	// 5 -> [10000Hz 20000Hz]
	
	)(
		input clk,
		input aud_clk,
		input reset,
		input enable,

		input signed [15:0] iAud,

		output reg signed [aowidth:0] oAud,
		output reg [10:0]  power
	);

	wire signed [26:0] bq1_out;
	wire signed [26:0] y;
	wire signed [26:0] lpf_y;
	wire signed [26:0] in;

	reg  signed [39:0] power_accumulator;
	reg  unsigned [15:0] count; 
	assign in = {{3{iAud[15]}}, iAud,8'd0};
	reg  signed [26:0] mag_y;
	reg  signed [26:0] sosMat [0:1][0:5];

	SOS bq1(
		.clk(clk),
		.aud_clk(aud_clk),
		.enable(enable),
		.reset(reset),
		.b0(sosMat[0][0]),
		.b1(sosMat[0][1]),
		.b2(sosMat[0][2]),
		.a0(sosMat[0][3]),
		.a1(sosMat[0][4]),
		.a2(sosMat[0][5]),
		.in(in),
		.out(bq1_out)
	);
	SOS bq2(
		.clk(clk),
		.aud_clk(aud_clk),
		.enable(enable),
		.reset(reset),
		.b0(sosMat[1][0]),
		.b1(sosMat[1][1]),
		.b2(sosMat[1][2]),
		.a0(sosMat[1][3]),
		.a1(sosMat[1][4]),
		.a2(sosMat[1][5]),
		.in(bq1_out),
		.out(y)
	);
	always @ (posedge aud_clk) begin
		if (reset) begin
			oAud <= 16'd0;
			power  <= 11'd0;
			power_accumulator <= 38'd0;
			count <= 16'd0;
			case(filterID)
				0: begin

					sosMat[0][0]<= 27'h4;
					sosMat[0][1]<= 27'h7;
					sosMat[0][2]<= 27'h4;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h7002A9F;
					sosMat[0][5]<= 27'h7FD57B;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h7001220;
					sosMat[1][5]<= 27'h7FEDE5;
				end

				1: begin

					sosMat[0][0]<= 27'h20;
					sosMat[0][1]<= 27'h41;
					sosMat[0][2]<= 27'h20;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h7008049;
					sosMat[0][5]<= 27'h7F809B;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h7003674;
					sosMat[1][5]<= 27'h7FC9B5;
				end

				2: begin

					sosMat[0][0]<= 27'h121;
					sosMat[0][1]<= 27'h241;
					sosMat[0][2]<= 27'h121;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h70184AB;
					sosMat[0][5]<= 27'h7E834C;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h700A40E;
					sosMat[1][5]<= 27'h7F5D65;
				end

				3: begin

					sosMat[0][0]<= 27'h9FB;
					sosMat[0][1]<= 27'h13F7;
					sosMat[0][2]<= 27'h9FB;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h704AFB4;
					sosMat[0][5]<= 27'h7B972A;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h701F26C;
					sosMat[1][5]<= 27'h7E1A8C;
				end

				4: begin

					sosMat[0][0]<= 27'h559A;
					sosMat[0][1]<= 27'hAB35;
					sosMat[0][2]<= 27'h559A;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h70F2DF7;
					sosMat[0][5]<= 27'h733A23;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h7060F49;
					sosMat[1][5]<= 27'h7A63B8;
				end

				5: begin

					sosMat[0][0]<= 27'h2A10D;
					sosMat[0][1]<= 27'h54219;
					sosMat[0][2]<= 27'h2A10D;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h7361459;
					sosMat[0][5]<= 27'h5D8091;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h7141A74;
					sosMat[1][5]<= 27'h6FC27F;
				end

				6: begin

					sosMat[0][0]<= 27'h111E50;
					sosMat[0][1]<= 27'h223CA0;
					sosMat[0][2]<= 27'h111E50;
					sosMat[0][3]<= 27'h800000;
					sosMat[0][4]<= 27'h7D09DA1;
					sosMat[0][5]<= 27'h35833B;
					sosMat[1][0]<= 27'h800000;
					sosMat[1][1]<= 27'h7000000;
					sosMat[1][2]<= 27'h800000;
					sosMat[1][3]<= 27'h800000;
					sosMat[1][4]<= 27'h74BA6D6;
					sosMat[1][5]<= 27'h522505;

				end
			endcase
		end

		else if (enable) begin
			oAud <= y[24:11];
			if (y[26]) begin
				mag_y <= (~y)-27'd1;
			end
			else begin
				mag_y <= y;
			end

			if (count == 16'd9600) begin
				count <= 16'd0;
				power_accumulator <= 38'd0;
				
				if(filterID == 0) begin
				power <= power_accumulator[39:29];
				end
				else if(filterID == 1) begin
				power <= power_accumulator[37:27];
				end
				else begin
				power <= power_accumulator[35:25];
				end
			end
			else begin 
				power_accumulator <= power_accumulator + mag_y;
				count <= count + 16'd1;
			end
		end
		else begin
			oAud <= 16'd0;
			power  <= 11'd0;
		end
	end

	endmodule
