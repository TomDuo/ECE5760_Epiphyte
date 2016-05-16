module autoGen_BPF #(
  parameter filterID = 0 // lower num = lower BP4
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

  input signed [15:0] iAud_L,
  input signed [15:0] iAud_R,

  output reg signed [15:0] oAud_L,
  output reg signed [15:0] oAud_R,
  output reg [10:0]  power
);

reg  signed [26:0] y;
reg  signed [26:0] y1;
reg  signed [26:0] y2;
reg  signed [26:0] y3;
reg  signed [26:0] y4;

reg  signed [26:0] x;
reg  signed [26:0] x1;
reg  signed [26:0] x2;
reg  signed [26:0] x3;
reg  signed [26:0] x4;

reg  signed [26:0] a0;
reg  signed [26:0] a1;
reg  signed [26:0] a2;
reg  signed [26:0] a3;
reg  signed [26:0] a4;


reg  signed [26:0] b0;
reg  signed [26:0] b1;
reg  signed [26:0] b2;
reg  signed [26:0] b3;
reg  signed [26:0] b4;


wire signed [26:0] mul_b0_x0;
wire signed [26:0] mul_b1_x1;
wire signed [26:0] mul_b2_x2;
wire signed [26:0] mul_b3_x3;
wire signed [26:0] mul_b4_x4;

wire signed [26:0] mul_a0_y0;
wire signed [26:0] mul_a1_y1;
wire signed [26:0] mul_a2_y2;
wire signed [26:0] mul_a3_y3;
wire signed [26:0] mul_a4_y4;


fixed_comb_mult5760 mulb0 (x,b0,mul_b0_x0);
fixed_comb_mult5760 mulb1 (x1,b1,mul_b1_x1);
fixed_comb_mult5760 mulb2 (x2,b2,mul_b2_x2);
fixed_comb_mult5760 mulb3 (x3,b3,mul_b3_x3);
fixed_comb_mult5760 mulb4 (x4,b4,mul_b4_x4);

fixed_comb_mult5760 mula1 (y1,a1,mul_a1_y1);
fixed_comb_mult5760 mula2 (y2,a2,mul_a2_y2);
fixed_comb_mult5760 mula3 (y3,a3,mul_a3_y3);
fixed_comb_mult5760 mula4 (y4,a4,mul_a4_y4);

always @ (posedge clk) begin
case(filterID)

0: begin
b0 <= 27'b000_0000_0000_0000_0000_0000_0011;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1111_1111_1111_1111_1001;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0000_0000_0000_0000_0011;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0000_0000_0011_1100_1011_1111;
a2 <= 27'b011_1111_1111_0100_1001_1110_1000;
a3 <= 27'b110_0000_0000_1011_0101_1111_0100;
a4 <= 27'b000_0111_1111_1100_0011_0110_0101;
end

1: begin
b0 <= 27'b000_0000_0000_0000_0000_0010_0000;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1111_1111_1111_1100_0000;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0000_0000_0000_0010_0000;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0000_0000_1011_0110_1011_1101;
a2 <= 27'b011_1111_1101_1101_1101_0000_1101;
a3 <= 27'b110_0000_0010_0010_0001_1011_0000;
a4 <= 27'b000_0111_1111_0100_1010_1000_0110;
end

2: begin
b0 <= 27'b000_0000_0000_0000_0001_0010_0000;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1111_1111_1101_1011_1111;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0000_0000_0001_0010_0000;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0000_0010_0010_1000_1011_1001;
a2 <= 27'b011_1111_1001_1001_0001_0011_0001;
a3 <= 27'b110_0000_0110_0110_0011_1000_0001;
a4 <= 27'b000_0111_1101_1110_0010_1001_0100;
end

3: begin
b0 <= 27'b000_0000_0000_0000_1001_1111_1011;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1111_1110_1100_0000_1010;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0000_0000_1001_1111_1011;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0000_0110_1010_0010_0010_0001;
a2 <= 27'b011_1110_1100_0111_1111_1011_0100;
a3 <= 27'b110_0001_0011_0001_1011_1100_0100;
a4 <= 27'b000_0111_1001_1100_0010_0110_1110;
end

4: begin
b0 <= 27'b000_0000_0000_0101_0101_1001_1010;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1111_0101_0100_1100_1100;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0000_0101_0101_1001_1010;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0001_0101_0011_1101_0100_0001;
a2 <= 27'b011_1100_0011_1101_1011_0101_0010;
a3 <= 27'b110_0011_1000_1011_1100_0110_1010;
a4 <= 27'b000_0110_1110_0010_1101_0010_1101;
end

5: begin
b0 <= 27'b000_0000_0010_1010_0001_0000_1100;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1111_1010_1011_1101_1110_0111;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0000_0010_1010_0001_0000_1100;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b110_0100_1010_0010_1110_1100_1101;
a2 <= 27'b010_0100_0001_0110_0011_1101_0001;
a3 <= 27'b110_1010_0011_0110_0001_0001_1100;
a4 <= 27'b000_0101_0001_1010_0011_1001_0001;
end

6: begin
b0 <= 27'b000_0001_0001_0001_1110_0100_1111;
b1 <= 27'b000_0000_0000_0000_0000_0000_0000;
b2 <= 27'b111_1101_1101_1100_0011_0110_0001;
b3 <= 27'b000_0000_0000_0000_0000_0000_0000;
b4 <= 27'b000_0001_0001_0001_1110_0100_1111;
a0 <= 27'b000_1000_0000_0000_0000_0000_0000;
a1 <= 27'b111_0001_1100_0100_0100_0111_1000;
a2 <= 27'b000_1100_1010_0110_1011_1001_0111;
a3 <= 27'b111_1001_0110_0011_0001_0111_0110;
a4 <= 27'b000_0010_0010_0101_0111_1000_1011;
end
endcase
end

wire signed [26:0] lpf_y;
reg  signed [26:0] mag_y;
lpf lpf0(
  .clk(clk),
  .aud_clk(aud_clk),
  .reset(reset),

  .in(mag_y),
  .out(lpf_y)
);

always @ (posedge aud_clk) begin
  if (reset) begin
      oAud_R <= 16'd0;
      oAud_L <= 16'd0;
      power  <= 11'd0;
      x  <= 27'd0;
      x1 <= 27'd0;
      x2 <= 27'd0;
      x3 <= 27'd0;
      x4 <= 27'd0;

      y  <= 27'd0;
      y1 <= 27'd0;
      y2 <= 27'd0;
      y3 <= 27'd0;
      y4 <= 27'd0;

  end
  else if (enable) begin
    // I think these top two need to be blocking
    x  <= {{3{iAud_L[15]}},iAud_L,8'd0}; // iAud_L is [-1,1]. Map to 4_16 by extending first bit
    x1 <= x;
    x2 <= x1;
    x3 <= x2;
    x4 <= x3;

    y1 <= y;
    y2 <= y1;
    y3 <= y2;
    y4 <= y3;
    y <= mul_b0_x0 + mul_b1_x1 + mul_b2_x2 + mul_b3_x3 + mul_b4_x4 - mul_a1_y1 - mul_a2_y2 - mul_a3_y3 - mul_a4_y4;
    oAud_L <= y[24:9];
    if (y[26]) begin
      mag_y <= (~y)-27'd1;
    end
    else begin
      mag_y <= y;
    end
    power <= lpf_y[23:13];
  end
  else begin
    oAud_R <= iAud_R;
    oAud_L <= oAud_R;
    power  <= 11'd0;
  end
end

endmodule
