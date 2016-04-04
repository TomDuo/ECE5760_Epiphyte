//=============================================================================
// ECE 5760 Lab 4
// Coord Generation module
//
// Connor Archard March 2016
//
//=============================================================================
module coordGenerator (
  // inputs from NIOS
  input [4:0] zoomLevel,
  input [35:0] upperLeftX,
  input [35:0] upperRightY,

  // inputs from Load Dist
  input iLoadDistRdy,

  // outputs to Load Dist
  output reg oLoadDistRdy,
  output reg [9:0] oVGAX,
  output reg [8:0] oVGAY,
  output reg [35:0] oCoordX,
  output reg [35:0] oCoordY
);

  reg [9:0] xCounter;
  reg [8:0] yCounter;
  reg [1:0] state;
  reg [1:0] nextState;

  localparam s_init = 2'd0;


  always @(posedge clk) begin
    state = nextState;
    if (reset) nextState <= s_init;

  case(state)
  s_init: begin
    

  end

  s_waiting: begin
    
  end

  s_getNextValue: begin
    
    
  end
  endcase
  end    

endmodule