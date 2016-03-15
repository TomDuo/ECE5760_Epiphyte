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
  reg [17:0] myEta = ((18'h1_0000)>>12);
  wire [17:0] out;
  wire [63:0] out_float;
  wire allValid;
  real out_real;
  integer f;
  integer cyc_count = 0;
  compMesh #(16,16) cM
  (
    .clk(clk),
    .reset(reset),

    .rho(18'h0_2000),
    .eta(myEta),
    .tensionSel(3'd0),

    .out(out),
    .allValid(allValid)

  );
  always @ (posedge allValid) begin
    $fwrite(f,"%f\n",out_real/2.0);
  end
  fixed_to_float ff_out(out,out_float);
  initial begin

    // Dump waveforms
    f = $fopen("out.csv","w");
    $dumpfile("comp-Mesh-iverilog-sim.vcd");
    $dumpvars;

    // Reset

    #11;
    reset = 1'b0;
    repeat(32000) begin 
    #10;
    cyc_count = cyc_count + 1;
    out_real = $bitstoreal(out_float);
    end
    reset = 1'b1;
    myEta <= ((18'h1_0000)>>11);
    #11;
    reset = 1'b0;
    repeat(32000) begin 
    #10;
    cyc_count = cyc_count + 1;
    out_real = $bitstoreal(out_float);
    end
    $fclose(f);
    $finish;
end

endmodule

