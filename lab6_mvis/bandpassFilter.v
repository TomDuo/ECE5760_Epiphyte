module bandpassFilter #(
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
  output reg [7:0]  power
);

// internal wires and registers
reg  signed [18:0] a1, a2, b0, b1, b2;
wire signed [18:0] fixedAud_L, fixedAud_R;
wire signed [18:0] a1_v_n1L, a1_v_n1R, a2_v_n2L, a2_v_n2R;
wire signed [18:0] b0_v_nL, b0_v_nR, b1_v_n1L, b1_v_n1R, b2_v_n2L, b2_v_n2R;
reg  signed [18:0] v_nL, v_n1L, v_n2L, v_nR, v_n1R, v_n2R;

assign fixedAud_L = {iAud_L[15],iAud_L[15],iAud_L[15:0]};
assign fixedAud_R = {iAud_R[15],iAud_R[15],iAud_R[15:0]};

// assign tap values
always @(posedge clk) begin
  case(filterID)
  0: begin // 0 -> [10Hz 100Hz]
    a1 <= 18'b10_0000_0011_0001_0011;
    a2 <= 18'b00_1111_1101_0000_0001;
    b0 <= 18'b00_0000_0001_1000_0010;
    b1 <= 18'b0;
    b2 <= 18'b11_1111_1110_0111_1110;
  end
  1: begin // 1 -> [100Hz 500Hz]
    a1 <= 18'b10_0000_1101_0100_1010;
    a2 <= 18'b00_1111_0010_1111_0001;
    b0 <= 18'b00_0000_0110_1000_0111;
    b1 <= 18'b0;
    b2 <= 18'b11_1111_1001_0111_1001;
  end
  2: begin // 2 -> [500Hz 1000Hz]
    a1 <= 18'b10_0001_0010_0101_1011;
    a2 <= 18'b00_1110_1111_1100_0101;
    b0 <= 18'b00_0000_1000_0001_1101;
    b1 <= 18'b0;
    b2 <= 18'b11_1111_0111_1110_0011;
  end
  3: begin // 3 -> [1000Hz 5000Hz]
    a1 <= 18'b10_0111_1101_1100_0110;
    a2 <= 18'b00_1001_0011_1101_0000;
    b0 <= 18'b00_0011_0110_0001_0111;
    b1 <= 18'b0;
    b2 <= 18'b11_1100_1001_1110_1001;
  end
  4: begin // 4 -> [5000Hz 10000Hz]
    a1 <= 18'b11_0001_1111_1011_1111;
    a2 <= 18'b00_0111_1110_0011_1011;
    b0 <= 18'b00_0100_0000_1101_1110;
    b1 <= 18'b0;
    b2 <= 18'b11_1011_1111_0010_0010;
  end
  5: begin // 5 -> [10000Hz 20000Hz]
    a1 <= 18'b00_1000_1011_1100_0000;
    a2 <= 18'b00_0010_0001_1011_0111;
    b0 <= 18'b00_0110_1111_0010_0111;
    b1 <= 18'b0;
    b2 <= 18'b11_1001_0000_1101_1001;
  end
  default: begin  // 0 -> [10Hz 100Hz]
    a1 <= 18'b10_0000_0011_0001_0011;
    a2 <= 18'b00_1111_1101_0000_0001;
    b0 <= 18'b00_0000_0001_1000_0010;
    b1 <= 18'b0;
    b2 <= 18'b11_1111_1110_0111_1110;
  end
  endcase
end


// Multiplier banks
fixed_comb_mult5760 a1L (v_n1L,a1,a1_v_n1L);
fixed_comb_mult5760 a1R (v_n1R,a1,a1_v_n1R);

fixed_comb_mult5760 a2L (v_n2L,a2,a2_v_n2L);
fixed_comb_mult5760 a2R (v_n2R,a2,a2_v_n2R);

fixed_comb_mult5760 b0L (v_nL,b0,b0_v_nL);
fixed_comb_mult5760 b0R (v_nR,b0,b0_v_nR);

fixed_comb_mult5760 b1L (v_n1L,b1,b1_v_n1L);
fixed_comb_mult5760 b1R (v_n1R,b1,b1_v_n1R);

fixed_comb_mult5760 b2L (v_n2L,b2,b2_v_n2L);
fixed_comb_mult5760 b2R (v_n2R,b2,b2_v_n2R);

always @ (posedge clk) begin
  if (reset) begin
    oAud_R <= 16'd0;
    oAud_L <= 16'd0;
    power  <= 2'd0;
  end
  else if (enable) begin
    // filter left channel
    v_n2L  <= v_n1L;
    v_n1L  <= v_nL;
    v_nL   <= iAud_L - a1_v_n1L - a2_v_n2L;
    oAud_L <= b0_v_nL + b1_v_n1L + b2_v_n2L;

    // filter right channel
    v_n2R  <= v_n1R;
    v_n1R  <= v_nR;
    v_nR   <= iAud_R - a1_v_n1R - a2_v_n2R;
    oAud_R <= b0_v_nR + b1_v_n1R + b2_v_n2R;

    // compute the power in the band
	 power <= (oAud_L>>8);
  end
  else begin
    oAud_R <= iAud_R;
    oAud_L <= oAud_R;
    power  <= 2'd0;
  end
end

endmodule