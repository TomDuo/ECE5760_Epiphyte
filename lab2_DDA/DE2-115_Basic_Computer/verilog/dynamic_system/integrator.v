
// Integrator.v from Bruce's example code
module integrator #(
parameter functwidth = 18
)
(
  output [17:0] out,         //the state variable V
  input signed [functwidth-1:0] funct,      //the dV/dt function
  input [3:0] dt ,        // in units of SHIFT-right
  input clk, reset,
  input signed [17:0] InitialOut //the initial state variable V
  );  
  wire signed  [17:0] out, v1new ;
  reg signed  [17:0] v1 ;
  
  always @ (posedge clk) 
  begin
    if (reset==1) //reset  
      v1 <= InitialOut ; // 
    else 
      v1 <= v1new ;  
  end
  assign v1new = v1 + (funct>>>dt) ;
  assign out = v1 ;
endmodule
