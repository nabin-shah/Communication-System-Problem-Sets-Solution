clear; clc; close all; 

% --- Define constant that do not change in the loop 
f0 = 5; % inptut signal fequency in Hz 
T= 1; 

%-- Define the carrier freqencies we want to test 
fc_vals = [100, 1000,10000]; % Vector of carrier frequencies in Hz 

for i = 1:length(fc_vals)
    %Get the current carrier frequency for this iteration 
    fc=fc_vals(i); 

    %Step 1: Determine as adequate sampling freqency 
    %To avoid aliasing, Fs must b > 2* highest_freqency. 
    %We'll use a safety factor of 4 a clean plot 
    Fs= 4* (fc+f0);
    Ts = 1/Fs; 
    t=0:Ts:T-Ts; %Time vector depends on Fs, so it's inside the loop

    %--Step 2: Generate signals and mix them 
    x= sin(2*pi*f0*t);
    c=cos(2*pi*fc*t);
    y= x .*c;


    %Step 3 Plot spectrum 
    figure('Name','Mixer Output Spectrum');
    plotspec(y,Ts);

    %--Step 4: Add a descriptive title and adjust axes 
    title_str = sprintf('Spectrum for f_c = %d Hz', fc);
    title(title_str);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');

    % Zoom in on the area of interest around the sidebands 
    xlim_range = fc + 200 ; % Set a viewing window around the carrier 
    xlim([-xlim_range, xlim_range]);
end