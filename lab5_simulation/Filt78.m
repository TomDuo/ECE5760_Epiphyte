function Hd = Filt78
%FILT78 Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 8.3 and the Signal Processing Toolbox 6.21.
% Generated on: 15-Apr-2016 15:07:07

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are normalized to 1.

Fpass = 0.17948717949;   % Passband Frequency
Fstop = 0.25641025641;   % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.001;           % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop], [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
