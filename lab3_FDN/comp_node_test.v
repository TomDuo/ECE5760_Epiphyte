//========================================================================
// dynamic_system_test.v Testing, adapted from Tutorial 4: regincr-iverilog-sim.v 
//========================================================================

`include "compNode.v"
`timescale 10ps/1ps

 
module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;

    initial begin

    // Dump waveforms
    $dumpfile("comp-Node-iverilog-sim.vcd");
    $dumpvars;

    // Reset

    #11;
    reset = 1'b0;
    repeat(1000000) begin 
    #10;
    $finish;
    end
end

endmodule

