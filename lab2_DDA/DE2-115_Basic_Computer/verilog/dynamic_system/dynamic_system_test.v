//========================================================================
// RandomNumberGenerator Testing, adapted from Tutorial 4: regincr-iverilog-sim.v 
//========================================================================

`include "eulersillator.v"


 
module top;

  // Clocking

  logic clk = 1;
  always #5 clk = ~clk;

  // Instaniate the design under test

  reg  nios_reset = 1;    
  reg  reset = 1;
  wire  w_en;

  reg  [17:0] k1   = 18'h1_0000; //1
  reg  [17:0] kmid = 18'h1_0000; //1
  reg  [17:0] k2   = 18'h1_0000; //1

  //These initial conditions simulate x0_symm from Osc_euler.m
  reg  [17:0] x1_init =  18'h3_8000; //-.5
  reg  [17:0] v1_init =  18'h0_0000; //  0
  
  reg  [17:0] x2_init =  18'h0_8000; // .5
  reg  [17:0] v2_init =  18'h0_0000; //  0
  wire [17:0] x1;
  wire [17:0] x2;
  

eulersillator eulers_oscillator
(
    .CLOCK_50(clk),
    .reset(reset),
    .nios_reset(reset),
    
    .k1(k1),
    .kmid(kmid),
    .k2(k2),
    //.kcubic(kcubic),

    .x1_init(x1_init),
    .x2_init(x2_init),
    .v1_init(v1_init),
    .v2_init(v2_init),

    .x1(x1),
    .x2(x2)

    //.vga_xCoord(vga_xCoord),
    //.w_en(w_en),

);
   initial begin

    // Dump waveforms

    $dumpfile("DDA-iverilog-sim.vcd");
    $dumpvars;

    // Reset

    #11;
    reset = 1'b0;

    repeat(100000) begin 
    #10;
    end
       // Test cases
    $finish;
  end

endmodule

