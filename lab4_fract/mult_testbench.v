//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  reg  [35:0] thing1 = 36'h1_80000000;
  reg  [35:0] thing2 = ~(36'h1_40000000) + 36'b1;
  wire [35:0] out;

  long_mult5760 thedumb(thing1,thing2,out);

    initial begin

    // Dump waveforms
    $dumpfile("multTest-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    #10;
    $display("0x%h",out);  
    $display("NOT: 0x%h",~out + 36'b1);  
    $finish;
end

endmodule

