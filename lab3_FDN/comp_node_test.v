//========================================================================
// dynamic_system_test.v Testing, adapted from Tutorial 4: regincr-iverilog-sim.v 
//========================================================================

`timescale 10ps/1ps

 
module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [17:0] u;
  compNode #(32,32) cn
  (
      .clk(clk),
      .reset(reset),

      .uNorth(18'd0),
      .uSouth(18'd0),
      .uEast (18'd0),
      .uWest (18'd0),

      .rho   (18'h0_8000),
      .eta   (18'h0_0100),
      .tensionSel(3'd0),

      .u(u)
  );
    initial begin

    // Dump waveforms
    $dumpfile("comp-Node-iverilog-sim.vcd");
    $dumpvars;

    // Reset

    #11;
    reset = 1'b0;
    repeat(10000) begin 
    #10;
    $finish;
    end
end

endmodule

