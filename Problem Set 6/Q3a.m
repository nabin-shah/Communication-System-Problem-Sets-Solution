% ## Part a: Generate pulse-shaped signal 

%Short 4-PAM message 
m= letters2pam('Hello');    % Convert to 4-PAM symbols {-3, -1, 1, +3}

% Parameters 
M= 100;             % Oversampling factor (samples per symbol)
T=1;                %# Symbol period 


% Generate pulse shape: Hamming blip 
ps= hamming(M);


% Oversample the sysmbols 
mup = zeros(1, length(m)*M); 
mup(1:M:end)=m;         % Place symbols at M intervals

% Pulse shaping (convolve) 
x= filter(ps, 1,mup);   %# Transmitted pulse shaped signal 

% Inspect signal and spectrum 
figure;
plotspec(x, 1/M);
title('Pulse-Shaped 4-PAM signal with Hamming Blip');