module fixed_to_float(
    input signed [17:0] fixed,
    output wire  [31:0] floatbits
);
integer int_fixed;
real float_repr; 
always @(*) begin
    int_fixed  <= $signed(fixed);
    float_repr <= $itor(int_fixed)/65536.0;
end
assign floatbits = $realtobits(float_repr);
endmodule


