//
//thing
`timescale 10ps/1ps

module top;

// Clocking

localparam MAXLEN = 2000;
reg reset = 1'b1;
reg clk = 1;
reg audclk = 1;
reg enable = 0;
reg signed [15:0] iAud_L;
wire [15:0] oAud_10_30;
wire [15:0] oAud_30_90;
wire [15:0] oAud_90_270;
wire [15:0] oAud_270_810;
wire [15:0] oAud_810_2430;
wire [15:0] oAud_2430_7290;
wire [15:0] oAud_7290_21870;

wire [10:0] pow_10_30;
wire [10:0] pow_30_90;
wire [10:0] pow_90_270;
wire [10:0] pow_270_810;
wire [10:0] pow_810_2430;
wire [10:0] pow_2430_7290;
wire [10:0] pow_7290_21870;

always #5 clk = ~clk;
always #35 audclk = ~audclk;

integer n = 0;
  wire signed [15:0] aud [0:MAXLEN-1];
  testVect tv(
      .aud(aud)
  );
  autoGen_BPF #(0) bpf10_30(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_10_30),
      .power(pow_10_30)
  );

  autoGen_BPF #(1) bpf30_90(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_30_90),
      .power(pow_30_90)
  );

  autoGen_BPF #(2) bpf_90_270(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_90_270),
      .power(pow_90_270)
  );

  autoGen_BPF #(3) bpf270_810(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_270_810),
      .power(pow_270_810)
  );

  autoGen_BPF #(4) bpf810_2430(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_810_2430),
      .power(pow_810_2430)
  );

  autoGen_BPF #(5) bpf2430_7290(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_2430_7290),
      .power(pow_2430_7290)
  );
  autoGen_BPF #(6) bpf7290_21870(
      .clk(clk),
      .aud_clk(audclk),
      .reset(reset),
      .enable(enable),
      .iAud_L(iAud_L),

      .oAud_L(oAud_7290_21870),
      .power(pow_7290_21870)
  );

  initial begin

      // Dump waveforms
      $dumpfile("filterTest-sim.vcd");
      $dumpvars;
      #110;
      reset = 1'b0;
      iAud_L[15:0] <= aud[0];
      #100;
      enable = 1'b1;
      repeat(2000) begin
          #10;
          if (n%7 == 0) begin
              iAud_L[15:0] <= aud[n/7];
              $display("%d",aud[n/7]);
          end
          n = n +1;
      end
      $finish;
  end

  endmodule

