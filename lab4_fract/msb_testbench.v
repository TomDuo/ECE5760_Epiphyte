//========================================================================
// test bench for load balancer
//========================================================================

`timescale 10ps/1ps

module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  reg  [3:0] in = 0;
  wire [3:0] out;

  msbOneHot m1(.in(in),.out(out));

    initial begin

    // Dump waveforms
    $dumpfile("msbTest-sim.vcd");
    $dumpvars;
    #11;
    reset = 1'b0;
    repeat(16000) begin
    in <= in + 1;
    #10;
    end
    $finish;
end

endmodule

