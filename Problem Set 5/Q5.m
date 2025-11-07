% --- MATLAB/Octave Script for Band-Pass Filter Design ---

clear; clc; close all;

%--1. Set up parameters --- 
f1 = 100;   % Frequency 1 
f2 = 300;   % Frequency 2   %% Pass  
f3= 500;    % Frequency 3

% Let's use 2000 Hz as sampling fequency 
fs=2000;
Ts = 1/fs;
t =0:Ts:(2-Ts);     % Create 2 seconds of time

disp('---Step 1 and 2: Setup and Signal Creation');
disp(['Sampling at ', num2str(fs),' Hz']);

%---2. Create the input signal x(t)----
x = cos(2*pi*f1*t) + cos(2*pi*f2*t) + cos(2*pi*f3*t);

%--- 3. Plot the spectrum of the input signal x(t)--
disp('Plotting "Before" spectrum....');

figure;
plotspec(x,Ts);  
title('Signal: x(t) with 3 tones');
subplot(2,1,2);
xlim([-fs/2, fs/2]);

%---4. Design the Band-Pass Filter --- 
disp('Designing the [200, 400] Hz BPF....');

% Frequencies are normalized by Nyquist (fs/2 = 1000 Hz) 
f_nyq = fs/2; 
f_edges = [0, 150, 200, 400, 450, f_nyq] / f_nyq;        % F vector 
a_edges = [0, 0, 1, 1, 0, 0];       % A vector 

% N= fitler order (lengeth - 1);
N_order = 50; 

% Design the filter 'b' (the impulse response)
b = firpm(N_order, f_edges, a_edges); 

disp('Filter, b, has been designed');

% 'freqz' plots the shape of the filter we just designed 
figure;
freqz(b,1,512,fs); % Plot with 512 points, scaled to fs 
title('BPF Frequency Response');

%--- 5. FIlter the signal x(t) with our BPF
disp('Filtering the signal...');

% 'filter' is the command to run the signal x, through our FIR filter b
y=filter(b, 1, x);

disp('Signal has been filtered. Oupt is y.');

%-- 6. Plot the Spectrum of the output signal y(t);
disp('Plotting "After" spectrum...');

figure;
plotspec(y,Ts);
title('Filtered Signal y(t) = cos(2\pi300t)');
subplot(2,1,2);
xlim([-600,600]);

