module headBlock #(
  parameter block_width = 114,
  parameter block_height = 90,
  parameter x_init = 280,
  parameter y_init = 240
)
(
  input clk,
  input reset,
  input enable,
  input motion_en,
  
  input [10:0] pow,
  input [9:0] iVGA_X,
  input [8:0] iVGA_Y,
  
  output reg [5:0] oLayer,
  output reg oVal,
  output reg [7:0] R,
  output reg [7:0] G,
  output reg [7:0] B
);

reg  [23:0] q;        // data out of ROM
reg  [13:0] addr;     // addr into ROM
wire [9:0]  matrix_X;
wire [9:0]  matrix_Y;

assign matrix_X = iVGA_X - topLeftX;
assign matrix_Y = iVGA_Y - topLeftY;

headRom (
  .address(addr),
  .clock(clk),
  .q(q)
  );

// index into matrix and examine content
always @(posedge clk) begin
  if (reset) begin
    // reset
    R <= 8'b0;
    G <= 8'b0;
    B <= 8'b0;
    oVal <= 1'b0;
    topLeftX <= x_init;
    topLeftY <= y_init;

  end
  else if (enable) begin
    if ( (iVGA_X > topLeftX) && (iVGA_X < (topLeftX + block_width)) ) begin
      if ( (iVGA_Y > topLeftY) && (iVGA_Y < (topLeftY + block_height)) ) begin
        addr <= ((matrix_X*matrix_Y)+matrix_Y);
        if (q > 24'b0) begin
          oVal <= 1'b1;
          R <= q[23:16];
          G <= q[15:8];
          B <= q[7:0];
        end
        else begin
          oVal <= 1'b0;
        end
      end
      else begin
        oVal <= 1'b0; // if not in the box, don't return valid
      end
    end
    else begin // if not in the box, don't return valid
      oVal <= 1'b0;
    end
  end // end reset case
end

// motion work
reg [9:0] frame_counter;
reg [9:0] prev_frame_count;
reg [9:0] topLeftX;
reg [8:0] topLeftY;
reg [2:0] stepDiv;
reg       stepDir; // 0 = down, 1 = up

always @(posedge clk) begin
  if (reset) begin
    end
  else if (motion_en) begin
    if ((iVGA_Y == 0) && (iVGA_X == 0)) begin
      if (frame_counter < 10'd60) begin
        frame_counter <= frame_counter + 1;
      end
      else begin
        frame_counter <= 10'd0;
        stepDir <= 1 ^ stepDir;
      end
    end


    
    else if (prev_frame_count ~= frame_counter) begin
      prev_frame_count <= frame_counter;
        stepDiv <= stepDiv + 1;   
      if (stepDiv == 3'd7) begin
        if (stepDir) begin
          topLeftX <= topLeftX + 1;
          topLeftY <= topLeftY - 1; 
        end 
        else begin
          topLeftX <= topLeftX - 1;
          topLeftY <= topLeftY + 1; 
        end     
      end
    end
  end
end

endmodule