// Module brief:
//   - takes in a BPM and a one-bit signal to trigger start and timing of motion
//   - enable dancers with the switches input
//   - select type of motion with switches input
//   - output parameters for the top left x and y for given dancers
module motionManager (
  input clk,
  input reset,

  input [7:0] BPM,
  input       beatHit,
  input [3:0] dancer_en,
  input [2:0] motionType,

  output reg [9:0] bruce_x,
  output reg [8:0] bruce_y,

  output reg [9:0] d0_x,
  output reg [8:0] d0_y,

  output reg [9:0] d1_x,
  output reg [8:0] d1_y,

  output reg [9:0] d2_x,
  output reg [8:0] d2_y,
);


endmodule