//========================================================================
// dynamic_system_test.v Testing, adapted from Tutorial 4: regincr-iverilog-sim.v 
//========================================================================

`timescale 10ps/1ps

`define FLOAT2_DDA_FIXED(t) (((int32_t)((t) *(65536.0)))  & 0x03FFFF) 
module top;

  // Clocking

  reg reset = 1'b1;
  reg clk = 1;
  always #5 clk = ~clk;
  wire [17:0] u;
  wire validOut;
  integer u_int;
  real u_real;
  integer cyc_count = 0;
  integer f;
  compNode #(32,32) cn
  (
      .clk(clk),
      .reset(reset),
       
      .uInit(18'h0_2000),
      .uNorth(18'd0),
      .uSouth(18'd0),
      .uEast (18'd0),
      .uWest (18'd0),

      .rho   (18'h0_8000),
      .eta   (18'h0_0200),
      .tensionSel(3'd0),

      .u(u),
      .validOut(validOut)
  );
    always @ (posedge validOut) begin
    $fwrite(f,"%f\n",u_real);
    end

    initial begin

    // Dump waveforms
    $dumpfile("comp-Node-iverilog-sim.vcd");
    $dumpvars;
    f = $fopen("single.csv", "w");
    // Reset

    #11;
    reset = 1'b0;
    repeat(16000) begin 
    u_int = $signed(u);
    u_real = $itor(u_int)/65336.0;
    #10;
    cyc_count = cyc_count + 1;
    end
    $fclose(f);
    $finish;
end

endmodule

