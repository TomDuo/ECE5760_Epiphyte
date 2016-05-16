clear;
clc;
MAXLEN = 159;
fprintf('module msbOneHot ( \ninput      [%i:0] in,\n output reg [%i:0] out\n);\n\nalways @(*) begin\n',MAXLEN,MAXLEN);

fprintf('if (in>=(1<<%i)) out <= (1<<%i);\n',MAXLEN,MAXLEN);
for n=MAXLEN-1:-1:0
fprintf('else if (in>=(1<<%i)) out <= (1<<%i);\n',n,n);
end
fprintf('else                  out <= 0;\nend\n\nendmodule\n\n');
    
