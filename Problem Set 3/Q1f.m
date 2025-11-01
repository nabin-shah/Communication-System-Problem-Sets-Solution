% --- MATLAB/Octave Script for Part (f): IF to Baseband ---
clear; close all;

% --- 1. Define Signal and Simulation Parameters (from previous parts) ---
fc = 1000;         % Carrier frequency in Hz
f_if = 200;          % Target Intermediate Frequency in Hz
f_baseband_max = 50; % Max frequency of our baseband sinc signal in Hz
fs = 5000;         % Sampling frequency (Hz)
Ts = 1/fs;         % Sampling interval (sec)
t = 0:Ts:4;        % Time vector from 0 to 4 seconds
disp('Parameters set. Sampling at 5000 Hz.');

% --- 2. Create the RF signal y(t) from part (c) ---
disp('Generating RF signal y(t)...');
x_baseband = sinc(100*(t-2));     % Baseband signal
c_rf = cos(2*pi*fc*t);            % 1000 Hz Carrier
y_rf = x_baseband .* c_rf;        % Modulated RF signal

% --- 3. Create the Low-Side IF Signal w_lo(t) from part (d) ---
disp('Generating low-side IF signal...');
f_lo_low = fc - f_if;  % 800 Hz
c_lo = cos(2*pi*f_lo_low*t); % 800 Hz Local Oscillator
w_lo = y_rf .* c_lo;         % This signal has boxes at +/-200 AND +/-1800

%-- 4. (f) Step 1: Filter w_lo(t) to get a clean IF signal----
% We must firt remove the replicas at +/- 1800 Hz
% LPF cutoff must be > 200+50 Hz and < 1800-50 Hz.
% Let's set cutoff to 300 Hz. 
disp('Filtering to create clean IF signal at +/- 200 Hz....');
f_cutoff_1 = 300; 
% 'butter' designs a Butterworth filter. [b,a] are the filter coefficients
[b1, a1] = butter(6,f_cutoff_1/(fs/2));
y_if=filter(b1,a1,w_lo);

%Plot the spectrum of the clean IF signal 
figure;
% subplot(3,1,1);
plotspec(y_if,Ts);
subplot(2,1,2); %Focus on the bottom(frequency) plot 
title('(f) Step 1: Clean IF Siganl (Replicas at +/- 1800 Hz removed)');
xlim([-1000,1000]);  % Zoom in to the center


%---5. (f) Step 2: Mix the IF signal down to baseband (0 Hz) -- 
disp('Mixing IF signal down to baseband...');
c_baseband = cos(2*pi*f_if*t) ;   %200 Hz
y_mixed = y_if .* c_baseband;   % This signal has boxes at 0Hz and +/-400

%Plot the sepctrum of the mixed signal 
figure;

plotspec(y_mixed,Ts);
subplot(2,1,2);   %Focus on the bottom (frequency) plot 
title('(f) Step 2: Mixed to Baseband(Boxes at 0 Hz) and +/- 400 Hz')
xlim([-1000,1000]);  % Zoom in to the center

%------6. (f) Step 3: Filter y_mixed to get the final baseband signal 
%Remove the replicas at +/- 400 Hz
disp('Filtering to get final reconstructed signal...');
f_cutoff_2= 100;
[b2,a2]= butter(6,f_cutoff_2/(fs/2));
x_reconstructed = filter(b2,a2,y_mixed);

% Plot the spectrum of the final reconstructed signal 
figure;
plotspec(x_reconstructed,Ts);
subplot(2,1,2);  %Focus on the bottom (frequency) plot 
title('(f) Step 3: Reconstructed Baseband Siganl (Box at 0 Hz)');
xlim([-200,200]);    %Zoom in to baseband
