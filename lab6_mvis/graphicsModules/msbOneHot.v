module msbOneHot ( 
  input      [31:0] in, 
  output reg [31:0] out
  );

always @(*) begin
  if      (in>=(1<<31)) out <= (1<<31);
  else if (in>=(1<<30)) out <= (1<<30);
  else if (in>=(1<<29)) out <= (1<<29);
  else if (in>=(1<<28)) out <= (1<<28);
  else if (in>=(1<<27)) out <= (1<<27);
  else if (in>=(1<<26)) out <= (1<<26);
  else if (in>=(1<<25)) out <= (1<<25);
  else if (in>=(1<<24)) out <= (1<<24);
  else if (in>=(1<<23)) out <= (1<<23);
  else if (in>=(1<<22)) out <= (1<<22);
  else if (in>=(1<<21)) out <= (1<<21);
  else if (in>=(1<<20)) out <= (1<<20);
  else if (in>=(1<<19)) out <= (1<<19);
  else if (in>=(1<<18)) out <= (1<<18);
  else if (in>=(1<<17)) out <= (1<<17);
  else if (in>=(1<<16)) out <= (1<<16);
  else if (in>=(1<<15)) out <= (1<<15);
  else if (in>=(1<<14)) out <= (1<<14);
  else if (in>=(1<<13)) out <= (1<<13);
  else if (in>=(1<<12)) out <= (1<<12);
  else if (in>=(1<<11)) out <= (1<<11);
  else if (in>=(1<<10)) out <= (1<<10);
  else if (in>=(1<<9))  out <= (1<<9);
  else if (in>=(1<<8))  out <= (1<<8);
  else if (in>=(1<<7))  out <= (1<<7);
  else if (in>=(1<<6))  out <= (1<<6);
  else if (in>=(1<<5))  out <= (1<<5);
  else if (in>=(1<<4))  out <= (1<<4);
  else if (in>=(1<<3))  out <= (1<<3);
  else if (in>=(1<<2))  out <= (1<<2);
  else if (in>=(1<<1))  out <= (1<<1);
  else if (in>=(1<<0))  out <= (1<<0);
  else                  out <= 0;
end
endmodule