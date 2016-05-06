module drawConnor (
  input clk,
  input reset,
  input enable,
  input motion_en,

  input [9:0] iVGA_X,
  input [8:0] iVGA_Y,

  input [9:0] current_topLeft_X,
  input [8:0] current_topLeft_Y,
  input [9:0] init_topLeftX,
  input [8:0] init_topLeftY,
	
  output reg oVal,
  output reg [7:0] oR,
  output reg [7:0] oG,
  output reg [7:0] oB
  );


wire [4:0] layer;
wire [4:0] layerOH;

wire [7:0] R [0:4];
wire [7:0] G [0:4];
wire [7:0] B [0:4];


connor_headBlock  hb0
(
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .motion_en(motion_en),
  
  .pow(),
  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),
  .topLeft_X(current_topLeft_X),
  .topLeft_Y(current_topLeft_Y),
  .init_X(init_topLeftX),
  .init_Y(init_topLeftY),
  
  .oLayer(),
  .oVal(layer[4]),
  .R(R[4]),
  .G(G[4]),
  .B(B[4])
);

tux_bodyBlock  bbb0
(
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .motion_en(motion_en),
  
  .pow(),
  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),
  .topLeft_X(current_topLeft_X),
  .topLeft_Y(current_topLeft_Y),
  .init_X(init_topLeftX),
  .init_Y(init_topLeftY+9'd94),
  
  .oLayer(),
  .oVal(layer[1]),
  .R(R[1]),
  .G(G[1]),
  .B(B[1])
);
tux_arm_LBlock alb0
(
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .motion_en(motion_en),
  
  .pow(),
  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),
  .topLeft_X(current_topLeft_X),
  .topLeft_Y(current_topLeft_Y+9'd105),
  .init_X(init_topLeftX-10'd17),
  .init_Y(init_topLeftY+9'd105),
  
  .oLayer(),
  .oVal(layer[2]),
  .R(R[2]),
  .G(G[2]),
  .B(B[2])
);

tux_arm_RBlock arb0
(
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .motion_en(motion_en),
  
  .pow(),
  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),
  .topLeft_X(current_topLeft_X),
  .topLeft_Y(current_topLeft_Y),
  .init_X(init_topLeftX+10'd90),
  .init_Y(init_topLeftY),
  
  .oLayer(),
  .oVal(layer[3]),
  .R(R[3]),
  .G(G[3]),
  .B(B[3])
);

tux_pantsBlock  tpb0
(
  .clk(clk),
  .reset(reset),
  .enable(enable),
  .motion_en(motion_en),
  
  .pow(),
  .iVGA_X(iVGA_X),
  .iVGA_Y(iVGA_Y),
  .topLeft_X(current_topLeft_X),
  .topLeft_Y(current_topLeft_Y),
  .init_X(init_topLeftX+10'd5),
  .init_Y(init_topLeftY+9'd156),
  
  .oLayer(),
  .oVal(layer[0]),
  .R(R[0]),
  .G(G[0]),
  .B(B[0])
);

msbOneHot msb0 (layer,layerOH);

always @(posedge clk) begin
	if (layerOH>0) begin
		oVal <= 1'b1;
	end
	else begin
		oVal <= 1'b0;
	end
  case(layerOH)
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