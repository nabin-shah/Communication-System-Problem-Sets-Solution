clear; close all; 

%------1. Define Signal and simulaiton parameter 
fc=1000;        %Carrier frequency in Hz 
fs= 10 * fc;         % Super-Nyquist sampling freqnecy 
Ts= 1/fs; 
t=0:Ts:4;              % Time vector from 0 to 4 seconds

disp('Parameter set. Sampling at 10000 Hz. ');

%-------2. Create the RF signal y(t)---
disp('Generating RF signal y(t)...');
x_baseband = sinc(100*(t-2));      %Baseband signal 
c_rf = cos(2*pi*fc*t);             % 1000 Hz Carrier 
y_rf= x_baseband .* c_rf;          % Modulated RF signal 

%---3. Plot the spectrum using your plotspec.m---
disp('Plotting spectrum...');
figure;
plotspec(y_rf, Ts);

% Manually adjust the little on the bottom plot for clarity 
subplot(2,1,2);
title('(b) Super-Nyquist Spectrum (f_s = 10 kHz)');
% Set x-axis limits ot clearly see the components 
xlim([-fs/2, fs/2]);
