//========================================================================
// RandomNumberGenerator Testing, adapted from Tutorial 4: regincr-iverilog-sim.v 
//========================================================================

`include "../lab4_net/RandomNumberGenerator.v"


 
module top;

  // Clocking

  logic clk = 1;
  always #5 clk = ~clk;

  // Instaniate the design under test

  logic       reset = 1;
  logic [7:0] out;
Random_Number_Generator #(8'h11) rng
(
    .clk(clk),
    .reset(reset),
    .out(out)
);
   initial begin

    // Dump waveforms

    $dumpfile("RNG-iverilog-sim.vcd");
    $dumpvars;

    // Reset

    #11;
    reset = 1'b0;

    repeat(100000) begin 
    //$display("out: %x",out);
    $display("%d",out);
    #10;
    end
       // Test cases
    
    //$display( "*** RNG DONE ***" );
    $finish;
  end

endmodule

