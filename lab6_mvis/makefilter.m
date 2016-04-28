% filter generation

fs = 48000;

lb = 10000;
ub = 20000;

[b,a] = butter(1,[2*lb/fs 2*ub/fs])

impulse = [zeros(1,1000) 1 zeros(1,1000)];

%Y = fftshift(fft(filter(b,a,impulse)));
close all
h = fvtool(b,a);
%semilogy(linspace(0,1,2001),Y)