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
reg signed [26:0] sosMat [0:2][0:5];

integer n = 0;
  wire signed [15:0] aud [0:MAXLEN-1];
  testVect tv(
      .aud(aud)
  );
  wire [26:0] in;
  assign in = {{3{iAud_L[15]}},iAud_L,8'd0};
  wire [26:0] out1;
  SOS bq1(
      .clk(clk),
      .aud_clk(audclk),
      .enable(enable),
      .reset(reset),
      .b0(sosMat[0][0]),
      .b1(sosMat[0][1]),
      .b2(sosMat[0][2]),
      .a0(sosMat[0][3]),
      .a1(sosMat[0][4]),
      .a2(sosMat[0][5]),
      .in(in),
      .out(out1)
     );
      wire [26:0] out2;
  SOS bq2(
      .clk(clk),
      .aud_clk(audclk),
      .enable(enable),
      .reset(reset),
      .b0(sosMat[1][0]),
      .b1(sosMat[1][1]),
      .b2(sosMat[1][2]),
      .a0(sosMat[1][3]),
      .a1(sosMat[1][4]),
      .a2(sosMat[1][5]),
      .in(in),
      .out(out2)
     );
     wire [26:0] mout;
fixed_comb_mult5760 fc(27'h800000,27'h1000000,mout);
    initial begin
sosMat[0][0] = 27'h559A;
sosMat[0][1] = 27'hAB35;
sosMat[0][2] = 27'h559A;
sosMat[0][3] = 27'h800000;
sosMat[0][4] = 27'h70F2DF7;
sosMat[0][5] = 27'h733A23;
sosMat[1][0] = 27'h800000;
sosMat[1][1] = 27'h7000000;
sosMat[1][2] = 27'h800000;
sosMat[1][3] = 27'h800000;
sosMat[1][4] = 27'h7060F49;
sosMat[1][5] = 27'h7A63B8;
      // Dump waveforms
      $dumpfile("sosTest-sim.vcd");
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

