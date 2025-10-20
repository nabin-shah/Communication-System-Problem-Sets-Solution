clear; clc; close all;

%---------Parameters 
Ts= 0.001;
time_range = 0.1; 
t=0:Ts:time_range-Ts; %Time vector 

f_vals=[400, 450,500,550,600]; 

% figure('Name', 'Sampling and Aliasing');
for i=1:length(f_vals)
    f0=f_vals(i);
    y=cos(2*pi*f0*t); %Generate the cosine wave

    figure;
    plotspec(y,Ts); 

    %Add an informative title to each plot 
    title_str=sprintf('Input f= %d Hz', f0);

    %Check for aliasing to add the titile 
    nyquist_freq= 1/(2*Ts);

    if f0> nyquist_freq
        alias_freq = abs (f0-round(f0/(1/Ts))*(1/Ts));
        title_str=[title_str,sprintf('(Aliases to +/- %d Hz)', alias_freq)];
    elseif f0== nyquist_freq 
        title_str=[title_str, '(At Nyquist Frequency)'];

    end
    title(title_str);
end