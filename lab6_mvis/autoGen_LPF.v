module autoGen_LPF
(
		input clk,
		input aud_clk,
		input reset,
		input enable,

		input signed [15:0] iAud,

		output reg signed [26:0] oAud,
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
			oAud <= 27'd0;
			power  <= 11'd0;
			power_accumulator <= 38'd0;
			count <= 16'd0;
            /*
            sosMat[0][0] <= 27'h9;
            sosMat[0][1] <= 27'h12;
            sosMat[0][2] <= 27'h9;
            sosMat[0][3] <= 27'h800000;
            sosMat[0][4] <= 27'h70F1AAA;
            sosMat[0][5] <= 27'h7169A9;
            sosMat[1][0] <= 27'h800000;
            sosMat[1][1] <= 27'h1000000;
            sosMat[1][2] <= 27'h800000;
            sosMat[1][3] <= 27'h800000;
            sosMat[1][4] <= 27'h706C91F;
            sosMat[1][5] <= 27'h79BFC5;
            */
           sosMat[0][0] <= 27'h14762;
           sosMat[0][1] <= 27'h7FD7142;
           sosMat[0][2] <= 27'h14762;
           sosMat[0][3] <= 27'h800000;
           sosMat[0][4] <= 27'h7002F9B;
           sosMat[0][5] <= 27'h7FD076;
           sosMat[1][0] <= 27'h800000;
           sosMat[1][1] <= 27'h7000080;
           sosMat[1][2] <= 27'h800000;
           sosMat[1][3] <= 27'h800000;
           sosMat[1][4] <= 27'h7000D3D;
           sosMat[1][5] <= 27'h7FF2FA;
           end


		else if (enable) begin
			oAud <= y;
			if (y[26]) begin
				mag_y <= (~y)-27'd1;
			end
			else begin
				mag_y <= y;
			end

			if (count == 16'd9600) begin
				count <= 16'd0;
				power_accumulator <= 38'd0;
				/*
				if(filterID == 0) begin
				power <= power_accumulator[39:29];
				end
				else if(filterID == 1) begin
				power <= power_accumulator[37:27];
				end
				else begin
				*/
				power <= power_accumulator[36:26];
				//end
			end
			else begin 
				power_accumulator <= power_accumulator + mag_y;
				count <= count + 16'd1;
			end
		end
		else begin
			oAud <= 27'd0;
			power  <= 11'd0;
		end
	end

	endmodule
