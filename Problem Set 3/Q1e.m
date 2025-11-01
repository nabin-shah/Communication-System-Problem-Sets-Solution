% --- MATLAB/Octave Script for Part (e): High-Side Injection ---

clear; close all;

% --- 1. Define Signal Parameters ---
fc = 1000;         % Carrier frequency in Hz
f_if = 200;          % Target Intermediate Frequency in Hz
f_baseband_max = 50; % Max frequency of our baseband sinc signal in Hz

% --- 2. Define Simulation Parameters ---
% Let's use the same fs = 5000 Hz as before.
fs = 5000;         % Sampling frequency (Hz)
Ts = 1/fs;         % Sampling interval (sec)
t = 0:Ts:4;        % Time vector from 0 to 4 seconds

disp('Parameters set. Sampling at 5000 Hz.');

% --- 3. Create the original RF signal y(t) from part (c) ---
disp('Generating RF signal y(t)...');
x_baseband = sinc(100*(t-2));     % Baseband signal
c_rf = cos(2*pi*fc*t);            % 1000 Hz Carrier
y_rf = x_baseband .* c_rf;        % Modulated RF signal

% --- 4. Perform High-Side Injection Downconversion ---
disp('Performing high-side injection...');
f_lo_hi = fc + f_if;   % 1000 + 200 = 1200 Hz
c_hi = cos(2*pi*f_lo_hi*t);  % 1200 Hz Local Oscillator
w_hi = y_rf .* c_hi;         % The new downconverted signal

% --- 5. Plot the results using your plotspec.m ---
disp('Plotting spectrum of downconverted signal...');
figure;
plotspec(w_hi, Ts);

% Manually adjust the title on the bottom plot for clarity
subplot(2,1,2);
title('(e) Spectrum after High-Side Injection (f_{LO} = 1200 Hz)');
% Set x-axis limits to clearly see all components
xlim([-fs/2, fs/2]);