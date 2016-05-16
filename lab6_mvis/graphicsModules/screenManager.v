module screenManager (
	input clk,
	input aud_clk,
	input reset,
	input KEY2,

	input [9:0]  iVGA_X,
	input [8:0]  iVGA_Y,
	input [15:0] iAudL,
	input [15:0] iAudR,
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
	output wire [6:0] HEX7
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

wire [160:0] layer;
wire [160:0] layerOH;

wire [7:0] R [0:160];
wire [7:0] G [0:160];
wire [7:0] B [0:160];
wire [10:0] power [0:6];

generate
	genvar i;
	genvar j;
	for (i=0; i < 7; i = i + 1) begin:xsweep
		/*
		autoGen_BPF #(i) bp (
			.clk(clk),
			.aud_clk(aud_clk),
			.reset(reset),
			.enable(SW[6-i]),

			.iAud_L(iAudL),
			.iAud_R(iAudR),

			.oAud_L(),
			.oAud_R(),
			.power(power[i])
		);
		*/

		for (j=0; j < 18; j = j + 1) begin:ysweep
			colorBlock #(85,22,0,13-2*i,17-j) cb (
				.clk(clk),
				.reset(reset),
				
				.pow(power[i]),
				.iVGA_X(iVGA_X),
				.iVGA_Y(iVGA_Y),
				.topLeftX(10+i*105),
				.topLeftY(10+j*26),
				
				.oLayer(),
				.oVal(layer[18*i+j]),
				.R(R[18*i+j]),
				.G(G[18*i+j]),
				.B(B[18*i+j])
			);
		end
	end	
endgenerate

wire [15:0] tfAud;
wire [10:0] tfPow;
wire [31:0] aud_tics_per_beat;

/*
autoGen_BPF #(0) beatFilter (
			.clk(clk),
			.aud_clk(aud_clk),
			.reset(reset),
			.enable(1'b1),

			.iAud_L(iAudL),
			.iAud_R(iAudR),

			.oAud_L(tfAud),
			.oAud_R(),
			.power(tfPow)
		);

tempoFinder tf0 (
	.aud_clk(aud_clk),
	.reset(reset),
	.iPow(tfPow),

	.aud_tics_per_beat(aud_tics_per_beat)
	);

motionManager  mm0 (
  .clk(clk),
  .aud_clk(aud_clk),
  .reset(~KEY2),

  .aud_clk_tics_per_beat(16'd48000),
  .beatHit(~KEY2),
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

  .id1_x_init(10'd340),
  .id1_y_init(9'd100),
  .od1_x(noahX),
  .od1_y(noahY),

  .id2_x_init(10'd340),
  .id2_y_init(9'd100),
  .od2_x(shivaX),
  .od2_y(shivaY),
);
*/

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
/*
drawBruce db0 (
   .clk(clk),
   .reset(reset),
   .enable(SW[6]),
   .motion_en(1'b0),

   .iVGA_X(iVGA_X),
   .iVGA_Y(iVGA_Y),

    .current_topLeft_X(bruceX),
    .current_topLeft_Y(bruceY),
    .init_topLeftX(10'd160),
    .init_topLeftY(9'd80),
	 .oVal(layer[40]),
    .oR(R[40]),
    .oG(G[40]),
    .oB(B[40]),
  );

drawConnor dc0 (
   .clk(clk),
   .reset(reset),
   .enable(SW[7]),
   .motion_en(1'b0),

   .iVGA_X(iVGA_X),
   .iVGA_Y(iVGA_Y),

    .current_topLeft_X(connorX),
    .current_topLeft_Y(connorY),
    .init_topLeftX(10'd40),
    .init_topLeftY(9'd100),
	 .oVal(layer[39]),
    .oR(R[39]),
    .oG(G[39]),
    .oB(B[39]),
  );

drawNoah dn0 (
   .clk(clk),
   .reset(reset),
   .enable(SW[8]),
   .motion_en(1'b0),

   .iVGA_X(iVGA_X),
   .iVGA_Y(iVGA_Y),

    .current_topLeft_X(noahX),
    .current_topLeft_Y(noahY),
    .init_topLeftX(10'd280),
    .init_topLeftY(9'd100),
	 .oVal(layer[38]),
    .oR(R[38]),
    .oG(G[38]),
    .oB(B[38]),
  );

drawShiva ds0 (
   .clk(clk),
   .reset(reset),
   .enable(SW[9]),
   .motion_en(1'b0),

   .iVGA_X(iVGA_X),
   .iVGA_Y(iVGA_Y),

    .current_topLeft_X(shivaX),
    .current_topLeft_Y(shivaY),
    .init_topLeftX(10'd400),
    .init_topLeftY(9'd80),
	 .oVal(layer[37]),
    .oR(R[37]),
    .oG(G[37]),
    .oB(B[37]),
  );
*/
msbOneHot msb0 (layer,layerOH);

