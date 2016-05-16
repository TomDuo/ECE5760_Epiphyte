clear;
close all;
lb = 10.*3.^[0:6];
ub= 10.*3.^[1:7];

fs=48e3;

fIndex = 5;
ftarget = 1000;
maxlen = 2e3;
n = 1:maxlen;
x = .9*sin(2*pi*ftarget/fs*n);
[z,p,k] = butter(2,[lb(fIndex)/fs ub(fIndex)/fs]);
soshi = zp2sos(z,p,k);
[b,a] = zp2tf(z,p,k);
y = sosfilt(soshi,x);
yf1 = zeros(1,maxlen);
yf2 = zeros(1,maxlen);

for ind=10:maxlen;
    yf1(ind) = soshi(1,1)*x(ind) + soshi(1,2)*x(ind-1) + soshi(1,3)*x(ind-2) -  soshi(1,5)*x(ind-1) - soshi(1,6)*x(ind-2);
    yf2(ind) =  soshi(2,1)*yf1(ind) + soshi(2,2)*yf1(ind-1) + soshi(2,3)*yf1(ind-2) -  soshi(2,5)*yf1(ind-1) - soshi(2,6)*yf1(ind-2);
end
plot(n,x,n,y,n,yf1,n,yf2);

    sosSize = size(soshi);
    fprintf('reg signed [26:0] sosMat [0:%i][0:5];\n\n',sosSize(1));;
        for y = 1:sosSize(1)
                for x = 1:sosSize(2)
                fprintf('sosMat[%i][%i] = 27''h%s;\n', y-1,x-1,dec2hex(float_2_fix4_23(soshi(y,x))));
        end
    end

