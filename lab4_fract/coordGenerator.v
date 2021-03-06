//=============================================================================
// ECE 5760 Lab 4
// Coord Generation module
//
// Connor Archard, Noah Levy March 2016
//
//=============================================================================
module coordGenerator (
  input clk,
  input reset,

  // inputs from NIOS
  input [4:0] zoomLevel,
  input [35:0] upperLeftX,
  input [35:0] upperLeftY,
  input        draw,

  // inputs from Load Dist
  input iLoadDistRdy,

  // outputs to Load Dist
  output reg        oLoadDistVal,
  output reg [9:0]  oVGAX,
  output reg [8:0]  oVGAY,
  output reg [35:0] oCoordX,
  output reg [35:0] oCoordY,
  output reg        done
);

  localparam x_step = 36'h000666666;
  localparam y_step = 36'h000888889;

  
  wire [35:0] xSize;
  wire [35:0] ySize;

  wire [35:0] xDist;
  wire [35:0] yDist;

  reg [1:0] state;
  reg [1:0] nextState;

  long_mult5760 xMuler (x_step,xDist,xSize);
  long_mult5760 yMuler (y_step,yDist,ySize);

  assign xDist = (36'h3_00000000 >> (zoomLevel));
  assign yDist = (36'h2_00000000 >> (zoomLevel));

  localparam s_init         = 2'd0;
  localparam s_waiting      = 2'd1;
  localparam s_getNextValue = 2'd2;
  localparam s_complete     = 2'd3;

  always @(posedge clk) begin
    state = nextState;
    if (reset || draw) nextState <= s_init;
	else begin
	  case(state)
	  s_init: begin
		 oLoadDistVal <= 0;
		 oVGAY        <= 9'd0;
		 oVGAX        <= 10'd0;
		 done         <= 0;
		 oCoordX      <= upperLeftX;
		 oCoordY      <= upperLeftY;
		 nextState    <= s_getNextValue;
	  end

	  s_waiting: begin
		 if (!oLoadDistVal) begin
			nextState    <= s_getNextValue;
		 end
		 else if (iLoadDistRdy) begin
			oLoadDistVal <= 0;
			nextState    <= s_getNextValue;
		 end
		 else begin
			oLoadDistVal <= 1;
			nextState    <= s_waiting;
		 end
	  end

	  s_getNextValue: begin
		 if ((oVGAX < 10'd640) && (oVGAY < 9'd480)) begin
		 oVGAX    <= oVGAX + 1;
		 oVGAY    <= oVGAY;
		 oCoordX  <= oCoordX + xSize;
		 oCoordY  <= oCoordY;
		 nextState    <= s_waiting;
		 oLoadDistVal <= 1;
		 end
		 else if ((oVGAX == 10'd640) && (oVGAY < 9'd480)) begin
			oVGAX <= 0;
			oVGAY <= oVGAY + 1;
			oCoordX <= upperLeftX;
			oCoordY <= oCoordY + ySize;
		 nextState    <= s_waiting;
		 oLoadDistVal <= 1;
		 end
		 else begin
			nextState <= s_complete;
			oLoadDistVal <= 0;
		 end
	  end

	  s_complete: begin
		 oLoadDistVal <= 0;
		 done         <= 1;
		 nextState <= s_complete;
	  end
	  endcase
  end
  end    

endmodule