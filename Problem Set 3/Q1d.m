clear; close all; 

% --- Define signal Parameters --
fc = 1000;  % Carrier frequency in Hz 
f_if = 200;   % Target Intermediate Freqnecy in Hz 
f_baseband_max= 50; % Max frequency of our baseband sinc in Hz 

%--- Define Simulation Parameters 
fs= 5000;   %Sampling frequency (Hz)
Ts= 1/fs; 
t=0:Ts:4;     %Time vector from 0 to 4 seconds 

disp('Parameters set. Sampling at 5000 Hz');

%3. Create the original RF signal y(t) from part c 
disp('Generating RF signal y(t)...');
x_baseband = sinc(100*(t-2));      %Baseband signal 
c_rf = cos(2*pi*fc*t);             %1000 Hz Carrier 
y_rf = x_baseband .* c_rf;         %Modulated RF signal 


%--4. Perform low-side Injection...  
disp('Peforming low-side Injection');
f_lo_low = fc-f_if;      %1000-200 = 800 Hz
c_lo = cos (2*pi*f_lo_low*t) ; %800 Hz Local Oscillator 
w _lo = y_rf .* c_lo;   % The new downconverted signal 

%----5. Plot the resuls using plotsepc.m 
figure; 
plotspec(w_lo,Ts);

%Manually adjust the title on the bottom plot for clarity 
subplot(2,1,2);
title('(d) Spectrum after Low-Side Injection (f_{LO} = 800 Hz)' );
%Set x-axis limits to clearly see all components 
xlim([-fs/2,fs/2]);