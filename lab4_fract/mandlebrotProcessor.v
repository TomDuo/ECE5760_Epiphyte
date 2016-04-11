module mandlebrotProcessor #(
  parameter maxIterations = 512
  )(
  // clocks and resets
  input clk,
  input reset,

  // inputs from load dist
  input        iDataVal,
  input [35:0] iCoordX,
  input [35:0] iCoordY,
  input [9:0]  iVGAX,
  input [8:0]  iVGAY,

  // signals sent to load distr
  output reg        oProcReady,

  // input from arbitor
  input valueStored, 

  // signals sent to VGA buffer
  output reg [4:0]  oColor,
  output reg [18:0] oVGACoord,
  output reg        oVGAVal 
);

localparam s_init        = 4'd0;
localparam s_waiting     = 4'd1;
localparam s_processing  = 4'd2;
localparam s_store       = 4'd3;

reg [3:0] state;
reg [3:0] nextState;

reg signed [35:0] xCoord;
reg signed [35:0] yCoord;

reg        [11:0] calcCount;
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

long_mult5760 mul1 (mul1ina,mul1inb,mul1out);
long_mult5760 mul2 (mul2ina,mul2inb,mul2out);
long_mult5760 mul3 (mul3ina,mul3inb,mul3out);

always @(posedge clk) begin
  state = nextState;
  if (reset) nextState <= s_init;

  case(state)
  s_init: begin
    nextState <= s_waiting;
    oVGAVal     <= 0;
  end

  s_waiting: begin
    oVGAVal     <= 0;
    if (iDataVal) begin
      nextState  <= s_processing;
      xCoord     <= iCoordX;
      yCoord     <= iCoordY;
      oVGACoord  <= iVGAX + 640*iVGAY;
      calcCount  <= 0;
      z_real     <= 0;
      z_imag     <= 0;
      oProcReady <= 0;
      mul1ina    <= 0;
      mul1inb    <= 0;
      mul2ina    <= 0;
      mul2inb    <= 0;
      mul3ina    <= 0;
      mul3inb    <= 0;
    end
    else begin
      nextState <= s_waiting;
      oProcReady  <= 1;
    end
  end

  s_processing: begin
    // don't try to take in new data
    oProcReady <= 0;

    // increment the number of calculations that has happened
    calcCount <= calcCount + 1;

    // set multiplication inputs for next calc
    
    mul1ina   <= z_real;
    mul1inb   <= z_real;

    mul2ina   <= z_real;
    mul2inb   <= z_imag;
    
    mul3ina   <= z_imag;
    mul3inb   <= z_imag;

    // take results from muls of previous calc
    z_real    <= mul1out - mul3out + xCoord;
    z_imag    <= (mul2out<<1) + yCoord;

    // if there have been too many calculations, return with dark color
    if (calcCount >= maxIterations) begin
      oColor    <= 5'd31;// {3{iVGAX[0]}};
      oVGAVal   <= 1;
      nextState <= s_store;
    end
    // if you have a magnitude greater than 2, return with log2(iterations)
    else if ((mul1out + mul3out)>36'h4_00000000) begin
      oColor    <= (calcCount>>6);//{3{iVGAX[0]}};//
      oVGAVal   <= 1;
      nextState <= s_store;
    end
    // otherwise continue calculations
    else begin
      nextState <= s_processing;
      oVGAVal <= 0;
    end
  end

  s_store:
    if(valueStored) begin
      oProcReady <= 1;
      oVGAVal    <= 0;
      nextState  <= s_waiting;
    end
    else begin
      oProcReady <= 0;
      oVGAVal    <= 1;
      nextState  <= s_store;
    end

  default: begin
      nextState <= s_waiting;
  end
  endcase
end

endmodule