wire [10:0] pow3word = power[3];

hex_7seg(iAudL[3:0],HEX0);
hex_7seg(iAudL[7:4],HEX1);
hex_7seg(iAudL[11:8],HEX2);
hex_7seg(iAudL[15:12],HEX3);
hex_7seg(iAudR[3:0],HEX4);
hex_7seg(iAudR[7:4],HEX5);
hex_7seg(iAudR[11:8],HEX6);
hex_7seg(iAudR[15:12],HEX7);
//hex7seg(pow3word[3:0],HEX3);

// MATLAB  generated case statement
always @(posedge clk) begin
	case(layerOH)
(1<<0): begin
oR <= R[0];
oG <= G[0];
oB <= B[0];
end

(1<<1): begin
oR <= R[1];
oG <= G[1];
oB <= B[1];
end

(1<<2): begin
oR <= R[2];
oG <= G[2];
oB <= B[2];
end

(1<<3): begin
oR <= R[3];
oG <= G[3];
oB <= B[3];
end

(1<<4): begin
oR <= R[4];
oG <= G[4];
oB <= B[4];
end

(1<<5): begin
oR <= R[5];
oG <= G[5];
oB <= B[5];
end

(1<<6): begin
oR <= R[6];
oG <= G[6];
oB <= B[6];
end

(1<<7): begin
oR <= R[7];
oG <= G[7];
oB <= B[7];
end

(1<<8): begin
oR <= R[8];
oG <= G[8];
oB <= B[8];
end

(1<<9): begin
oR <= R[9];
oG <= G[9];
oB <= B[9];
end

(1<<10): begin
oR <= R[10];
oG <= G[10];
oB <= B[10];
end

(1<<11): begin
oR <= R[11];
oG <= G[11];
oB <= B[11];
end

(1<<12): begin
oR <= R[12];
oG <= G[12];
oB <= B[12];
end

(1<<13): begin
oR <= R[13];
oG <= G[13];
oB <= B[13];
end

(1<<14): begin
oR <= R[14];
oG <= G[14];
oB <= B[14];
end

(1<<15): begin
oR <= R[15];
oG <= G[15];
oB <= B[15];
end

(1<<16): begin
oR <= R[16];
oG <= G[16];
oB <= B[16];
end

(1<<17): begin
oR <= R[17];
oG <= G[17];
oB <= B[17];
end

(1<<18): begin
oR <= R[18];
oG <= G[18];
oB <= B[18];
end

(1<<19): begin
oR <= R[19];
oG <= G[19];
oB <= B[19];
end

(1<<20): begin
oR <= R[20];
oG <= G[20];
oB <= B[20];
end

(1<<21): begin
oR <= R[21];
oG <= G[21];
oB <= B[21];
end

(1<<22): begin
oR <= R[22];
oG <= G[22];
oB <= B[22];
end

(1<<23): begin
oR <= R[23];
oG <= G[23];
oB <= B[23];
end

(1<<24): begin
oR <= R[24];
oG <= G[24];
oB <= B[24];
end

(1<<25): begin
oR <= R[25];
oG <= G[25];
oB <= B[25];
end

(1<<26): begin
oR <= R[26];
oG <= G[26];
oB <= B[26];
end

(1<<27): begin
oR <= R[27];
oG <= G[27];
oB <= B[27];
end

(1<<28): begin
oR <= R[28];
oG <= G[28];
oB <= B[28];
end

(1<<29): begin
oR <= R[29];
oG <= G[29];
oB <= B[29];
end

