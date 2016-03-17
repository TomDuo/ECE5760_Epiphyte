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
            wire signed [17:0] drum_init_r = ((x == 0) | (y == 0)) ? 0 : (1<<(xSize-x-y));
				//real drum_init_r = (x == 0) || (y == 0) ? boundary_value : 65536.0*amplitudeInit*$exp(alpha*(  (((xSize-x)-1)*((xSize-x)-1)) + ( ((ySize - y)-1)*((ySize-y)-1) ) )) ; 
            //Boundary conditions for full tiling           
            /*
            if( (x == 0) || (y == 0) ) begin
                drum_init_r = boundary_gain;
            end
            else begin 
                drum_init_r= 65536.0*amplitudeInit*$exp(alpha*(  (((xSize-x)-1)*((xSize-x)-1)) + ( ((ySize - y)-1)*((ySize-y)-1) ) )) ; //Using euclidean distance for now
            end
            */
				wire signed [17:0] uInit = drum_init_r;
            //wire signed [17:0] uInit = $rtoi(drum_init_r);//dist >= 15 ? 0 : ~((18'h0_1800>>dist)+18'd1);
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

endmodule

