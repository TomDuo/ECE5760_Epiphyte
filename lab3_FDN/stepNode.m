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
buprev = uprev;
u = .125;
bu = u;

oneMinusEta = 1-eta;
cycleNum = 0
limit = 16000;
y=[]
mul1s = [];
mul2s = [];
mul3s = [];

while cycleNum <  limit
    y = [y u];
    mul1 = rho*(uN+uS+uW+uE - 4*u)
    mul1s = [mul1s mul1];
    cycleNum=cycleNum+1
    
    %pause;
    mul2 = (1-eta)*uprev
    mul2s = [mul2s mul2];

    cycleNum=cycleNum+1
    
    %pause;
    mul3 =  (1-eta)*(mul1 + 2*u - mul2);
    mul3s = [mul3s mul3];
    cycleNum=cycleNum+1
    
    %pause;
    uprev = u
    u = mul3;
    cycleNum=cycleNum+1
    
    %pause;

end
bruce_y = [];
for n=1:length(y)
    bruce_y = [bruce_y bu];
    
    bu_prime = 1/(1+eta) * (...
              rho * (uN+uS+uW+uE - 4*bu) ...
              + 2 * bu ...
              - (1-eta) * buprev);
     buprev = bu;
     bu = bu_prime;
          
end

single =csvread('single.csv');
t = 1:length(y);

plot(t,y,t,single,'r-.',t,bruce_y,'g')
legend('matlab','iverilog','bruce');
xlim([0,500]);

sound(single,8000);