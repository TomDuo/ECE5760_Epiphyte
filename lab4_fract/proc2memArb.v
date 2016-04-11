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
  input [18:0] iProc0VGA,
  input [18:0] iProc1VGA,
  input [18:0] iProc2VGA,
  input [18:0] iProc3VGA,
  input [18:0] iProc4VGA,
  input [18:0] iProc5VGA,
  input [18:0] iProc6VGA,
  input [18:0] iProc7VGA,
  input [18:0] iProc8VGA,
  input [18:0] iProc9VGA,
  input [18:0] iProc10VGA,
  input [18:0] iProc11VGA,
  input [18:0] iProc12VGA,
  input [18:0] iProc13VGA,
  input [18:0] iProc14VGA,
  input [18:0] iProc15VGA,

  input [7:0]  iProc0Color,
  input [7:0]  iProc1Color,
  input [7:0]  iProc2Color,
  input [7:0]  iProc3Color,
  input [7:0]  iProc4Color,
  input [7:0]  iProc5Color,
  input [7:0]  iProc6Color,
  input [7:0]  iProc7Color,
  input [7:0]  iProc8Color,
  input [7:0]  iProc9Color,
  input [7:0]  iProc10Color,
  input [7:0]  iProc11Color,
  input [7:0]  iProc12Color,
  input [7:0]  iProc13Color,
  input [7:0]  iProc14Color,
  input [7:0]  iProc15Color, 

  // ready signals from processors
  input [15:0] iProcRdy,

  // output signals to processors
  output reg [15:0] oProcRdy,

  // output signals to VGA buffer
  output reg [18:0] addr,
  output reg [3:0]  data,
  output reg        w_en
  );

wire [31:0] oneHotProcRdy;
wire [4:0]  log2ProcRdy;

msbOneHot msb1 ({16'd0,iProcRdy},oneHotProcRdy);
quickLog2 ql1  (oneHotProcRdy,log2ProcRdy);

always @ (posedge clk) begin
  if (oneHotProcRdy > 0) begin
    oProcRdy <= oneHotProcRdy[15:0];
    w_en     <= 1;

    case(log2ProcRdy)
    5'd0: begin
      addr <= iProc0VGA;
      data <= iProc0Color;
    end
    5'd1: begin      
      addr <= iProc1VGA;
      data <= iProc1Color;
    end
    5'd2: begin
      addr <= iProc2VGA;
      data <= iProc2Color;
    end
    5'd3: begin
      addr <= iProc3VGA;
      data <= iProc3Color;
    end
    5'd4: begin
      addr <= iProc4VGA;
      data <= iProc4Color;
    end
    5'd5: begin
      addr <= iProc5VGA;
      data <= iProc5Color;
    end
    5'd6: begin
      addr <= iProc6VGA;
      data <= iProc6Color;
    end
    5'd7: begin
      addr <= iProc7VGA;
      data <= iProc7Color;
    end
    5'd8: begin
      addr <= iProc8VGA;
      data <= iProc8Color;
    end
    5'd9: begin
      addr <= iProc9VGA;
      data <= iProc9Color;
    end
    5'd10: begin
      addr <= iProc10VGA;
      data <= iProc10Color;
    end
    5'd11: begin
      addr <= iProc11VGA;
      data <= iProc11Color;
    end
    5'd12: begin
      addr <= iProc12VGA;
      data <= iProc12Color;
    end
    5'd13: begin
      addr <= iProc13VGA;
      data <= iProc13Color;
    end
    5'd14: begin
      addr <= iProc14VGA;
      data <= iProc14Color;
    end
    5'd15: begin
      addr <= iProc15VGA;
      data <= iProc15Color;
    end
    default: begin
      $display("IN DEFAULT. WTF");
      addr <= 0;
      data <= 0;
    end
    endcase

  end
  else begin
    oProcRdy <= 0;
    w_en     <= 0;
  end
end
endmodule
