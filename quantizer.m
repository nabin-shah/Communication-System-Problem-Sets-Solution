% This script reproduces the plots from the lecture slide showing
% the effect of a quantizer on a cosine wave.
%
% This version uses the original plotspec.m and quantalph.m from the book.
% It correctly generates a single figure with four subplots.

% --- 1. Define Parameters ---
Ts = 1/8000;                         % Sampling period
t = 0:Ts:2;                          % Time vector from 0 to 2 seconds
alphabet = [-1.2, -0.4, 0.4, 1.2];   % The quantizer's allowed output levels

% --- 2. Generate Signals ---
x_t = cos(2*pi*t);                   % Original signal (a simple cosine wave)
y_t = quantalph(x_t, alphabet);      % The new signal after quantization

% --- 3. Plotting ---
% Create a new figure window to hold all subplots
figure('Name', 'Quantizer Demonstration');

% --- Top-Left Plot: Original signal in the time domain ---
subplot(2,2,1); % Create and activate the top-left subplot
plot(t, x_t, 'LineWidth', 1);
title('Original Signal x(t)');
xlabel('seconds');
ylabel('amplitude');
grid on;
axis([0 2 -1.5 1.5]);

% --- Top-Right Plot: Quantized signal in the time domain ---
subplot(2,2,2); % Create and activate the top-right subplot
plot(t, y_t, 'LineWidth', 1);
title('Quantized Signal y(t)');
xlabel('seconds');
ylabel('amplitude');
grid on;
axis([0 2 -1.5 1.5]);

% --- Bottom-Left Plot: Spectrum of the original signal ---
subplot(2,2,3); % Create and activate the bottom-left subplot
plotspec(x_t, Ts); % plotspec will now draw on this active subplot
title('Spectrum of x(t)');
xlim([-600 600]);

% --- Bottom-Right Plot: Spectrum of the quantized signal ---
subplot(2,2,4); % Create and activate the bottom-right subplot
plotspec(y_t, Ts); % plotspec will now draw on this active subplot
title('Spectrum of y(t)');
xlim([-600 600]);
