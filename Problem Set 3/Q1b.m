%-- Setup for simulation 
fs = 1000; %Sampling frequency 
Ts=1/fs; 
t= 0:Ts:4;  % Time vector from 0 to 4 seconds 

%%--Create the signal 
x = sinc (100*(t-2));

%---- Plot the sepctrum 
plotspec(x, Ts);
title('Numerical Spectrum of x(t)= sinc (100(t-2))');