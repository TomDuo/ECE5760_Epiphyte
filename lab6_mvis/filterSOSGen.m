clear;
close all;
clc;
lb = 10.*1.8.^[6:12];
ub= 10.*1.8.^[7:13];
sosSize = [2 6];
fs=48e3;
fprintf('\n\n\nreg signed [26:0] sosMat [0:%i][0:5];\n\n',sosSize(1)-1);;

fprintf('case(filterID)\n\n');

sosMats = {1,length(lb)};
for fIndex = 1:length(lb)
    fprintf('\n%i: begin\n\n',fIndex-1);
    [z,p,k] = butter(2,[lb(fIndex)/fs ub(fIndex)/fs]);
    %[z,p,k] = cheby1(2,1,[lb(fIndex)/fs ub(fIndex)/fs]);
    %[z,p,k] = ellip(2,1,30,[lb(fIndex)/fs ub(fIndex)/fs]);

    soshi = zp2sos(z,p,k);

    %plot(n,x,n,y,n,yf1,n,yf2);

    sosSize = size(soshi);
    for y = 1:sosSize(1)
        for x = 1:sosSize(2)
            fprintf('sosMat[%i][%i] <= 27''h%s;\n',y-1,x-1,dec2hex(float_2_fix4_23(soshi(y,x))));
        end
    end
    fprintf('end\n');
    sosMats{fIndex} = soshi;
end


fprintf('endcase');
h=fvtool(sosMats{1},sosMats{2},sosMats{3},sosMats{4},sosMats{5},sosMats{6},sosMats{7});
set(h,'DesignMask','off'); % Turn off design mask
hchildren = get(h,'children');
haxes = hchildren(strcmpi(get(hchildren,'type'),'axes'));
hline = get(haxes,'children');
set(hline,'linewidth',2)

legend('340-612Hz','612-1102Hz','1102-1986Hz','1986-3570Hz','3570-6427Hz','6427-11568Hz','11568-20823Hz');
xlim([0 20e3/48e3]);
title('Logarithmically Spaced, 2nd order Band Pass Filters');

