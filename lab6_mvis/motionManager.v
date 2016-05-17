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

  //input [15:0] aud_clk_tics_per_beat, // #shoutouttotravis
  input [10:0] beatSignalIn,
  //input beatHit,
  input [3:0] dancer_en, // [0] = d0_en, [1] = d1_en, [2] = d2_en, [3] = bruce_en

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
    frame_clk <= ~frame_clk; 	// have this keep moving so that we can reach reset 
										// in other blocks
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
wire [31:0] aud_clk_tics_per_beat;
wire beatHit;

tempoFinder #( 11'h040
	) tf1(
	.aud_clk(aud_clk),
	.reset(reset),
	.iPow(beatSignalIn),

	.aud_tics_per_beat(aud_clk_tics_per_beat),
	.beatHit(beatHit)
	);

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
    obruce_x <= ibruce_x_init;
    obruce_y <= ibruce_y_init;
   end
   else if (dancer_en[3] && ((frame_counter - counter_snapshot) >= 32'd360)) begin 
     counter_snapshot <= frame_counter;
     if (direction) begin
       steps_counter <= steps_counter + 10'd1;
       obruce_x <= obruce_x + 10'd1;
       obruce_y <= obruce_y + 9'd1;
     end
     else if (~direction) begin
       steps_counter <= steps_counter + 10'd1;
       obruce_x <= obruce_x - 10'd1;
       obruce_y <= obruce_y - 9'd1;
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
    od0_x    <= id0_x_init;
    od0_y    <= id0_y_init;
   end
   
   else if (dancer_en[0] && (frame_counter - counter_snapshotd0) >= 32'd360) begin
     counter_snapshotd0 <= frame_counter;
     if (direction) begin
      steps_counterd0 <= steps_counterd0 + 10'd1;
       od0_x <= od0_x + 10'd1;
       od0_y <= od0_y + 10'd1;
     end
     else if (~direction) begin
       steps_counterd0 <= steps_counterd0 + 10'd1;
       od0_x <= od0_x - 10'd1;
       od0_y <= od0_y - 10'd1;
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
    od1_x    <= id1_x_init;
    od1_y    <= id1_y_init;
   end
   
   else if (dancer_en[1] && (frame_counter - counter_snapshotd1) >= 32'd360) begin
     counter_snapshotd1 <= frame_counter;
     if (direction) begin
      steps_counterd1 <= steps_counterd1 + 10'd1;
       od1_x <= od1_x + 10'd1;
       od1_y <= od1_y + 10'd1;
     end
     else if (~direction) begin
       steps_counterd1 <= steps_counterd1 + 10'd1;
       od1_x <= od1_x - 10'd1;
       od1_y <= od1_y - 10'd1;
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
    od2_x    <= id2_x_init;
    od2_y    <= id2_y_init;
   end
   
   else if (dancer_en[2] && (frame_counter - counter_snapshotd2) >= 32'd360) begin
     counter_snapshotd2 <= frame_counter;
     if (direction) begin
      steps_counterd2 <= steps_counterd2 + 10'd1;
       od2_x <= od2_x + 10'd1;
       od2_y <= od2_y + 10'd1;
     end
     else if (~direction) begin
       steps_counterd2 <= steps_counterd2 + 10'd1;
       od2_x <= od2_x - 10'd1;
       od2_y <= od2_y - 10'd1;
     end
     else begin
       steps_counterd2 <= 10'd0;
     end

   end // end frame_counter
end // end always block
//----------------------- END D2 MOTION MANAGEMENT ----------------------------
endmodule