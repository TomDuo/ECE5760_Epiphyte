module msbOneHot ( 
input      [159:0] in,
 output reg [159:0] out
);

always @(*) begin
if (in>=(1<<159)) out <= (1<<159);
else if (in>=(1<<158)) out <= (1<<158);
else if (in>=(1<<157)) out <= (1<<157);
else if (in>=(1<<156)) out <= (1<<156);
else if (in>=(1<<155)) out <= (1<<155);
else if (in>=(1<<154)) out <= (1<<154);
else if (in>=(1<<153)) out <= (1<<153);
else if (in>=(1<<152)) out <= (1<<152);
else if (in>=(1<<151)) out <= (1<<151);
else if (in>=(1<<150)) out <= (1<<150);
else if (in>=(1<<149)) out <= (1<<149);
else if (in>=(1<<148)) out <= (1<<148);
else if (in>=(1<<147)) out <= (1<<147);
else if (in>=(1<<146)) out <= (1<<146);
else if (in>=(1<<145)) out <= (1<<145);
else if (in>=(1<<144)) out <= (1<<144);
else if (in>=(1<<143)) out <= (1<<143);
else if (in>=(1<<142)) out <= (1<<142);
else if (in>=(1<<141)) out <= (1<<141);
else if (in>=(1<<140)) out <= (1<<140);
else if (in>=(1<<139)) out <= (1<<139);
else if (in>=(1<<138)) out <= (1<<138);
else if (in>=(1<<137)) out <= (1<<137);
else if (in>=(1<<136)) out <= (1<<136);
else if (in>=(1<<135)) out <= (1<<135);
else if (in>=(1<<134)) out <= (1<<134);
else if (in>=(1<<133)) out <= (1<<133);
else if (in>=(1<<132)) out <= (1<<132);
else if (in>=(1<<131)) out <= (1<<131);
else if (in>=(1<<130)) out <= (1<<130);
else if (in>=(1<<129)) out <= (1<<129);
else if (in>=(1<<128)) out <= (1<<128);
else if (in>=(1<<127)) out <= (1<<127);
else if (in>=(1<<126)) out <= (1<<126);
else if (in>=(1<<125)) out <= (1<<125);
else if (in>=(1<<124)) out <= (1<<124);
else if (in>=(1<<123)) out <= (1<<123);
else if (in>=(1<<122)) out <= (1<<122);
else if (in>=(1<<121)) out <= (1<<121);
else if (in>=(1<<120)) out <= (1<<120);
else if (in>=(1<<119)) out <= (1<<119);
else if (in>=(1<<118)) out <= (1<<118);
else if (in>=(1<<117)) out <= (1<<117);
else if (in>=(1<<116)) out <= (1<<116);
else if (in>=(1<<115)) out <= (1<<115);
else if (in>=(1<<114)) out <= (1<<114);
else if (in>=(1<<113)) out <= (1<<113);
else if (in>=(1<<112)) out <= (1<<112);
else if (in>=(1<<111)) out <= (1<<111);
else if (in>=(1<<110)) out <= (1<<110);
else if (in>=(1<<109)) out <= (1<<109);
else if (in>=(1<<108)) out <= (1<<108);
else if (in>=(1<<107)) out <= (1<<107);
else if (in>=(1<<106)) out <= (1<<106);
else if (in>=(1<<105)) out <= (1<<105);
else if (in>=(1<<104)) out <= (1<<104);
else if (in>=(1<<103)) out <= (1<<103);
else if (in>=(1<<102)) out <= (1<<102);
else if (in>=(1<<101)) out <= (1<<101);
else if (in>=(1<<100)) out <= (1<<100);
else if (in>=(1<<99)) out <= (1<<99);
else if (in>=(1<<98)) out <= (1<<98);
else if (in>=(1<<97)) out <= (1<<97);
else if (in>=(1<<96)) out <= (1<<96);
else if (in>=(1<<95)) out <= (1<<95);
else if (in>=(1<<94)) out <= (1<<94);
else if (in>=(1<<93)) out <= (1<<93);
else if (in>=(1<<92)) out <= (1<<92);
else if (in>=(1<<91)) out <= (1<<91);
else if (in>=(1<<90)) out <= (1<<90);
else if (in>=(1<<89)) out <= (1<<89);
else if (in>=(1<<88)) out <= (1<<88);
else if (in>=(1<<87)) out <= (1<<87);
else if (in>=(1<<86)) out <= (1<<86);
else if (in>=(1<<85)) out <= (1<<85);
else if (in>=(1<<84)) out <= (1<<84);
else if (in>=(1<<83)) out <= (1<<83);
else if (in>=(1<<82)) out <= (1<<82);
else if (in>=(1<<81)) out <= (1<<81);
else if (in>=(1<<80)) out <= (1<<80);
else if (in>=(1<<79)) out <= (1<<79);
else if (in>=(1<<78)) out <= (1<<78);
else if (in>=(1<<77)) out <= (1<<77);
else if (in>=(1<<76)) out <= (1<<76);
else if (in>=(1<<75)) out <= (1<<75);
else if (in>=(1<<74)) out <= (1<<74);
else if (in>=(1<<73)) out <= (1<<73);
else if (in>=(1<<72)) out <= (1<<72);
else if (in>=(1<<71)) out <= (1<<71);
else if (in>=(1<<70)) out <= (1<<70);
else if (in>=(1<<69)) out <= (1<<69);
else if (in>=(1<<68)) out <= (1<<68);
else if (in>=(1<<67)) out <= (1<<67);
else if (in>=(1<<66)) out <= (1<<66);
else if (in>=(1<<65)) out <= (1<<65);
else if (in>=(1<<64)) out <= (1<<64);
else if (in>=(1<<63)) out <= (1<<63);
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
else if (in>=(1<<9)) out <= (1<<9);
else if (in>=(1<<8)) out <= (1<<8);
else if (in>=(1<<7)) out <= (1<<7);
else if (in>=(1<<6)) out <= (1<<6);
else if (in>=(1<<5)) out <= (1<<5);
else if (in>=(1<<4)) out <= (1<<4);
else if (in>=(1<<3)) out <= (1<<3);
else if (in>=(1<<2)) out <= (1<<2);
else if (in>=(1<<1)) out <= (1<<1);
else if (in>=(1<<0)) out <= (1<<0);
else                  out <= 0;
end

endmodule