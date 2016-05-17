module screenManager (
	input clk,
	input aud_clk,
	input reset,
	input KEY2,

	input [9:0]  iVGA_X,
	input [8:0]  iVGA_Y,
	input [15:0] iAud,
	output signed [15:0] audOut,

	input [17:0]  SW,

	output reg [7:0] oR,
	output reg [7:0] oG,
	output reg [7:0] oB,
	
	output wire [6:0] HEX0,
	output wire [6:0] HEX1,
	output wire [6:0] HEX2,
	output wire [6:0] HEX3,
	output wire [6:0] HEX4,
	output wire [6:0] HEX5,
	output wire [6:0] HEX6,
	output wire [6:0] HEX7,
	
	output wire [7:0] LEDG
);

// TEST SECTION FOR STROBING THROUGH BRIGHTNESS ---------------------------------------------------
//reg [15:0] count;
//reg [15:0] count2;
//reg [1:0] brightness;
//
//always @(posedge clk) begin
//	if (count < 16'd27000) begin
//		count = count + 1;
//	end
//	else begin
//		count <= 16'd0;
//		if (count2 < 16'd1000) begin
//			count2 <= count2 + 16'd1;
//		end
//		else begin
//			count2 <= 16'd0;
//			brightness <= brightness + 1;
//		end
//	end
//end
// END TEST SECTION -------------------------------------------------------------------------------

wire [63:0] layer;
wire [63:0] layerOH;

wire [7:0] R [0:63];
wire [7:0] G [0:63];
wire [7:0] B [0:63];
wire [10:0] power [0:6];
reg  [26:0] abs_iAud;
localparam ao_width = 13;
wire signed [ao_width:0] audOutMatrix [0:6];

always @(posedge aud_clk) begin
	if (iAud < 16'd0) begin
		abs_iAud<=-iAud;
	end
	else begin
	   abs_iAud <= iAud;
	end
	
end
wire [10:0] rectified_power;
		autoGen_LPF  abs_lpf (
			.clk(clk),
			.aud_clk(aud_clk),
			.reset(reset),
			.enable(1'b1),

			.iAud(abs_iAud),

			//.oAud(audOutMatrix[i]),
			.power(rectified_power)
		);



//assign audOut = ao0[ao_width:4] + ao1[ao_width:4] + ao2[ao_width:4] + ao3[ao_width:4] + ao4[ao_width:4] + ao5[ao_width:4] + ao6[ao_width:4]; 
assign audOut = audOutMatrix[0] + audOutMatrix[1] +audOutMatrix[2] +audOutMatrix[3] +audOutMatrix[4] +audOutMatrix[5]+audOutMatrix[6];
generate
	genvar i;
	genvar j;
	for (i=0; i < 7; i = i + 1) begin:xsweep
		autoGen_BPF #(i,ao_width) bp (
			.clk(clk),
			.aud_clk(aud_clk),
			.reset(reset),
			.enable(SW[6-i]),

			.iAud(iAud),

			.oAud(audOutMatrix[i]),
			.power(power[i])
		);

		for (j=0; j < 7; j = j + 1) begin:ysweep
			colorBlock #(75,69,0,13-2*i,5-j) cb (
				.clk(clk),
				.reset(reset),
				
				.pow(power[i]),
				.iVGA_X(iVGA_X),
				.iVGA_Y(iVGA_Y),
				.topLeftX(10+i*90),
				.topLeftY(10+j*79),
				
				.oLayer(),
				.oVal(layer[7*i+j]),
				.R(R[7*i+j]),
				.G(G[7*i+j]),
				.B(B[7*i+j])
			);
		end
	end	
endgenerate

wire [15:0] tfAud;
wire [10:0] tfPow;
wire [31:0] aud_tics_per_beat;


