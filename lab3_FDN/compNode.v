module compNode
#(
  parameter xID = 0,
  parameter yID = 0
)(

  // Clocks and Resets
    input clk,
    input reset,

  // Neighbors NOTE: inputs might be boundaries depending on xID and yID
    input signed [17:0] uNorth,
    input signed [17:0] uSouth,
    input signed [17:0] uEast,
    input signed [17:0] uWest,

  // Input Parameters
    input signed [17:0] rho,
    input signed [17:0] eta, 
    input [2:0]         tensionSel,

  // Output Values
    output reg signed [17:0] u,
    output                   validOut
  );

  // Registers to track current state
  reg [1:0] state;
  reg [1:0] nextState;

  // State machine parameters
  localparam sInit = 2'd0;  
  localparam mul0  = 2'd1;
  localparam mul1  = 2'd2;
  localparam mul2  = 2'd3;

  // Registers to hold intermediate values
  wire signed [17:0] oneMinusEta;
  wire signed [17:0] sumNeighbors;
  reg  signed [17:0] uPrev;
  reg  signed [17:0] rhoMultSum;
  reg  signed [17:0] rhoSumMultOneMinusEta;

  assign oneMinusEta  = 1-eta;
  assign sumNeighbors = uNorth + uSouth + uEast + uWest - (u << 2); 

  // Multiplier and Multiplexor Datapath
  wire signed [17:0] multOut;
  wire signed [17:0] multInA;
  wire signed [17:0] multInB;
  reg         [1:0]  muxASel;
  reg         [1:0]  muxBSel;

  fixed_mult5760 multy_the_multiplier_who_only_loves(
      .a(multInA),
      .b(multInB),
      .out(multOut)
  );


  vc_Mux3 #(18) muxA (
    .in0(rho),
    .in1(oneMinusEta),
    .in2(oneMinusEta),
    .sel(muxASel),
    .out(multInA)
  );

  vc_Mux3 #(18) muxB (
    .in0(sumNeighbors),
    .in1(rhoMultSum),
    .in2(uPrev),
    .sel(muxBSel),
    .out(multInB)
  );


  // State Machine Transitions
  always @(posedge clk) begin
    if (reset) nextState <= sInit;
    else begin
      case(state)
        sInit: nextState <= mul0;
        mul0:  nextState <= mul1;
        mul1:  nextState <= mul2;
        mul2:  nextState <= mul0;
      endcase
    end
  end

  // State Machine Actions
  always @(posedge clk) begin
    state <= nextState;
    case(state)
    sInit:
    begin
      // consider adding code here to only change the value based on the x and y ID
      u <= 18'h3_8100; // allow for the drum to be struck by setting u to -1
    end

    mul0:
    begin
      muxASel <= 2'b00;
      muxBSel <= 2'b00;
      rhoMultSum <= multOut;
    end

    mul1:
    begin
      muxASel <= 2'b01;
      muxBSel <= 2'b01;
      rhoSumMultOneMinusEta <= multOut;
    end

    mul2:
    begin
      muxASel <= 2'b10;
      muxBSel <= 2'b10;
      uPrev   <= u;
      u       <= rhoSumMultOneMinusEta + (u<<1) - multOut; // add tension effect here
    end
    endcase
  end

  assign validOut = (state == mul2);
endmodule
