% --- MATLAB/Octave Script for Low-Pass Filter Design ---

clear; clc; close all;

%----1. Set up parameters 
f1=100 ; % Frequency of the first signal 
f2= 300; % Frequency of the second signal 

%To sample this, our sampling frequency fs must be more than 2 * highest frequency 
% 2 * 300 = 600, Let's use 1000 Hz 
fs= 1000; 
Ts = 1/fs; 
t= 0:Ts:(2-Ts);     % Create 2 seconds of time 

disp('--- Step 1 & 2: Setup and Signal Creation');
disp(['Sampling at ', num2str(fs), ' Hz']);


%-- 2. Create the input signal x(t)
x = cos(2*pi*f1*t) + cos(2*pi*f2*t);

%--3. Plot the spectrum of the input signal x(t)
figure;
plotspec(x,Ts);
title('Signal before fitler: x(t) = cos(2\pi100t) + cos(2\pi300t)');
xlim([-fs/2,fs/2]);

%--- 4. Design the Low-Pass Filter
disp('Designing the 200 Hz LPF...');

% Frequencies are normalized by Nyquist (fs/2) 
f_edge= [0,150,250, 500] / (fs/2);   % F= [0, 0.3, 0.5, 1.0]
a_edge = [1,1,0,0];         % A= [1,1,0,0] 

% N = filter order (length-1)
% A larger N gives a sharper, better filter 
N_order = 50 ;

% Design the filter 'b', (the impulse response)
b =firpm(N_order,f_edge,a_edge);

disp('Filter "b" has been designed. ');

% -- Plot the filter's frequency response --- 
% 'freqz' plots the shape of the filter we just designed
figure;
freqz(b,1,512,fs);  % Plot with 512 points, points scaled to fs
title('LPF Frequency Response')

%---- 5. FIlter the signal x(t) with our LPF 'b'
disp('Filtering the signal....');

% 'filter' is the command to run the signal,x, through our FIR filter 'b'
% (The '1' is for IIR filters, so we just leave it as 1).

y=filter(b,1,x);

disp('Signal has been filtered. Output is y.');

figure;
plotspec(y,Ts);     % Plot the time and frequency of the output 
title('Filtered Signal y(t) = LPF {x(t) = cos(2\pi100t)}');
xlim([-fs/2,fs/2]);