(1<<30): begin
oR <= R[30];
oG <= G[30];
oB <= B[30];
end

(1<<31): begin
oR <= R[31];
oG <= G[31];
oB <= B[31];
end

(1<<32): begin
oR <= R[32];
oG <= G[32];
oB <= B[32];
end

(1<<33): begin
oR <= R[33];
oG <= G[33];
oB <= B[33];
end

(1<<34): begin
oR <= R[34];
oG <= G[34];
oB <= B[34];
end

(1<<35): begin
oR <= R[35];
oG <= G[35];
oB <= B[35];
end

(1<<36): begin
oR <= R[36];
oG <= G[36];
oB <= B[36];
end

(1<<37): begin
oR <= R[37];
oG <= G[37];
oB <= B[37];
end

(1<<38): begin
oR <= R[38];
oG <= G[38];
oB <= B[38];
end

(1<<39): begin
oR <= R[39];
oG <= G[39];
oB <= B[39];
end

(1<<40): begin
oR <= R[40];
oG <= G[40];
oB <= B[40];
end

(1<<41): begin
oR <= R[41];
oG <= G[41];
oB <= B[41];
end

(1<<42): begin
oR <= R[42];
oG <= G[42];
oB <= B[42];
end

(1<<43): begin
oR <= R[43];
oG <= G[43];
oB <= B[43];
end

(1<<44): begin
oR <= R[44];
oG <= G[44];
oB <= B[44];
end

(1<<45): begin
oR <= R[45];
oG <= G[45];
oB <= B[45];
end

(1<<46): begin
oR <= R[46];
oG <= G[46];
oB <= B[46];
end

(1<<47): begin
oR <= R[47];
oG <= G[47];
oB <= B[47];
end

(1<<48): begin
oR <= R[48];
oG <= G[48];
oB <= B[48];
end

(1<<49): begin
oR <= R[49];
oG <= G[49];
oB <= B[49];
end

(1<<50): begin
oR <= R[50];
oG <= G[50];
oB <= B[50];
end

(1<<51): begin
oR <= R[51];
oG <= G[51];
oB <= B[51];
end

(1<<52): begin
oR <= R[52];
oG <= G[52];
oB <= B[52];
end

(1<<53): begin
oR <= R[53];
oG <= G[53];
oB <= B[53];
end

(1<<54): begin
oR <= R[54];
oG <= G[54];
oB <= B[54];
end

(1<<55): begin
oR <= R[55];
oG <= G[55];
oB <= B[55];
end

(1<<56): begin
oR <= R[56];
oG <= G[56];
oB <= B[56];
end

(1<<57): begin
oR <= R[57];
oG <= G[57];
oB <= B[57];
end

(1<<58): begin
oR <= R[58];
oG <= G[58];
oB <= B[58];
end

(1<<59): begin
oR <= R[59];
oG <= G[59];
oB <= B[59];
end

(1<<60): begin
oR <= R[60];
oG <= G[60];
oB <= B[60];
end

(1<<61): begin
oR <= R[61];
oG <= G[61];
oB <= B[61];
end

(1<<62): begin
oR <= R[62];
oG <= G[62];
oB <= B[62];
end

(1<<63): begin
oR <= R[63];
oG <= G[63];
oB <= B[63];
end

(1<<64): begin
oR <= R[64];
oG <= G[64];
oB <= B[64];
end

(1<<65): begin
oR <= R[65];
oG <= G[65];
oB <= B[65];
end

(1<<66): begin
oR <= R[66];
oG <= G[66];
oB <= B[66];
end

(1<<67): begin
oR <= R[67];
oG <= G[67];
oB <= B[67];
end

(1<<68): begin
oR <= R[68];
oG <= G[68];
oB <= B[68];
end

(1<<69): begin
oR <= R[69];
oG <= G[69];
oB <= B[69];
end

(1<<70): begin
oR <= R[70];
oG <= G[70];
oB <= B[70];
end

(1<<71): begin
oR <= R[71];
oG <= G[71];
oB <= B[71];
end

(1<<72): begin
oR <= R[72];
oG <= G[72];
oB <= B[72];
end

(1<<73): begin
oR <= R[73];
oG <= G[73];
oB <= B[73];
end

