module compMesh
#(
  parameter xSize = 16,
  parameter ySize = 16,
  parameter amplitudeInit = 0.1,
  parameter alpha = -0.05,
  parameter boundary_value = 0.0
)(

  // Clocks and Resets
    input clk,
    input reset,

  //Input Params
  input signed [17:0] rho,
  input signed [17:0] eta,
  input [2:0] tensionSel,

  // Output Values
    output reg signed [17:0] out,
    output wire allValid
  );

wire [17:0] mesh_u [0:ySize-1][0:xSize-1];
wire [xSize*ySize-1:0] validOuts ;
assign allValid = validOuts[0];
genvar x;
genvar y;
generate 
    for(x=0; x<xSize; x=x+1) begin : xloop
        for(y=0; y<ySize;y=y+1) begin : yloop

            /*
            wire signed [17:0] uNorth = y != 0 ? mesh_u[y-1][x] : boundaryValue ;    
            wire signed [17:0] uSouth = y != ySize-1 ? mesh_u[y+1][x] : boundaryValue ;    
            wire signed [17:0] uWest = x != 0 ? mesh_u[y][x-1] : boundaryValue ;    
            wire signed [17:0] uEast = x != xSize-1 ? mesh_u[y][x+1] : boundaryValue ;    
             //Boundary conditions for no tiling
            */
              
            wire signed [17:0] uNorth = y != 0 ? mesh_u[y-1][x] : 0 ;    
            wire signed [17:0] uSouth = y != ySize-1 ? mesh_u[y+1][x] : mesh_u[y][x] ;    
            wire signed [17:0] uWest = x != 0 ? mesh_u[y][x-1] : 0 ;    
            wire signed [17:0] uEast = x != xSize-1 ? mesh_u[y][x+1] : mesh_u[y][x] ;    

			wire signed [17:0] uInit = gaussian[x][y];
            compNode #(x,y) cn (
                .clk(clk),
                .reset(reset),
                .uInit(uInit),
                .uNorth(uNorth),
                .uSouth(uSouth),
                .uEast(uEast),
                .uWest(uWest),
                .rho(rho),
                .eta(eta),
                .tensionSel(tensionSel),
                .u(mesh_u[y][x]), 
                .validOut(validOuts[xSize*y + x])
            );
        end
    end
endgenerate

always @(posedge allValid) begin
    out <= mesh_u[ySize-1][xSize-1];
end