motionManager  mm0 (
  .clk(clk),
  .aud_clk(aud_clk),
  .reset(~KEY2),

  //.aud_clk_tics_per_beat(16'd48000),
  //.beatHit(~KEY2), 
  .beatSignalIn(rectified_power),
  .dancer_en(SW[17:14]), // [0] = d0_en, [1] = d1_en, [2] = d2_en, [3] = bruce_en
  .motionType(),

  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),

  .ibruce_x_init(10'd190),
  .ibruce_y_init(9'd80),
  .obruce_x(bruceX),
  .obruce_y(bruceY),

  .id0_x_init(10'd40),
  .id0_y_init(9'd100),
  .od0_x(connorX),
  .od0_y(connorY),

  .id1_x_init(10'd300),
  .id1_y_init(9'd100),
  .od1_x(noahX),
  .od1_y(noahY),

  .id2_x_init(10'd430),
  .id2_y_init(9'd100),
  .od2_x(shivaX),
  .od2_y(shivaY),
  .LEDG(LEDG)
);


wire [9:0] bruceX;
wire [8:0] bruceY;
wire [9:0] connorX;
wire [8:0] connorY;
wire [9:0] noahX;
wire [8:0] noahY;
wire [9:0] shivaX;
wire [8:0] shivaY;

localparam bruce_X = 240;
localparam bruce_Y = 80;

drawBruce db0 (
   .clk(clk),
   .reset(reset),
   .enable(SW[7]),
   .motion_en(1'b0),

   .iVGA_X(iVGA_X),
   .iVGA_Y(iVGA_Y),

    .current_topLeft_X(bruceX),
    .current_topLeft_Y(bruceY),
    .init_topLeftX(10'd160),
    .init_topLeftY(9'd80),
	 .oVal(layer[56]),
    .oR(R[56]),
    .oG(G[56]),
    .oB(B[56]),
  );

//drawConnor dc0 (
//   .clk(clk),
//   .reset(reset),
//   .enable(SW[8]),
//   .motion_en(1'b0),
//
//   .iVGA_X(iVGA_X),
//   .iVGA_Y(iVGA_Y),
//
//    .current_topLeft_X(connorX),
//    .current_topLeft_Y(connorY),
//    .init_topLeftX(10'd40),
//    .init_topLeftY(9'd100),
//	 .oVal(layer[55]),
//    .oR(R[55]),
//    .oG(G[55]),
//    .oB(B[55]),
//  );
//
//drawNoah dn0 (
//   .clk(clk),
//   .reset(reset),
//   .enable(SW[9]),
//   .motion_en(1'b0),
//
//   .iVGA_X(iVGA_X),
//   .iVGA_Y(iVGA_Y),
//
//    .current_topLeft_X(noahX),
//    .current_topLeft_Y(noahY),
//    .init_topLeftX(10'd300),
//    .init_topLeftY(9'd100),
//	 .oVal(layer[54]),
//    .oR(R[54]),
//    .oG(G[54]),
//    .oB(B[54]),
//  );
//
//drawShiva ds0 (
//   .clk(clk),
//   .reset(reset),
//   .enable(SW[10]),
//   .motion_en(1'b0),
//
//   .iVGA_X(iVGA_X),
//   .iVGA_Y(iVGA_Y),
//
//    .current_topLeft_X(shivaX),
//    .current_topLeft_Y(shivaY),
//    .init_topLeftX(10'd430),
//    .init_topLeftY(9'd80),
//	 .oVal(layer[53]),
//    .oR(R[53]),
//    .oG(G[53]),
//    .oB(B[53]),
//  );

msbOneHot msb0 (layer,layerOH);

wire [10:0] pow2word = power[2];


hex_7seg(rectified_power[3:0],HEX0);
hex_7seg(rectified_power[7:4],HEX1);
hex_7seg(rectified_power[10:8],HEX2);
/*
hex_7seg(iAudL[15:12],HEX3);
hex_7seg(iAudR[3:0],HEX4);
hex_7seg(iAudR[7:4],HEX5);
hex_7seg(iAudR[11:8],HEX6);
hex_7seg(iAudR[15:12],HEX7);
*/
//hex7seg(pow3word[3:0],HEX3);

// MATLAB  generated case statement
always @(posedge clk) begin
	case(layerOH)
		(1<<59): begin
		oR <= R[59];
		oB <= B[59];
		oG <= G[59];
	end
	(1<<58): begin
		oR <= R[58];
		oB <= B[58];
		oG <= G[58];
	end
	(1<<57): begin
		oR <= R[57];
		oB <= B[57];
		oG <= G[57];
	end
	(1<<56): begin
		oR <= R[56];
		oB <= B[56];
		oG <= G[56];
	end
	(1<<55): begin
		oR <= R[55];
		oB <= B[55];
		oG <= G[55];
	end
	(1<<54): begin
		oR <= R[54];
		oB <= B[54];
		oG <= G[54];
	end
	(1<<53): begin
		oR <= R[53];
		oB <= B[53];
		oG <= G[53];
	end
	(1<<52): begin
		oR <= R[52];
		oB <= B[52];
		oG <= G[52];
	end
	(1<<51): begin
		oR <= R[51];
		oB <= B[51];
		oG <= G[51];
	end
	(1<<50): begin
		oR <= R[50];
		oB <= B[50];
		oG <= G[50];
	end
	(1<<49): begin
		oR <= R[49];
		oB <= B[49];
		oG <= G[49];
	end
	(1<<48): begin
		oR <= R[48];
		oB <= B[48];
		oG <= G[48];
	end
	(1<<47): begin
		oR <= R[47];
		oB <= B[47];
		oG <= G[47];
	end
	(1<<46): begin
		oR <= R[46];
		oB <= B[46];
		oG <= G[46];
	end
	(1<<45): begin
		oR <= R[45];
		oB <= B[45];
		oG <= G[45];
	end
	(1<<44): begin
		oR <= R[44];
		oB <= B[44];
		oG <= G[44];
	end
	(1<<43): begin
		oR <= R[43];
		oB <= B[43];
		oG <= G[43];
	end
	(1<<42): begin
		oR <= R[42];
		oB <= B[42];
		oG <= G[42];
	end
	(1<<41): begin
		oR <= R[41];
		oB <= B[41];
		oG <= G[41];
	end
	(1<<40): begin
		oR <= R[40];
		oB <= B[40];
		oG <= G[40];
	end
	(1<<39): begin
		oR <= R[39];
		oB <= B[39];
		oG <= G[39];
	end
	(1<<38): begin
		oR <= R[38];
		oB <= B[38];
		oG <= G[38];
	end
	(1<<37): begin
		oR <= R[37];
		oB <= B[37];
		oG <= G[37];
	end
	(1<<36): begin
		oR <= R[36];
		oB <= B[36];
		oG <= G[36];
	end
	(1<<35): begin
		oR <= R[35];
		oB <= B[35];
		oG <= G[35];
	end
	(1<<34): begin
		oR <= R[34];
		oB <= B[34];
		oG <= G[34];
	end
	(1<<33): begin
		oR <= R[33];
		oB <= B[33];
		oG <= G[33];
	end
	(1<<32): begin
		oR <= R[32];
		oB <= B[32];
		oG <= G[32];
	end
	(1<<31): begin
		oR <= R[31];
		oB <= B[31];
		oG <= G[31];
	end
	(1<<30): begin
		oR <= R[30];
		oB <= B[30];
		oG <= G[30];
	end
	(1<<29): begin
		oR <= R[29];
		oB <= B[29];
		oG <= G[29];
	end
	(1<<28): begin
		oR <= R[28];
		oB <= B[28];
		oG <= G[28];
	end
	(1<<27): begin
		oR <= R[27];
		oB <= B[27];
		oG <= G[27];
	end
	(1<<26): begin
		oR <= R[26];
		oB <= B[26];
		oG <= G[26];
	end
	(1<<25): begin
		oR <= R[25];
		oB <= B[25];
		oG <= G[25];
	end
	(1<<24): begin
		oR <= R[24];
		oB <= B[24];
		oG <= G[24];
	end
	(1<<23): begin
		oR <= R[23];
		oB <= B[23];
		oG <= G[23];
	end
	(1<<22): begin
		oR <= R[22];
		oB <= B[22];
		oG <= G[22];
	end
	(1<<21): begin
		oR <= R[21];
		oB <= B[21];
		oG <= G[21];
	end
	(1<<20): begin
		oR <= R[20];
		oB <= B[20];
		oG <= G[20];
	end
	(1<<19): begin
		oR <= R[19];
		oB <= B[19];
		oG <= G[19];
	end
	(1<<18): begin
		oR <= R[18];
		oB <= B[18];
		oG <= G[18];
	end
	(1<<17): begin
		oR <= R[17];
		oB <= B[17];
		oG <= G[17];
	end
	(1<<16): begin
		oR <= R[16];
		oB <= B[16];
		oG <= G[16];
	end
	(1<<15): begin
		oR <= R[15];
		oB <= B[15];
		oG <= G[15];
	end
	(1<<14): begin
		oR <= R[14];
		oB <= B[14];
		oG <= G[14];
	end
	(1<<13): begin
		oR <= R[13];
		oB <= B[13];
		oG <= G[13];
	end
	(1<<12): begin
		oR <= R[12];
		oB <= B[12];
		oG <= G[12];
	end
	(1<<11): begin
		oR <= R[11];
		oB <= B[11];
		oG <= G[11];
	end
	(1<<10): begin
		oR <= R[10];
		oB <= B[10];
		oG <= G[10];
	end
	(1<<9): begin
		oR <= R[9];
		oB <= B[9];
		oG <= G[9];
	end
	(1<<8): begin
		oR <= R[8];
		oB <= B[8];
		oG <= G[8];
	end
	(1<<7): begin
		oR <= R[7];
		oB <= B[7];
		oG <= G[7];
	end
	(1<<6): begin
		oR <= R[6];
		oB <= B[6];
		oG <= G[6];
	end
	(1<<5): begin
		oR <= R[5];
		oB <= B[5];
		oG <= G[5];
	end
	(1<<4): begin
		oR <= R[4];
		oB <= B[4];
		oG <= G[4];
	end
	(1<<3): begin
		oR <= R[3];
		oB <= B[3];
		oG <= G[3];
	end
	(1<<2): begin
		oR <= R[2];
		oB <= B[2];
		oG <= G[2];
	end
	(1<<1): begin
		oR <= R[1];
		oB <= B[1];
		oG <= G[1];
	end
	(1<<0): begin
		oR <= R[0];
		oG <= G[0];
		oB <= B[0];
	end
	default: begin
		oR <= 8'd0;
		oG <= 8'd0;
		oB <= 8'd0;
	end
	endcase
end

endmodule