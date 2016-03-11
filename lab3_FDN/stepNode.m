close all
clear all

stepMode = 1;
plotMode = 1;
eta = 0.0078;
rho = 0.5;
uN  = 0;
uW  = 0;
uE  = 0;
uS  = 0;


uprev = 0;
u = .125;

oneMinusEta = 1-eta;
cycleNum = 0
limit = 20;
y = [u];
mul1s = [];
mul2s = [];
mul3s = [];

while cycleNum <  limit
    mul1 = rho*(uN+uS+uW+uE - 4*u);
    mul1s = [mul1s mul1];
    cycleNum=cycleNum+1;
    
    %pause;
    mul2 = (1-eta)*mul1;
    mul2s = [mul2s mul2];

    cycleNum=cycleNum+1;
    
    %pause;
    mul3 =  (1-eta)*uprev;
    mul3s = [mul3s mul3];
    cycleNum=cycleNum+1;
    
    %pause;
    uprev = u;
    u = mul2 + 2*u - mul3;
    cycleNum=cycleNum+1;
    
    %pause;
    y = [y u];
    cycleNum=cycleNum+1;
end

plot(y)