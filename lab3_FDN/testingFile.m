close all
clear all

eta = 0.0078;
rho = 0.5;
uN  = 0;
uW  = 0;
uE  = 0;
uS  = 0;
numtSteps = 200;
y = [];
uPrev = 0;
uCurrent = -1;
cycleNum = 0;
k=input('\n next? [y/n]\n>','s');
while (strcmp(k,'y'))  
    y = [y uCurrent];
    cycleNum = cycleNum + 1
    sumNeighbors = uN+uS+uE+uW-4*uCurrent
    oneMinusEta = 1-eta
    rhoMultSum = rho*sumNeighbors
    rhoSumMultOneMinusEta = rhoMultSum * oneMinusEta
    u = rhoSumMultOneMinusEta + uCurrent*2 - oneMinusEta*uPrev
    uNext = (1-eta)*(rho*(uN+uS+uE+uW-4*uCurrent))+2*uCurrent - (1-eta)*uPrev;
    uPrev = uCurrent;
    uCurrent = uNext;
    k=input('\n next? [y/n]\n>','s');
end

%figure(1)
%plot(1:numtSteps,y)

