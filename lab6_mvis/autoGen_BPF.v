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

sosMat[0][0] <= 27'h291;
sosMat[0][1] <= 27'h522;
sosMat[0][2] <= 27'h291;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h7021C37;
sosMat[0][5] <= 27'h7E1044;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h701571B;
sosMat[1][5] <= 27'h7EBBDC;
end

1: begin

sosMat[0][0] <= 27'h83B;
sosMat[0][1] <= 27'h1076;
sosMat[0][2] <= 27'h83B;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h704060D;
sosMat[0][5] <= 27'h7C892D;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h702826D;
sosMat[1][5] <= 27'h7DBAC5;
end

2: begin

sosMat[0][0] <= 27'h1A33;
sosMat[0][1] <= 27'h3465;
sosMat[0][2] <= 27'h1A33;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h707F53B;
sosMat[0][5] <= 27'h79D588;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h704D41D;
sosMat[1][5] <= 27'h7BF0B3;
end

3: begin

sosMat[0][0] <= 27'h5242;
sosMat[0][1] <= 27'hA484;
sosMat[0][2] <= 27'h5242;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h7108E90;
sosMat[0][5] <= 27'h75208A;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h709AEEF;
sosMat[1][5] <= 27'h78C61D;
end

4: begin

sosMat[0][0] <= 27'hFC51;
sosMat[0][1] <= 27'h1F8A2;
sosMat[0][2] <= 27'hFC51;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h724872D;
sosMat[0][5] <= 27'h6D28D0;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h714892A;
sosMat[1][5] <= 27'h733933;
end

5: begin

sosMat[0][0] <= 27'h2E8FC;
sosMat[0][1] <= 27'h5D1F8;
sosMat[0][2] <= 27'h2E8FC;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h754825C;
sosMat[0][5] <= 27'h60714E;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h72E5353;
sosMat[1][5] <= 27'h6991EB;
end

6: begin

sosMat[0][0] <= 27'h81E27;
sosMat[0][1] <= 27'h103C4D;
sosMat[0][2] <= 27'h81E27;
sosMat[0][3] <= 27'h800000;
sosMat[0][4] <= 27'h7C32771;
sosMat[0][5] <= 27'h4ED8AB;
sosMat[1][0] <= 27'h800000;
sosMat[1][1] <= 27'h7000000;
sosMat[1][2] <= 27'h800000;
sosMat[1][3] <= 27'h800000;
sosMat[1][4] <= 27'h76CE03E;
sosMat[1][5] <= 27'h5881D6;
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
			oAud <= 16'd0;
			power  <= 11'd0;
		end
	end

	endmodule
