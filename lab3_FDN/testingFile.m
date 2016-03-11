close all
clear all

eta = 0.005;
rho = 0.5;
uN  = 0;
uW  = 0;
uE  = 0;
uS  = 0;
numtSteps = 200;
y = [];
uPrev = 0;
uCurrent = -1;

for t=1:numtSteps    
    y = [y uCurrent];
    uNext = (1-eta)*(rho*(uN+uS+uE+uW-4*uCurrent))+2*uCurrent - (1-eta)*uPrev;
    uPrev = uCurrent;
    uCurrent = uNext;
end

figure(1)
plot(1:numtSteps,y)