(1<<74): begin
oR <= R[74];
oG <= G[74];
oB <= B[74];
end

(1<<75): begin
oR <= R[75];
oG <= G[75];
oB <= B[75];
end

(1<<76): begin
oR <= R[76];
oG <= G[76];
oB <= B[76];
end

(1<<77): begin
oR <= R[77];
oG <= G[77];
oB <= B[77];
end

(1<<78): begin
oR <= R[78];
oG <= G[78];
oB <= B[78];
end

(1<<79): begin
oR <= R[79];
oG <= G[79];
oB <= B[79];
end

(1<<80): begin
oR <= R[80];
oG <= G[80];
oB <= B[80];
end

(1<<81): begin
oR <= R[81];
oG <= G[81];
oB <= B[81];
end

(1<<82): begin
oR <= R[82];
oG <= G[82];
oB <= B[82];
end

(1<<83): begin
oR <= R[83];
oG <= G[83];
oB <= B[83];
end

(1<<84): begin
oR <= R[84];
oG <= G[84];
oB <= B[84];
end

(1<<85): begin
oR <= R[85];
oG <= G[85];
oB <= B[85];
end

(1<<86): begin
oR <= R[86];
oG <= G[86];
oB <= B[86];
end

(1<<87): begin
oR <= R[87];
oG <= G[87];
oB <= B[87];
end

(1<<88): begin
oR <= R[88];
oG <= G[88];
oB <= B[88];
end

(1<<89): begin
oR <= R[89];
oG <= G[89];
oB <= B[89];
end

(1<<90): begin
oR <= R[90];
oG <= G[90];
oB <= B[90];
end

(1<<91): begin
oR <= R[91];
oG <= G[91];
oB <= B[91];
end

(1<<92): begin
oR <= R[92];
oG <= G[92];
oB <= B[92];
end

(1<<93): begin
oR <= R[93];
oG <= G[93];
oB <= B[93];
end

(1<<94): begin
oR <= R[94];
oG <= G[94];
oB <= B[94];
end

(1<<95): begin
oR <= R[95];
oG <= G[95];
oB <= B[95];
end

(1<<96): begin
oR <= R[96];
oG <= G[96];
oB <= B[96];
end

(1<<97): begin
oR <= R[97];
oG <= G[97];
oB <= B[97];
end

(1<<98): begin
oR <= R[98];
oG <= G[98];
oB <= B[98];
end

(1<<99): begin
oR <= R[99];
oG <= G[99];
oB <= B[99];
end

(1<<100): begin
oR <= R[100];
oG <= G[100];
oB <= B[100];
end

(1<<101): begin
oR <= R[101];
oG <= G[101];
oB <= B[101];
end

(1<<102): begin
oR <= R[102];
oG <= G[102];
oB <= B[102];
end

(1<<103): begin
oR <= R[103];
oG <= G[103];
oB <= B[103];
end

(1<<104): begin
oR <= R[104];
oG <= G[104];
oB <= B[104];
end

(1<<105): begin
oR <= R[105];
oG <= G[105];
oB <= B[105];
end

(1<<106): begin
oR <= R[106];
oG <= G[106];
oB <= B[106];
end

(1<<107): begin
oR <= R[107];
oG <= G[107];
oB <= B[107];
end

(1<<108): begin
oR <= R[108];
oG <= G[108];
oB <= B[108];
end

(1<<109): begin
oR <= R[109];
oG <= G[109];
oB <= B[109];
end

(1<<110): begin
oR <= R[110];
oG <= G[110];
oB <= B[110];
end

(1<<111): begin
oR <= R[111];
oG <= G[111];
oB <= B[111];
end

(1<<112): begin
oR <= R[112];
oG <= G[112];
oB <= B[112];
end

(1<<113): begin
oR <= R[113];
oG <= G[113];
oB <= B[113];
end

(1<<114): begin
oR <= R[114];
oG <= G[114];
oB <= B[114];
end

(1<<115): begin
oR <= R[115];
oG <= G[115];
oB <= B[115];
end

(1<<116): begin
oR <= R[116];
oG <= G[116];
oB <= B[116];
end

(1<<117): begin
oR <= R[117];
oG <= G[117];
oB <= B[117];
end

