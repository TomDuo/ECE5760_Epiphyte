clear;
[x, fs] = audioread('transformers_cut.wav');
fs = 48e3;
ftarget = 10;
maxlen = 5e4;
n = 1:maxlen;
x = .5*sin(2*pi*ftarget/fs*n);%+.5*sin(2*pi*5000/fs*n);
assert(fs==48e3,'We DUMB');

x = (x*(2^15));
x= round(x);
fid = fopen('testVect.v','w');
fprintf(fid, ['module testVect (\n' ...
    'output reg signed [15:0] aud [0:%i]\n);\n\n'], maxlen-1);

fprintf(fid,'initial begin\n');
for n=0:maxlen-1
    fprintf(fid,'aud[%i]=16''h%x;\n',n,typecast(int16(x(n+1)),'uint16'));
end
fprintf(fid,'\nend\n');
fprintf(fid,'\n\nendmodule');
fclose(fid);3