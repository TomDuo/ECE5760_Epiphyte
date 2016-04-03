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
  
  // input from coordinate generation
  input        iCoordVal,
  input [35:0] iCoordX,
  input [35:0] iCoordY,
  input [9:0]  iVGAX,
  input [8:0]  iVGAY,

  // output val, ready, signal groups to procs
  output reg [numProcs-1:0] oDataVal,
  output reg [35:0]         oDataXSignal,
  output reg [35:0]         oDataYSignal,
  output reg [9:0]          oVGAX,
  output reg [8:0]          oVGAY,

  // output ready, val signal groups to coordinate generator
  output reg oCoordRdy
);

reg                 full;
wire [numProcs-1:0] nextProc;

msbOneHot procSel(.in(iProcReady),.out(nextProc));

always @(posedge clk) begin
  // Handle resets by assering no valid data
  if (reset) begin
    oCoordRdy <= 1;
    oDataVal  <= 0;
    full      <= 0;
  end
  // If queue isn't full and coordinate is ready, bring it in
  else if (!(full) && iCoordVal)begin
    oCoordRdy    <= 0;
    oDataXSignal <= iCoordX;
    oDataYSignal <= iCoordY;
    oVGAX        <= iVGAX;
    oVGAY        <= iVGAY;
    full         <= 1;
  end
  // If queue isn't full and coordinate is not ready, wait
  else if (!(full) && !(iCoordVal)) begin
    oDataVal  <= 0;
    oCoordRdy <= 1;
  end
  // If queue is full and a processor wants data, set output valid and reset q
  else if (iProcReady > 0) begin
    oDataVal     <= nextProc;
    full         <= 0;
  end
  // wait for something to happen
  else begin
    oDataVal  <= 0;
    oCoordRdy <= 1;
  end
end

endmodule
