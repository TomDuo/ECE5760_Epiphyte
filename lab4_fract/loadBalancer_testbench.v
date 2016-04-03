//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [3:0]  iProcReady;
  wire [3:0]  oDataVal;
  wire [35:0] oDataXSignal;
  wire [35:0] oDataYSignal;
  wire [9:0]  oVGAX;
  wire [8:0]  oVGAY;
  wire        oCoordRdy;
  reg  [35:0] iCoordX = 0;
  reg  [35:0] iCoordY = 0;
  reg         iCoordVal = 0;
  reg  [9:0]  iVGAX = 0;
  reg  [8:0]  iVGAY = 0;

  wire m0ProcReady;
  wire m1ProcReady;
  wire m2ProcReady;
  wire m3ProcReady;

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;

  loadBalancer #(4) lb1 (
    .clk(clk),
    .reset(reset),

  // input ready signals from processors 
    .iProcReady(iProcReady),
  
  // input from coordinate generation
    .iCoordVal(iCoordVal),
    .iCoordX(iCoordX),
    .iCoordY(iCoordY),
    .iVGAX(iVGAX),
    .iVGAY(iVGAY),

  // output val, ready, signal groups to procs
    .oDataVal(oDataVal),
    .oDataXSignal(oDataXSignal),
    .oDataYSignal(oDataYSignal),
    .oVGAX(oVGAX),
    .oVGAY(oVGAY),

  // output ready, val signal groups to coordinate generator
    .oCoordRdy(oCoordRdy)
  );

  mandlebrotProcessor #(16) m0 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[0]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignala),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m0ProcReady),

  // signals sent to VGA buffer
    .oColor(),
    .oVGACoord(),
    .oVGAVal()
    );

  mandlebrotProcessor #(16) m1 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[1]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignala),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m1ProcReady),

  // signals sent to VGA buffer
    .oColor(),
    .oVGACoord(),
    .oVGAVal()
    );

  mandlebrotProcessor #(16) m2 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[2]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignala),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m2ProcReady),

  // signals sent to VGA buffer
    .oColor(),
    .oVGACoord(),
    .oVGAVal()
    );

  mandlebrotProcessor #(16) m3 (
      .clk(clk),
      .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal[3]),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignala),
    .iVGAX(oVGAX),
    .iVGAY(oVGAY),

  // signals sent to queue
    .oProcReady(m3ProcReady),

  // signals sent to VGA buffer
    .oColor(),
    .oVGACoord(),
    .oVGAVal()
    );

    initial begin

    // Dump waveforms
    $dumpfile("loadBalancer-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    #10;
    #10;
    #10;
    #10;

    repeat(16000) begin
    if(oCoordRdy) begin
      iCoordVal = 1;
      iCoordX   = iCoordX + 1;
      iCoordY   = iCoordY + 1;
      iVGAX     = iVGAX   + 1;
      iVGAY     = iVGAY   + 1;
    end

    #10;
    end
    $finish;
end

endmodule

