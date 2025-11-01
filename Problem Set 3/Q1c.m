%----Setup for simulaiton 
fc = 1000; %Carrier frequency in Hz
fs= 4000;  % New sampling frequency 
Ts = 1/fs ;    %% Sampling intervel 
t = 0:Ts:4;  % Time vector from 0 to 4 seconds 

%-- Create the baseband signal 
x = sinc(100*(t-2));

% --- Create the RF singal y(t)--
c = cos(2*pi*fc*t);
y=  x .*c ;   % Modulation RF signals 

%--Plot the spectrum 
plotspec(y, Ts);
title('Numberical Spectrum of AM Signal y(t)');
