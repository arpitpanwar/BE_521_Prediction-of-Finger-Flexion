function Hd = FilterDesign_Equiripple_FIR(start,stop)
%FILTERDESIGN_EQUIRIPPLE_FIR Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.0 and the DSP System Toolbox 9.2.
% Generated on: 16-Apr-2016 19:32:09

% Equiripple Bandpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 2000;  % Sampling Frequency

N      = 10;   % Order
Fstop1 = start-1;    % First Stopband Frequency
Fpass1 = start;    % First Passband Frequency
Fpass2 = stop;  % Second Passband Frequency
Fstop2 = stop+1;  % Second Stopband Frequency
Wstop1 = 1;    % First Stopband Weight
Wpass  = 3;    % Passband Weight
Wstop2 = 1;    % Second Stopband Weight
dens   = 20;   % Density Factor

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, [0 Fstop1 Fpass1 Fpass2 Fstop2 Fs/2]/(Fs/2), [0 0 1 1 0 ...
           0], [Wstop1 Wpass Wstop2], {dens});
Hd = dfilt.dffir(b);

% [EOF]
