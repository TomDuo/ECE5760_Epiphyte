clear;
[x, fs] = audioread('transformers_cut.wav');

fc=10;
[z,p,k] = butter(2,[1/fs fc/fs]);
soshi = zp2sos(z,p,k);
    
y= sosfilt(soshi,x);
yabs= sosfilt(soshi,abs(x));
n = 1:length(x);
plot(n,x,n,y,n,yabs);