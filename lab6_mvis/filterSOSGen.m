clear;
close all;
clc;
lb = 10.*1.8.^[6:12];
ub= 10.*1.8.^[7:13];
sosSize = [2 6];
fs=48e3;
fprintf('\n\n\nreg signed [26:0] sosMat [0:%i][0:5];\n\n',sosSize(1)-1);;

fprintf('case(filterID)\n\n');

for fIndex = 1:length(lb)
    fprintf('\n%i: begin\n\n',fIndex-1);
    [z,p,k] = butter(2,[lb(fIndex)/fs ub(fIndex)/fs]);
    soshi = zp2sos(z,p,k);

    %plot(n,x,n,y,n,yf1,n,yf2);

    sosSize = size(soshi);
    for y = 1:sosSize(1)
        for x = 1:sosSize(2)
            fprintf('sosMat[%i][%i] <= 27''h%s;\n',y-1,x-1,dec2hex(float_2_fix4_23(soshi(y,x))));
        end
    end
    fprintf('end\n');
end
fprintf('endcase');