wire [17:0] gaussian [0:xSize-1][0:ySize-1];
assign gaussian[0][0] = 18'h0;
assign gaussian[0][1] = 18'h0;
assign gaussian[0][2] = 18'h0;
assign gaussian[0][3] = 18'h0;
assign gaussian[0][4] = 18'h0;
assign gaussian[0][5] = 18'h0;
assign gaussian[0][6] = 18'h0;
assign gaussian[0][7] = 18'h0;
assign gaussian[0][8] = 18'h0;
assign gaussian[0][9] = 18'h0;
assign gaussian[0][10] = 18'h0;
assign gaussian[0][11] = 18'h0;
assign gaussian[0][12] = 18'h0;
assign gaussian[0][13] = 18'h0;
assign gaussian[0][14] = 18'h0;
assign gaussian[1][0] = 18'h0;
assign gaussian[1][1] = 18'h0;
assign gaussian[1][2] = 18'h0;
assign gaussian[1][3] = 18'h0;
assign gaussian[1][4] = 18'h0;
assign gaussian[1][5] = 18'h0;
assign gaussian[1][6] = 18'h0;
assign gaussian[1][7] = 18'h0;
assign gaussian[1][8] = 18'h0;
assign gaussian[1][9] = 18'h0;
assign gaussian[1][10] = 18'h0;
assign gaussian[1][11] = 18'h0;
assign gaussian[1][12] = 18'h0;
assign gaussian[1][13] = 18'h0;
assign gaussian[1][14] = 18'h0;
assign gaussian[2][0] = 18'h0;
assign gaussian[2][1] = 18'h0;
assign gaussian[2][2] = 18'h0;
assign gaussian[2][3] = 18'h0;
assign gaussian[2][4] = 18'h0;
assign gaussian[2][5] = 18'h0;
assign gaussian[2][6] = 18'h0;
assign gaussian[2][7] = 18'h0;
assign gaussian[2][8] = 18'h0;
assign gaussian[2][9] = 18'h0;
assign gaussian[2][10] = 18'h0;
assign gaussian[2][11] = 18'h0;
assign gaussian[2][12] = 18'h0;
assign gaussian[2][13] = 18'h0;
assign gaussian[2][14] = 18'h0;
assign gaussian[3][0] = 18'h0;
assign gaussian[3][1] = 18'h0;
assign gaussian[3][2] = 18'h0;
assign gaussian[3][3] = 18'h0;
assign gaussian[3][4] = 18'h0;
assign gaussian[3][5] = 18'h0;
assign gaussian[3][6] = 18'h0;
assign gaussian[3][7] = 18'h0;
assign gaussian[3][8] = 18'h0;
assign gaussian[3][9] = 18'h0;
assign gaussian[3][10] = 18'h0;
assign gaussian[3][11] = 18'h0;
assign gaussian[3][12] = 18'h0;
assign gaussian[3][13] = 18'h0;
assign gaussian[3][14] = 18'h0;
assign gaussian[4][0] = 18'h0;
assign gaussian[4][1] = 18'h0;
assign gaussian[4][2] = 18'h0;
assign gaussian[4][3] = 18'h0;
assign gaussian[4][4] = 18'h0;
assign gaussian[4][5] = 18'h0;
assign gaussian[4][6] = 18'h0;
assign gaussian[4][7] = 18'h0;
assign gaussian[4][8] = 18'h0;
assign gaussian[4][9] = 18'h0;
assign gaussian[4][10] = 18'h0;
assign gaussian[4][11] = 18'h0;
assign gaussian[4][12] = 18'h0;
assign gaussian[4][13] = 18'h0;
assign gaussian[4][14] = 18'h0;
assign gaussian[5][0] = 18'h0;
assign gaussian[5][1] = 18'h0;
assign gaussian[5][2] = 18'h0;
assign gaussian[5][3] = 18'h0;
assign gaussian[5][4] = 18'h0;
assign gaussian[5][5] = 18'h0;
assign gaussian[5][6] = 18'h0;
assign gaussian[5][7] = 18'h0;
assign gaussian[5][8] = 18'h0;
assign gaussian[5][9] = 18'h0;
assign gaussian[5][10] = 18'h0;
assign gaussian[5][11] = 18'h1;
assign gaussian[5][12] = 18'h1;
assign gaussian[5][13] = 18'h2;
assign gaussian[5][14] = 18'h2;
assign gaussian[6][0] = 18'h0;
assign gaussian[6][1] = 18'h0;
assign gaussian[6][2] = 18'h0;
assign gaussian[6][3] = 18'h0;
assign gaussian[6][4] = 18'h0;
assign gaussian[6][5] = 18'h0;
assign gaussian[6][6] = 18'h0;
assign gaussian[6][7] = 18'h0;
assign gaussian[6][8] = 18'h0;
assign gaussian[6][9] = 18'h1;
assign gaussian[6][10] = 18'h2;
assign gaussian[6][11] = 18'h4;
assign gaussian[6][12] = 18'h7;
assign gaussian[6][13] = 18'ha;
assign gaussian[6][14] = 18'hb;
assign gaussian[7][0] = 18'h0;
assign gaussian[7][1] = 18'h0;
assign gaussian[7][2] = 18'h0;
assign gaussian[7][3] = 18'h0;
assign gaussian[7][4] = 18'h0;
assign gaussian[7][5] = 18'h0;
assign gaussian[7][6] = 18'h0;
assign gaussian[7][7] = 18'h0;
assign gaussian[7][8] = 18'h1;
assign gaussian[7][9] = 18'h4;
assign gaussian[7][10] = 18'ha;
assign gaussian[7][11] = 18'h14;
assign gaussian[7][12] = 18'h21;
assign gaussian[7][13] = 18'h2c;
assign gaussian[7][14] = 18'h31;
assign gaussian[8][0] = 18'h0;
assign gaussian[8][1] = 18'h0;
assign gaussian[8][2] = 18'h0;
assign gaussian[8][3] = 18'h0;
assign gaussian[8][4] = 18'h0;
assign gaussian[8][5] = 18'h0;
assign gaussian[8][6] = 18'h0;
assign gaussian[8][7] = 18'h1;
assign gaussian[8][8] = 18'h5;
assign gaussian[8][9] = 18'hf;
assign gaussian[8][10] = 18'h24;
assign gaussian[8][11] = 18'h49;
assign gaussian[8][12] = 18'h78;
assign gaussian[8][13] = 18'ha2;
assign gaussian[8][14] = 18'hb3;
assign gaussian[9][0] = 18'h0;
assign gaussian[9][1] = 18'h0;
assign gaussian[9][2] = 18'h0;
assign gaussian[9][3] = 18'h0;
assign gaussian[9][4] = 18'h0;
assign gaussian[9][5] = 18'h0;
assign gaussian[9][6] = 18'h1;
assign gaussian[9][7] = 18'h4;
assign gaussian[9][8] = 18'hf;
assign gaussian[9][9] = 18'h2c;
assign gaussian[9][10] = 18'h6d;
assign gaussian[9][11] = 18'hdb;
assign gaussian[9][12] = 18'h169;
assign gaussian[9][13] = 18'h1e7;
assign gaussian[9][14] = 18'h21a;
assign gaussian[10][0] = 18'h0;
assign gaussian[10][1] = 18'h0;
assign gaussian[10][2] = 18'h0;
assign gaussian[10][3] = 18'h0;
assign gaussian[10][4] = 18'h0;
assign gaussian[10][5] = 18'h0;
assign gaussian[10][6] = 18'h2;
assign gaussian[10][7] = 18'ha;
assign gaussian[10][8] = 18'h24;
assign gaussian[10][9] = 18'h6d;
assign gaussian[10][10] = 18'h10b;
assign gaussian[10][11] = 18'h21a;
assign gaussian[10][12] = 18'h377;
assign gaussian[10][13] = 18'h4ad;
assign gaussian[10][14] = 18'h52b;
assign gaussian[11][0] = 18'h0;
assign gaussian[11][1] = 18'h0;
assign gaussian[11][2] = 18'h0;
assign gaussian[11][3] = 18'h0;
assign gaussian[11][4] = 18'h0;
assign gaussian[11][5] = 18'h1;
assign gaussian[11][6] = 18'h4;
assign gaussian[11][7] = 18'h14;
assign gaussian[11][8] = 18'h49;
assign gaussian[11][9] = 18'hdb;
assign gaussian[11][10] = 18'h21a;
assign gaussian[11][11] = 18'h43b;
assign gaussian[11][12] = 18'h6fa;
assign gaussian[11][13] = 18'h96b;
assign gaussian[11][14] = 18'ha68;
assign gaussian[12][0] = 18'h0;
assign gaussian[12][1] = 18'h0;
assign gaussian[12][2] = 18'h0;
assign gaussian[12][3] = 18'h0;
assign gaussian[12][4] = 18'h0;
assign gaussian[12][5] = 18'h1;
assign gaussian[12][6] = 18'h7;
assign gaussian[12][7] = 18'h21;
assign gaussian[12][8] = 18'h78;
assign gaussian[12][9] = 18'h169;
assign gaussian[12][10] = 18'h377;
assign gaussian[12][11] = 18'h6fa;
assign gaussian[12][12] = 18'hb81;
assign gaussian[12][13] = 18'hf87;
assign gaussian[12][14] = 18'h1129;
assign gaussian[13][0] = 18'h0;
assign gaussian[13][1] = 18'h0;
assign gaussian[13][2] = 18'h0;
assign gaussian[13][3] = 18'h0;
assign gaussian[13][4] = 18'h0;
assign gaussian[13][5] = 18'h2;
assign gaussian[13][6] = 18'ha;
assign gaussian[13][7] = 18'h2c;
assign gaussian[13][8] = 18'ha2;
assign gaussian[13][9] = 18'h1e7;
assign gaussian[13][10] = 18'h4ad;
assign gaussian[13][11] = 18'h96b;
assign gaussian[13][12] = 18'hf87;
assign gaussian[13][13] = 18'h14f6;
assign gaussian[13][14] = 18'h172a;
assign gaussian[14][0] = 18'h0;
assign gaussian[14][1] = 18'h0;
assign gaussian[14][2] = 18'h0;
assign gaussian[14][3] = 18'h0;
assign gaussian[14][4] = 18'h0;
assign gaussian[14][5] = 18'h2;
assign gaussian[14][6] = 18'hb;
assign gaussian[14][7] = 18'h31;
assign gaussian[14][8] = 18'hb3;
assign gaussian[14][9] = 18'h21a;
assign gaussian[14][10] = 18'h52b;
assign gaussian[14][11] = 18'ha68;
assign gaussian[14][12] = 18'h1129;
assign gaussian[14][13] = 18'h172a;
assign gaussian[14][14] = 18'h199a;
endmodule

