clear;
close all;
clc;

sosSize = [2 6];
fs=48e3;
fc=20;
   % fprintf('\n%i: begin\n\n',fIndex-1);
[z,p,k] = ellip(4,2,40,fc/fs);
soshi = zp2sos(z,p,k);

    sosSize = size(soshi);
    for y = 1:sosSize(1)
        for x = 1:sosSize(2)
            fprintf('sosMat[%i][%i] <= 27''h%s;\n',y-1,x-1,dec2hex(float_2_fix4_23(soshi(y,x))));
        end
    end


fprintf('endcase');
h=fvtool(soshi);


2