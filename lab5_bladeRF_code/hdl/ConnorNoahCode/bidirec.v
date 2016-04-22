module bidirec (oe, clk, inp, outp, bidir);

// Port Declaration

input   oe;
input   clk;
input   inp;
output  outp;
inout   bidir;

reg     a;
reg     b;

assign bidir = oe ? a : 1'bZ ;
assign outp  = b;

// Always Construct

always @ (posedge clk)
begin
    b <= bidir;
    a <= inp;
end

endmodule