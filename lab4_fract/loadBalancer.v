//=============================================================================
// ECE 5760 Lab 4
// Load distribution module
//
// Connor Archard March 2016
//
//=============================================================================

module loadBalancer#(
  parameter screenWidth  = 640,
  parameter screenHeight = 480,
  parameter numProcs     = 8
  )(
  input  clk,
  input  reset,

  // input ready signals from processors 
  input  [numProcs-1:0] iProcReady,
  
  // output val, ready, signal groups
  output reg [numProcs-1:0] oDataVal,
  output reg [18:0]         oDataSignal
);

reg  [18:0]      queue [31:0];
reg  [4:0]       rdPtr;
reg  [4:0]       wtPtr;
reg  [4:0]       queueFull;
reg  [18:0]      nextCoord;
wire [18:0]      nextProc;

msbOneHot procSel(.in(iProcReady),.out(nextProc));

always @(posedge clk) begin
  // Handle resets by assering no valid data
  if (reset) begin
    rdPtr     <= 0;
    wtPtr     <= 0;
    oDataVal  <= 0;
    nextCoord <= 0;
    queueFull <= 0;
  end
  // If queue isn't full, bring in another coordinate
  else if (!(queueFull== 5'd31))begin
    queue[wtPtr] <= nextCoord; 
    wtPtr        <= wtPtr + 1;
    nextCoord    <= nextCoord + 1;
    queueFull    <= queueFull + 1; 
  end
  // queue is full and a processor wants data
  else if (iProcReady > 0) begin
    oDataSignal  <= queue[rdPtr];
    oDataVal     <= nextProc;
    queueFull    <= queueFull -1;
    rdPtr        <= rdPtr + 1;
  end
  else begin
  // wait for something to happen
  end
end

endmodule
