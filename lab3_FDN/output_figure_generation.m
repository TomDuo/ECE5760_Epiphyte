% ECE 5760 Lab 3 Code
% Authors: Connor Archard
%          Noah Levy
%
% Recording and plotting output of audio codec

close all
clc

recDuration = 5;
inputDevice = 3;
sampleRate  = 44100;
nBits       = 16;
nChannels   = 2;
recObj = audiorecorder(sampleRate,nBits,nChannels,inputDevice);

fprintf('Start Recording')
recordblocking(recObj,recDuration);
fprintf('Done Recording')

waveform = getaudiodata(recObj);

figure(1)
Pxx = pwelch(waveform);
title('Power Spectrum of Simulated Noise')
xlable('Freq - Hz')
ylabel('Power dB')
