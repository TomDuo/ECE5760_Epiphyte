% ECE 5760 Lab 3 Code
% Authors: Connor Archard
%          Noah Levy
%
% Recording and plotting output of audio codec

close all
clear
clc

recDuration = 3;
inputDevice = 3;
sampleRate  = 44100;
nBits       = 16;
nChannels   = 2;
recObj = audiorecorder(sampleRate,nBits,nChannels);

fprintf('Start Recording\n')
recordblocking(recObj,recDuration);
fprintf('Done Recording\n')

figure(1);
waveform = getaudiodata(recObj);
plot(waveform)
figure(2)
Fs = sampleRate
Hs=spectrum.welch('Hamming',2048,50);
psd(Hs,waveform,'Fs',Fs)
title('Power Spectrum of Simulated Noise')
set(gca,'xlim',[0 1])
xlabel('Freq - Hz')
ylabel('Power dB')