(1<<118): begin
oR <= R[118];
oG <= G[118];
oB <= B[118];
end

(1<<119): begin
oR <= R[119];
oG <= G[119];
oB <= B[119];
end

(1<<120): begin
oR <= R[120];
oG <= G[120];
oB <= B[120];
end

(1<<121): begin
oR <= R[121];
oG <= G[121];
oB <= B[121];
end

(1<<122): begin
oR <= R[122];
oG <= G[122];
oB <= B[122];
end

(1<<123): begin
oR <= R[123];
oG <= G[123];
oB <= B[123];
end

(1<<124): begin
oR <= R[124];
oG <= G[124];
oB <= B[124];
end

(1<<125): begin
oR <= R[125];
oG <= G[125];
oB <= B[125];
end

(1<<126): begin
oR <= R[126];
oG <= G[126];
oB <= B[126];
end

(1<<127): begin
oR <= R[127];
oG <= G[127];
oB <= B[127];
end

(1<<128): begin
oR <= R[128];
oG <= G[128];
oB <= B[128];
end

(1<<129): begin
oR <= R[129];
oG <= G[129];
oB <= B[129];
end

(1<<130): begin
oR <= R[130];
oG <= G[130];
oB <= B[130];
end

(1<<131): begin
oR <= R[131];
oG <= G[131];
oB <= B[131];
end

(1<<132): begin
oR <= R[132];
oG <= G[132];
oB <= B[132];
end

(1<<133): begin
oR <= R[133];
oG <= G[133];
oB <= B[133];
end

(1<<134): begin
oR <= R[134];
oG <= G[134];
oB <= B[134];
end

(1<<135): begin
oR <= R[135];
oG <= G[135];
oB <= B[135];
end

(1<<136): begin
oR <= R[136];
oG <= G[136];
oB <= B[136];
end

(1<<137): begin
oR <= R[137];
oG <= G[137];
oB <= B[137];
end

(1<<138): begin
oR <= R[138];
oG <= G[138];
oB <= B[138];
end

(1<<139): begin
oR <= R[139];
oG <= G[139];
oB <= B[139];
end

(1<<140): begin
oR <= R[140];
oG <= G[140];
oB <= B[140];
end

(1<<141): begin
oR <= R[141];
oG <= G[141];
oB <= B[141];
end

(1<<142): begin
oR <= R[142];
oG <= G[142];
oB <= B[142];
end

(1<<143): begin
oR <= R[143];
oG <= G[143];
oB <= B[143];
end

(1<<144): begin
oR <= R[144];
oG <= G[144];
oB <= B[144];
end

(1<<145): begin
oR <= R[145];
oG <= G[145];
oB <= B[145];
end

(1<<146): begin
oR <= R[146];
oG <= G[146];
oB <= B[146];
end

(1<<147): begin
oR <= R[147];
oG <= G[147];
oB <= B[147];
end

(1<<148): begin
oR <= R[148];
oG <= G[148];
oB <= B[148];
end

(1<<149): begin
oR <= R[149];
oG <= G[149];
oB <= B[149];
end

(1<<150): begin
oR <= R[150];
oG <= G[150];
oB <= B[150];
end

(1<<151): begin
oR <= R[151];
oG <= G[151];
oB <= B[151];
end

(1<<152): begin
oR <= R[152];
oG <= G[152];
oB <= B[152];
end

(1<<153): begin
oR <= R[153];
oG <= G[153];
oB <= B[153];
end

(1<<154): begin
oR <= R[154];
oG <= G[154];
oB <= B[154];
end

(1<<155): begin
oR <= R[155];
oG <= G[155];
oB <= B[155];
end

(1<<156): begin
oR <= R[156];
oG <= G[156];
oB <= B[156];
end

(1<<157): begin
oR <= R[157];
oG <= G[157];
oB <= B[157];
end

(1<<158): begin
oR <= R[158];
oG <= G[158];
oB <= B[158];
end

(1<<159): begin
oR <= R[159];
oG <= G[159];
oB <= B[159];
end

default: begin
oR <= 8'd0;oG <= 8'd0;
oB <= 8'd0;
end

	endcase
end

endmodule