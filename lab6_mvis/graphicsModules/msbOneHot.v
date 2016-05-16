module msbOneHot ( 
  input      [63:0] in, 
  output reg [63:0] out
  );

always @(*) begin
  if (in>=(1<<63)) out <= (1<<63);
  else if (in>=(1<<62)) out <= (1<<62);
  else if (in>=(1<<61)) out <= (1<<61);
  else if (in>=(1<<60)) out <= (1<<60);
  else if (in>=(1<<59)) out <= (1<<59);
  else if (in>=(1<<58)) out <= (1<<58);
  else if (in>=(1<<57)) out <= (1<<57);
  else if (in>=(1<<56)) out <= (1<<56);
  else if (in>=(1<<55)) out <= (1<<55);
  else if (in>=(1<<54)) out <= (1<<54);
  else if (in>=(1<<53)) out <= (1<<53);
  else if (in>=(1<<52)) out <= (1<<52);
  else if (in>=(1<<51)) out <= (1<<51);
  else if (in>=(1<<50)) out <= (1<<50);
  else if (in>=(1<<49)) out <= (1<<49);
  else if (in>=(1<<48)) out <= (1<<48);
  else if (in>=(1<<47)) out <= (1<<47);
  else if (in>=(1<<46)) out <= (1<<46);
  else if (in>=(1<<45)) out <= (1<<45);
  else if (in>=(1<<44)) out <= (1<<44);
  else if (in>=(1<<43)) out <= (1<<43);
  else if (in>=(1<<42)) out <= (1<<42);
  else if (in>=(1<<41)) out <= (1<<41);
  else if (in>=(1<<40)) out <= (1<<40);
  else if (in>=(1<<39)) out <= (1<<39);
  else if (in>=(1<<38)) out <= (1<<38);
  else if (in>=(1<<37)) out <= (1<<37);
  else if (in>=(1<<36)) out <= (1<<36);
  else if (in>=(1<<35)) out <= (1<<35);
  else if (in>=(1<<34)) out <= (1<<34);
  else if (in>=(1<<33)) out <= (1<<33);
  else if (in>=(1<<32)) out <= (1<<32);
  else if (in>=(1<<31)) out <= (1<<31);
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