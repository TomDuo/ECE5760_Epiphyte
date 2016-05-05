// Module brief:
//   - takes in a BPM and a one-bit signal to trigger start and timing of motion
//   - enable dancers with the switches input
//   - select type of motion with switches input
//   - output parameters for the top left x and y for given dancers
module motionManager 
(
  input clk,
  input aud_clk,
  input reset,

  input [15:0] aud_clk_tics_per_beat, // #shoutouttotravis
  input       beatHit,
  input [3:0] dancer_en, // [0] = d0_en, [1] = d1_en, [2] = d2_en, [3] = bruce_en
  input [2:0] motionType,

  input [9:0] iVGA_X,
  input [8:0] iVGA_Y,

  input [9:0] ibruce_x_init,
  input [8:0] ibruce_y_init,
  input [9:0] id0_x_init,
  input [8:0] id0_y_init,
  input [9:0] id1_x_init,
  input [8:0] id1_y_init,
  input [9:0] id2_x_init,
  input [8:0] id2_y_init,

  output reg [9:0] obruce_x,
  output reg [8:0] obruce_y,

  output reg [9:0] od0_x,
  output reg [8:0] od0_y,

  output reg [9:0] od1_x,
  output reg [8:0] od1_y,

  output reg [9:0] od2_x,
  output reg [8:0] od2_y
);


//----------------------- FRAME COUNTER ---------------------------------------
reg [31:0] frame_counter;
reg        frame_clk;
reg [15:0] vga_tics;
reg        direction;

always @(posedge clk) begin
  if (reset) begin
    frame_counter <= 32'd0;
    frame_clk <= 1'b0;
  end
  else if ((iVGA_Y == 9'd0) && (iVGA_X == 10'd0) && ~frame_clk) begin
    frame_clk <= 1'b1;
    frame_counter <= frame_counter + 32'd1;
  end
  else if ((iVGA_Y != 9'd0) || (iVGA_X != 10'd0)) begin
    frame_clk <= 1'b0;
  end
end
//----------------------- END FRAME COUNTER -----------------------------------

//----------------------- BPM DIRECTION ---------------------------------------
always @(posedge aud_clk) begin
  if(reset) begin
    vga_tics <= 32'd0;
  end
  else if (beatHit) begin
    vga_tics <= 32'd0;
  end
  else if (vga_tics > aud_clk_tics_per_beat) begin
    vga_tics <= 32'd0;
  end
  else begin
    vga_tics <= vga_tics + 32'd1;
  end

  if (vga_tics <= (aud_clk_tics_per_beat>>1)) begin
    direction <= 1'b1;
  end
  else begin
    direction <= 1'b0;
  end
end
//----------------------- END BPM DIRECTION -----------------------------------

//----------------------- BRUCE MOTION MANAGEMENT -----------------------------
reg [31:0] counter_snapshot;
reg [9:0]  steps_counter;
always @(posedge frame_clk) begin
   if (reset) begin
    counter_snapshot <= frame_counter;
    bruce_x <= bruce_x_init;
    bruce_y <= bruce_y_init;
   end
   else if (dancer_en[3] && ((frame_counter - counter_snapshot) >= 32'd360)) begin
     counter_snapshot <= frame_counter;
     if (direction) begin
       steps_counter <= steps_counter + 10'd1;
       bruce_x <= bruce_x + 10'd1;
       bruce_y <= bruce_y + 10'd1;
     end
     else if (~direction) begin
       steps_counter <= steps_counter + 10'd1;
       bruce_x <= bruce_x - 10'd1;
       bruce_y <= bruce_y - 10'd1;
     end
     else begin
       steps_counter <= 10'd0;
     end

   end // end frame_counter
end // end always block
//----------------------- END BRUCE MOTION MANAGEMENT -------------------------

//----------------------- D0 MOTION MANAGEMENT --------------------------------
reg [31:0] counter_snapshotd0;
reg [9:0]  steps_counterd0;
always @(posedge frame_clk) begin
   if (reset) begin
     counter_snapshotd0 <= frame_counter;
    d0_x    <= d0_x_init;
    d0_y    <= d0_y_init;
   end
   
   else if ((frame_counter - counter_snapshotd0) >= 32'd15) begin
     counter_snapshotd0 <= frame_counter;
     if (steps_counterd0 <= 10'd30) begin
      steps_counterd0 <= steps_counterd0 + 10'd1;
       d0_x <= d0_x + 10'd1;
       d0_y <= d0_y + 10'd1;
     end
     else if (steps_counterd0 <= 10'd60) begin
       steps_counterd0 <= steps_counterd0 + 10'd1;
       d0_x <= d0_x - 10'd1;
       d0_y <= d0_y - 10'd1;
     end
     else begin
       steps_counterd0 <= 10'd0;
     end

   end // end frame_counter
end // end always block
//----------------------- END D0 MOTION MANAGEMENT ----------------------------

//----------------------- D1 MOTION MANAGEMENT --------------------------------
reg [31:0] counter_snapshotd1;
reg [9:0]  steps_counterd1;
always @(posedge frame_clk) begin
   if (reset) begin
     counter_snapshotd1 <= frame_counter;
    d1_x    <= d1_x_init;
    d1_y    <= d1_y_init;
   end
   
   else if ((frame_counter - counter_snapshotd1) >= 32'd15) begin
     counter_snapshotd1 <= frame_counter;
     if (steps_counterd1 <= 10'd30) begin
      steps_counterd1 <= steps_counterd1 + 10'd1;
       d1_x <= d1_x + 10'd1;
       d1_y <= d1_y + 10'd1;
     end
     else if (steps_counterd1 <= 10'd60) begin
       steps_counterd1 <= steps_counterd1 + 10'd1;
       d1_x <= d1_x - 10'd1;
       d1_y <= d1_y - 10'd1;
     end
     else begin
       steps_counterd1 <= 10'd0;
     end

   end // end frame_counter
end // end always block
//----------------------- END D1 MOTION MANAGEMENT ----------------------------

//----------------------- D2 MOTION MANAGEMENT --------------------------------
reg [31:0] counter_snapshotd2;
reg [9:0]  steps_counterd2;
always @(posedge frame_clk) begin
   if (reset) begin
     counter_snapshotd2 <= frame_counter;
    d2_x    <= d2_x_init;
    d2_y    <= d2_y_init;
   end
   
   else if ((frame_counter - counter_snapshotd2) >= 32'd15) begin
     counter_snapshotd2 <= frame_counter;
     if (steps_counterd2 <= 10'd30) begin
      steps_counterd2 <= steps_counterd2 + 10'd1;
       d2_x <= d2_x + 10'd1;
       d2_y <= d2_y + 10'd1;
     end
     else if (steps_counterd2 <= 10'd60) begin
       steps_counterd2 <= steps_counterd2 + 10'd1;
       d2_x <= d2_x - 10'd1;
       d2_y <= d2_y - 10'd1;
     end
     else begin
       steps_counterd2 <= 10'd0;
     end

   end // end frame_counter
end // end always block
//----------------------- END D2 MOTION MANAGEMENT ----------------------------
endmodule