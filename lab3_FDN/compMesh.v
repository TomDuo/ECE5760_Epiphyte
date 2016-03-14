module compMesh
#(
  parameter xSize = 16,
  parameter ySize = 16
)(

  // Clocks and Resets
    input clk,
    input reset,

  //Input Params
  input signed [17:0] rho,
  input signed [17:0] eta,
  input [2:0] tensionSel,

  // Output Values
    output reg signed [17:0] out
  );

wire [17:0] mesh_u [0:ySize-1][0:xSize-1];
reg signed [17:0] boundaryValue = 18'd0;
wire [xSize*ySize-1:0] validOuts ;

wire allValid = &validOuts;
genvar x;
genvar y;
generate 
    for(x=0; x<xSize; x=x+1) begin : xloop
        for(y=0; y<ySize;y=y+1) begin : yloop
            wire signed [17:0] uNorth = y != 0 ? mesh_u[y-1][x] : boundaryValue ;    
            wire signed [17:0] uSouth = y != ySize-1 ? mesh_u[y+1][x] : boundaryValue ;    
            wire signed [17:0] uWest = x != 0 ? mesh_u[y][x-1] : boundaryValue ;    
            wire signed [17:0] uEast = x != xSize-1 ? mesh_u[y][x+1] : boundaryValue ;    
            wire signed [17:0] dist = $sqrt(((xSize-x)-1)^2 + ((ySize - y)-1)^2); //Using manhattan distance for now
            wire signed [17:0] uInit = dist >= 15 ? 0 : ~((1<<dist)+18'd1);
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
    out <= 18'd22;
end

endmodule

