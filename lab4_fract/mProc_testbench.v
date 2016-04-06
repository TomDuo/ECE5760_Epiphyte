//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking
  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;

  reg oDataVal = 1;
  reg [35:0] oDataXSignal = 36'b000011010111000010100011110101110000;
  reg [35:0] oDataYSignal = 36'b000000000111101011100001010001111010;

  mandlebrotProcessor #(500) m0 (
    .clk(clk),
    .reset(reset),
  // inputs from queue
    .iDataVal(oDataVal),
    .iCoordX(oDataXSignal),
    .iCoordY(oDataYSignal),
    .iVGAX(),
    .iVGAY(),

  // signals sent to queue
    .oProcReady(m0ProcReady),

  // input from arbitor
    .valueStored(1'b0), 

  // signals sent to VGA buffer
    .oColor(),
    .oVGACoord(),
    .oVGAVal()
  );

    initial begin

    // Dump waveforms
    $dumpfile("mProc-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;

    repeat(6000) begin
    #10;
    end
    $finish;
end

endmodule

