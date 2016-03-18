//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [3:0] iProcReady;
  reg [3:0] proc1count = 0;
  reg [3:0] proc2count = 0;
  reg [3:0] proc3count = 0;
  reg [3:0] proc0count = 0;
  wire [3:0] oDataVal;
  wire [18:0] oDataSignal;

  wire m0ProcReady;
  wire m1ProcReady;
  wire m2ProcReady;
  wire m3ProcReady;

  assign iProcReady[0] = m0ProcReady;
  assign iProcReady[1] = m1ProcReady;
  assign iProcReady[2] = m2ProcReady;
  assign iProcReady[3] = m3ProcReady;

  loadBalancer lb1 (
    .clk(clk),
    .reset(reset),
    .iProcReady(iProcReady),
    .oDataVal(oDataVal),
    .oDataSignal(oDataSignal)
  );

  mandlebrotProcessor #(16) m0 (
      .clk(clk),
      .reset(reset),
      .iDataVal(oDataVal[0]),
      .iCoord(oDataSignal),
      .oProcReady(m0ProcReady),
      .oColor(),
      .oCoordSig(),
      .oCoordVal() 
    );

  mandlebrotProcessor #(16) m1 (
      .clk(clk),
      .reset(reset),
      .iDataVal(oDataVal[1]),
      .iCoord(oDataSignal),
      .oProcReady(m1ProcReady),
      .oColor(),
      .oCoordSig(),
      .oCoordVal() 
    );

  mandlebrotProcessor #(16) m2 (
      .clk(clk),
      .reset(reset),
      .iDataVal(oDataVal[2]),
      .iCoord(oDataSignal),
      .oProcReady(m2ProcReady),
      .oColor(),
      .oCoordSig(),
      .oCoordVal() 
    );

  mandlebrotProcessor #(16) m3 (
      .clk(clk),
      .reset(reset),
      .iDataVal(oDataVal[3]),
      .iCoord(oDataSignal),
      .oProcReady(m3ProcReady),
      .oColor(),
      .oCoordSig(),
      .oCoordVal() 
    );

    initial begin

    // Dump waveforms
    $dumpfile("loadBalancer-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    repeat(16000) begin

    #10;
    end
    $finish;
end

endmodule

