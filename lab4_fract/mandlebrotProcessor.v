module mandlebrotProcessor #(
  parameter maxIterations = 1000
  )(
  // clocks and resets
  input clk,
  input reset,

  // inputs from queue
  input iDataVal,
  input [18:0] iCoord,

  // signals sent to queue
  output reg        oProcReady,

  // signals sent to VGA buffer
  output reg [3:0]  oColor,
  output reg [18:0] oCoordSig,
  output reg        oCoordVal 
);

localparam s_init        = 4'd0;
localparam s_waiting     = 4'd1;
localparam s_processing  = 4'd2;

reg [3:0] state;
reg [3:0] nextState;

reg [9:0] xCoord;
reg [8:0] yCoord;

reg [11:0] calcCount;

always @(posedge clk) begin
  state = nextState;
  if (reset) nextState <= s_init;

  case(state)
  s_init: begin
    nextState <= s_waiting;
  end

  s_waiting: begin
    oProcReady  <= 1;
    if (iDataVal) begin
      nextState <= s_processing;
      xCoord    <= iCoord[18:9];
      yCoord    <= iCoord[8:0];
      calcCount <= 0;
    end
    else nextState <= s_waiting;
  end

  s_processing: begin
    oProcReady <= 0;
    calcCount <= calcCount + 1;
    if (calcCount > maxIterations) begin
      oColor    <= 4'd0;
      oCoordSig <= {xCoord,yCoord};
      oCoordVal <= 1;
      nextState <= s_waiting;
    end
  end

  default: begin
      nextState = s_waiting;
  end
  endcase
end

endmodule
