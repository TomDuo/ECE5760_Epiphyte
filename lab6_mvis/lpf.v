module lpf (
  input clk,
  input aud_clk,
  input reset,

  input  signed [26:0] in,
  output signed [26:0] out
);


reg signed [26:0] X;
reg signed [26:0] prevY;
reg signed [26:0] prevX;


reg [2:0]  state;
reg [2:0]  nextstate;
reg        prev_aud_clk;

localparam s_init = 3'd0;
localparam s_b1   = 3'd1;
localparam s_b2   = 3'd2;
localparam s_a2   = 3'd3;
localparam s_waiting = 3'd4;

localparam b1 = 27'b000_0000_0100_0000_1110_1011_1110;
localparam b2 = 27'b000_0000_0100_0000_1110_1011_1110;
localparam a2 = 27'b111_1000_1000_0001_1101_0111_1110;

reg  signed [26:0] mulInA, mulInB, s_b1_out, s_b2_out;
wire signed [26:0] mulOut;
fixed_comb_mult5760 mul0 (mulInA,mulInB,mulOut);

always @ (posedge clk) begin
  state <= nextstate;
  prev_aud_clk <= aud_clk;
  if (reset) begin
    nextstate <= s_init;
    out <= 27'd0;
  end
  case(state)
  s_init: begin
    prevX <= X;
    prevY <= out;
    X     <= in;
    nextstate <= s_b1;
  end

  s_b1: begin
    mulInA <= b1;
    mulInB <= X;
    nextstate <= s_b2;
  end

  s_b2: begin
    mulInA <= b2;
    mulInB <= prevX;
    s_b1_out <= mulOut;
    nextstate <= s_a2;
  end

  s_a2: begin
    mulInA <= a2;
    mulInB <= prevY;
    s_b2_out <= mulOut;
    nextstate <= s_waiting;
  end

  s_waiting: begin
    out <= s_b1_out + s_b2_out - mulOut;
    if(prev_aud_clk ~= aud_clk) begin
      nextstate <= s_init;
    end
  end
end

endmodule
