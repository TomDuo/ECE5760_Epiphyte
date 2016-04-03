module mandlebrotProcessor #(
  parameter maxIterations = 512
  )(
  // clocks and resets
  input clk,
  input reset,

  // inputs from queue
  input        iDataVal,
  input [35:0] iCoordX,
  input [35:0] iCoordY,
  input [9:0]  iVGAX,
  input [8:0]  iVGAY,

  // signals sent to queue
  output reg        oProcReady,

  // signals sent to VGA buffer
  output reg [3:0]  oColor,
  output reg [18:0] oVGACoord,
  output reg        oVGAVal 
);

localparam s_init        = 4'd0;
localparam s_waiting     = 4'd1;
localparam s_processing  = 4'd2;

reg [3:0] state;
reg [3:0] nextState;

reg signed [9:0] xCoord;
reg signed [8:0] yCoord;

reg [11:0] calcCount;
reg signed [35:0] z_real;
reg signed [35:0] z_imag;

reg  signed [35:0] mul1ina;
reg  signed [35:0] mul1inb;
wire signed [35:0] mul1out;
reg  signed [35:0] mul2ina;
reg  signed [35:0] mul2inb;
wire signed [35:0] mul2out;
reg  signed [35:0] mul3ina;
reg  signed [35:0] mul3inb;
wire signed [35:0] mul3out;
reg  signed [35:0] mul4ina;
reg  signed [35:0] mul4inb;
wire signed [35:0] mul4out;
reg  signed [35:0] mul5ina;
reg  signed [35:0] mul5inb;
wire signed [35:0] mul5out;

fixed_comb_mult5760 mul1 (mul1ina,mul1inb,mul1out);
fixed_comb_mult5760 mul2 (mul2ina,mul2inb,mul2out);
fixed_comb_mult5760 mul3 (mul3ina,mul3inb,mul3out);
fixed_comb_mult5760 mul4 (mul4ina,mul4inb,mul4out);
fixed_comb_mult5760 mul5 (mul5ina,mul5inb,mul5out);

wire [3:0] log2Iter;
quickLog2 ql1 (calcCount,log2Iter);

always @(posedge clk) begin
  state = nextState;
  if (reset) nextState <= s_init;

  case(state)
  s_init: begin
    nextState <= s_waiting;
    oVGAVal     <= 0;
  end

  s_waiting: begin
    oProcReady  <= 1;
    oVGAVal     <= 0;
    if (iDataVal) begin
      nextState <= s_processing;
      xCoord    <= iCoordX;
      yCoord    <= iCoordY;
      oVGACoord <= {iVGAX,iVGAY};
      calcCount <= 0;
      z_real    <= 0;
      z_imag    <= 0;
    end
    else nextState <= s_waiting;
  end

  s_processing: begin
    // don't try to take in new data
    oProcReady <= 0;

    // increment the number of calculations that has happened
    calcCount <= calcCount + 1;

    // set multiplication inputs for next calc
    mul1ina   <= xCoord;
    mul1inb   <= xCoord;
    mul2ina   <= xCoord;
    mul2inb   <= yCoord;
    mul3ina   <= yCoord;
    mul3inb   <= yCoord;

    // get the absolute value for the next calc
    mul4ina   <= z_real;
    mul4inb   <= z_real;
    mul5ina   <= z_imag;
    mul5inb   <= z_imag;

    // take results from muls of previous calc
    z_real    <= mul1out - mul3out + xCoord;
    z_imag    <= mul2out + yCoord;

    // if there have been too many calculations, return with dark color
    if (calcCount > maxIterations) begin
      oColor    <= 4'd0;
      oVGAVal   <= 1;
      nextState <= s_waiting;
    end
    // if you have a magnitude greater than 2, return with log2(iterations)
    else if ((mul4out + mul5out)>4) begin
      oColor    <= log2Iter;
      oVGAVal   <= 1;
      nextState <= s_waiting;
    end
    // otherwise continue calculations
    else begin
      nextState <= s_processing;
      oVGAVal <= 0;
    end
  end

  default: begin
      nextState = s_waiting;
  end
  endcase
end

endmodule
