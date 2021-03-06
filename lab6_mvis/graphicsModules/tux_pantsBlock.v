module tux_pantsBlock 
(
  input clk,
  input reset,
  input enable,
  input motion_en,
  
  input [10:0] pow,
  input [9:0] iVGA_X,
  input [8:0] iVGA_Y,
  input [9:0] topLeft_X,
  input [8:0] topLeft_Y,
  input [9:0] init_X,
  input [8:0] init_Y,
  
  output reg [5:0] oLayer,
  output reg oVal,
  output reg [7:0] R,
  output reg [7:0] G,
  output reg [7:0] B
);


localparam block_width = 77;
localparam block_height = 128;
wire  [23:0] q;        // data out of ROM
reg  [13:0] addr;     // addr into ROM
wire [9:0]  matrix_X;
wire [9:0]  matrix_Y;

assign matrix_X = iVGA_X - init_X;
assign matrix_Y = iVGA_Y - init_Y;

Pants_ROM prom0(
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


  end
  else if (enable) begin
    if ( (iVGA_X > init_X) && (iVGA_X < (init_X + block_width)) ) begin
      if ( (iVGA_Y > init_Y) && (iVGA_Y < (init_Y + block_height)) ) begin
        addr <= ((block_width*matrix_Y)+matrix_X);
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

endmodule