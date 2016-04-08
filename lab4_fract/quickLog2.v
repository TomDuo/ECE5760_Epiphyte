module quickLog2 ( 
  input      [31:0] in, 
  output reg [4:0] out
  );

always @(*) begin
  if      (in>=(1<<31)) out <= (5'd31); // this line isn't quite true, but we won't use values this large
  else if (in>=(1<<30)) out <= (5'd30);
  else if (in>=(1<<29)) out <= (5'd29);
  else if (in>=(1<<28)) out <= (5'd28);
  else if (in>=(1<<27)) out <= (5'd27);
  else if (in>=(1<<26)) out <= (5'd26);
  else if (in>=(1<<25)) out <= (5'd25);
  else if (in>=(1<<24)) out <= (5'd24);
  else if (in>=(1<<23)) out <= (5'd23);
  else if (in>=(1<<22)) out <= (5'd22);
  else if (in>=(1<<21)) out <= (5'd21);
  else if (in>=(1<<20)) out <= (5'd20);
  else if (in>=(1<<19)) out <= (5'd19);
  else if (in>=(1<<18)) out <= (5'd18);
  else if (in>=(1<<17)) out <= (5'd17);
  else if (in>=(1<<16)) out <= (5'd16);
  else if (in>=(1<<15)) out <= (5'd15);
  else if (in>=(1<<14)) out <= (5'd14);
  else if (in>=(1<<13)) out <= (5'd13);
  else if (in>=(1<<12)) out <= (5'd12);
  else if (in>=(1<<11)) out <= (5'd11);
  else if (in>=(1<<10)) out <= (5'd10);
  else if (in>=(1<<9))  out <= (5'd9);
  else if (in>=(1<<8))  out <= (5'd8);
  else if (in>=(1<<7))  out <= (5'd7);
  else if (in>=(1<<6))  out <= (5'd6);
  else if (in>=(1<<5))  out <= (5'd5);
  else if (in>=(1<<4))  out <= (5'd4);
  else if (in>=(1<<3))  out <= (5'd3);
  else if (in>=(1<<2))  out <= (5'd2);
  else if (in>=(1<<1))  out <= (5'd1);
  else if (in>=(1<<0))  out <= (5'd0);
  else                  out <= (5'd0);
end
endmodule
