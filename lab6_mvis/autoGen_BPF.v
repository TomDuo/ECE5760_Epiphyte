module autoGen_BPF #(
  parameter filterID = 0 // lower num = lower BP
                         // 0 -> [10Hz 100Hz]
                         // 1 -> [100Hz 500Hz]
                         // 2 -> [500Hz 1000Hz]
                         // 3 -> [1000Hz 5000Hz]
                         // 4 -> [5000Hz 10000Hz]
                         // 5 -> [10000Hz 20000Hz]
)(
  input clk,
  input reset,
  input enable,

  input [15:0] iAud_L,
  input [15:0] iAud_R,

  output reg [15:0] oAud_L,
  output reg [15:0] oAud_R,
  output reg [10:0]  power
);

reg  signed [19:0] y;
reg  signed [19:0] x;
reg  signed [19:0] z1;
reg  signed [19:0] a1;
reg  signed [19:0] b1;
wire signed [19:0] mul_a1_y;
wire signed [19:0] mul_b1_x;
fixed_comb_mult5760 mula1 (y,a1,mul_a1_y);
fixed_comb_mult5760 mulb1 (x,b1,mul_b1_x);

reg  signed [19:0] z2;
reg  signed [19:0] a2;
reg  signed [19:0] b2;
wire signed [19:0] mul_a2_y;
wire signed [19:0] mul_b2_x;
fixed_comb_mult5760 mula2 (y,a2,mul_a2_y);
fixed_comb_mult5760 mulb2 (x,b2,mul_b2_x);

reg  signed [19:0] z3;
reg  signed [19:0] a3;
reg  signed [19:0] b3;
wire signed [19:0] mul_a3_y;
wire signed [19:0] mul_b3_x;
fixed_comb_mult5760 mula3 (y,a3,mul_a3_y);
fixed_comb_mult5760 mulb3 (x,b3,mul_b3_x);

reg  signed [19:0] z4;
reg  signed [19:0] a4;
reg  signed [19:0] b4;
wire signed [19:0] mul_a4_y;
wire signed [19:0] mul_b4_x;
fixed_comb_mult5760 mula4 (y,a4,mul_a4_y);
fixed_comb_mult5760 mulb4 (x,b4,mul_b4_x);

reg  signed [19:0] z5;
reg  signed [19:0] a5;
reg  signed [19:0] b5;
wire signed [19:0] mul_a5_y;
wire signed [19:0] mul_b5_x;
fixed_comb_mult5760 mula5 (y,a5,mul_a5_y);
fixed_comb_mult5760 mulb5 (x,b5,mul_b5_x);

reg  signed [19:0] a6;
reg  signed [19:0] b6;
wire signed [19:0] mul_a6_y;
wire signed [19:0] mul_b6_x;
fixed_comb_mult5760 mula6 (y,a6,mul_a6_y);
fixed_comb_mult5760 mulb6 (x,b6,mul_b6_x);

case(filterID)
0: begin
b0 <= 20'b0000_0000_0000_0000_0010;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_1111_1111_1111_1100;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0000_0000_0000_0010;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b0000_0000_1000_1000_1010;
a2 <= 20'b1111_1110_0110_0110_1101;
a3 <= 20'b0000_0001_1001_1000_1000;
a4 <= 20'b0011_1111_0111_1000_0001;
end

1: begin
b0 <= 20'b0000_0000_0000_0010_1100;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_1111_1111_1010_1000;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0000_0000_0010_1100;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b0000_0010_0110_0101_1000;
a2 <= 20'b1111_1000_1110_0001_1010;
a3 <= 20'b0000_0111_0000_1100_0111;
a4 <= 20'b0011_1101_1010_1100_0111;
end

2: begin
b0 <= 20'b0000_0000_0000_0100_0100;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_1111_1111_0111_0111;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0000_0000_0100_0100;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b0000_0011_0011_1011_1000;
a2 <= 20'b1111_0110_1010_0101_1011;
a3 <= 20'b0000_1001_0000_0011_1110;
a4 <= 20'b0011_1101_0001_1011_0000;
end

3: begin
b0 <= 20'b0000_0000_1110_1011_1111;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_1110_0010_1000_0010;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0000_1110_1011_1111;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b0001_1001_1111_1101_0001;
a2 <= 20'b0011_1000_1010_1100_0000;
a3 <= 20'b0100_0001_0010_1010_1000;
a4 <= 20'b0010_1100_0011_0010_1100;
end

4: begin
b0 <= 20'b0000_0001_0110_0010_0011;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_1101_0011_1011_1001;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0001_0110_0010_0011;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b0011_0101_0100_1111_0000;
a2 <= 20'b0000_0100_1111_1111_0101;
a3 <= 20'b0101_1111_1010_1111_1110;
a4 <= 20'b0010_1000_0100_1011_0110;
end

5: begin
b0 <= 20'b0000_0100_1001_1111_0110;
b1 <= 20'b0000_0000_0000_0000_0000;
b2 <= 20'b1111_0110_1100_0001_0011;
b3 <= 20'b0000_0000_0000_0000_0000;
b4 <= 20'b0000_0100_1001_1111_0110;
a0 <= 20'b0100_0000_0000_0000_0000;
a1 <= 20'b1000_1011_0100_0000_0100;
a2 <= 20'b0111_1110_0011_1010_1010;
a3 <= 20'b1011_1000_0111_0010_1110;
a4 <= 20'b0001_1001_0111_1011_0101;
end

endcase
always @ (posedge clk) begin
  if (reset) begin
      oAud_R <= 16'd0;
      oAud_L <= 16'd0;
      power  <= 11'd0;
  end
  else if (enable) begin
    // I think these top two need to be blocking
    x  = {{4{iAud_L[15]}},iAud_L}; // iAud_L is [1,1]. Map to 4_16 by extending first bit
    y  = mul_b1_x+z1;

    // the rest are nonblocking
    z1 <= mul_b2_x+z2-mul_a2_y;
    z2 <= mul_b3_x+z3-mul_a3_y;
    z3 <= mul_b4_x+z4-mul_a4_y;
    z4 <= mul_b5_x+z5-mul_a5_y;
    z4 <= mul_b5_x-mul_a5_y;
    if (y[19]) begin
      power <= ~(y[19:9]);
    end
    else begin
      power <= (y[19:9]);
   end
  end
  else begin
    oAud_R <= iAud_R;
    oAud_L <= oAud_R;
    power  <= 11'd0;
  end
end

endmodule