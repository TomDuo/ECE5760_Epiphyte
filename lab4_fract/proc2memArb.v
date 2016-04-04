//=============================================================================
// ECE 5760 Lab 4
// Processor-to-memory Arbitration Module
//
// Connor Archard, Noah Levy March 2016
//
//=============================================================================

module proc2memArb #(
  parameter numProcs = 8
  )(
  input clk,
  input reset,

  // VGA data inputs from processors
  input [18:0] iProcVGA   [31:0],
  input [7:0]  iProcColor [31:0], 

  // ready signals from processors
  input [31:0] iProcRdy,

  // output signals to processors
  output reg [31:0] oProcRdy,

  // output signals to VGA buffer
  output reg [18:0] addr,
  output reg [7:0]  data,
  output reg        w_en
  );

wire [31:0] oneHotProcRdy;
wire [4:0]  log2ProcRdy;

msbOneHot msb1 (iProcRdy,oneHotProcRdy);
quickLog2 ql1  (oneHotProcRdy,log2ProcRdy);

always @ (posedge clk) begin
  if (oneHotProcRdy > 0) begin
    oProcRdy <= oneHotProcRdy;
    addr     <= iProcVGA[log2ProcRdy];
    data     <= iProcColor[log2ProcRdy];
    w_en     <= 1;
  end
  else begin
    oProcRdy <= 0;
    w_en     <= 0;
  end
end
endmodule