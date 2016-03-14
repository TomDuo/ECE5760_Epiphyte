module compNode
#(
  parameter xID = 0,
  parameter yID = 0
)(

  // Clocks and Resets
    input clk,
    input reset,

  // Neighbors NOTE: inputs might be boundaries depending on xID and yID
    input signed [17:0] uInit,
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
  reg [2:0] state;
  reg [2:0] nextState;

  // State machine parameters
  localparam sInit = 3'd0;  
  localparam mul1  = 3'd1;
  localparam mul2  = 3'd2;
  localparam mul3  = 3'd3;
  localparam sUpdate = 3'd4;

  // Registers to hold intermediate values
  reg  signed [17:0] uprev;

  // Multiplier and Multiplexor Datapath
  wire signed [17:0] multOut;
  wire [31:0]  multOutfloat;
  fixed_to_float ff_multOut(multOut,multOutfloat);
  reg signed [17:0] multInA;
  reg signed [17:0] multInB;
  reg signed [17:0] state2_out;
  fixed_comb_mult5760 multy_the_multiplier_who_only_loves(
      .a(multInA),
      .b(multInB),
      .out(multOut)
  );

  // State Machine Actions
  always @(posedge clk) begin
    state = nextState;
    if (reset) begin
      nextState <= sInit;
    end
    else begin
        case(state)
        sInit:
        begin
          // consider adding code here to only change the value based on the x and y ID
          u     <= 18'h0_2000; // allow for the drum to be struck by setting u to -1
          uprev <= 18'h0_0000;
          state2_out <= 18'h0_0000;
          nextState <= mul1;
          multInA <= 18'h1_0000;
          multInB <= 18'h1_0000;
        end

        mul1:
        begin
         multInA <= rho;
         multInB <= (uNorth -u + uSouth -u + uEast - u + uWest - u);
         nextState <= mul2;
        end

        mul2:
        begin
          multInA <= multOut; 
          multInB <= (18'h1_0000-eta);
          nextState <= mul3;
        end

        mul3:
        begin
          state2_out <= multOut;
          multInA <= (18'h1_0000-eta);
          multInB <= uprev;
          nextState <= sUpdate;
        end
        sUpdate:
        begin
          u <= state2_out + (u<<1) -  multOut;
          uprev <= u;
          nextState <= mul1;
        end
        default:
        begin
            nextState <= sInit;
        end
        endcase
     end
  end

  assign validOut = (state == mul2);
endmodule

