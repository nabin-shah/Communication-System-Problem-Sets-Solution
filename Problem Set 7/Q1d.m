% impsys_octave_fixed.m - Impairments to the receiver (FIXED)
% Based on SRD Chapter 9.4

pkg load signal

clear all
close all
addpath('../')

%% ===== USER INPUT: SELECT IMPAIRMENTS =====
printf('\n=== IMPAIRMENT SIMULATION ===\n');
printf('Enter impairment parameters:\n\n');

% Channel noise gain
printf('Channel noise gain (0=none, 0.6=mild, 2=harsh): ');
cng = input('');
if isempty(cng), cng = 0; end

% Channel multipath
printf('Channel multipath (0=none, 1=mild, 2=harsh): ');
cdi = input('');
if isempty(cdi), cdi = 0; end

% Frequency offset
printf('Carrier frequency offset in percent (0=none, 0.01=small): ');
fo = input('');
if isempty(fo), fo = 0; end

% Phase offset
printf('Carrier phase offset in radians (0=none, 0.7, 0.9, pi/2): ');
po = input('');
if isempty(po), po = 0; end

% Timing offset
printf('Baud timing offset as percent of symbol period (0=none, 20, 30): ');
toper = input('');
if isempty(toper), toper = 0; end

% Symbol period offset
printf('Symbol period offset (0=none, 1=offset): ');
so = input('');
if isempty(so), so = 0; end

%% ===== TRANSMITTER (from idsys.m) =====
str='01234 I wish I were an Oscar Meyer wiener 56789';
m=letters2pam(str);
N=length(m);
M=100;                    % oversampling factor
mup=zeros(1,N*M);
mup(1:M:N*M)=m;
p=hamming(M);
x=filter(p,1,mup);
t=1/M:1/M:length(x)/M;
fc=20;                    % carrier frequency

% Apply frequency offset and phase offset to TRANSMITTER
c=cos(2*pi*fc*(1+fo/100)*t + po);
r=c.*x;

%% ===== CHANNEL IMPAIRMENTS =====

% 1. MULTIPATH INTERFERENCE
if cdi < 0.5
    mc = [1 0 0];         % distortion-free channel
elseif cdi < 1.5
    % Mild multipath
    mc = [1, zeros(1,M), 0.28, zeros(1,round(2.3*M)), 0.11];
else
    % Harsh multipath
    mc = [1, zeros(1,M), 0.28, zeros(1,round(1.8*M)), 0.44];
end
mc = mc / sqrt(mc*mc');   % normalize channel power
dv = filter(mc, 1, r);    % filter signal through channel

% 2. ADDITIVE GAUSSIAN NOISE
nv = dv + cng * randn(size(dv));

% 3. TIMING OFFSET - FIXED TO AVOID OUT OF BOUNDS
to = floor(0.01*toper*M); % fractional period delay

% Make sure we don't go out of bounds
max_index = min(length(nv), N*M + to);
if (1+to) <= length(nv) && max_index > to
    r_received = nv(1+to:max_index);
else
    r_received = nv;  % No timing offset if it would cause error
    to = 0;
    printf('Warning: Timing offset too large, using to=0\n');
end

%% ===== RECEIVER =====

% Adjust for symbol period offset
M_rx = M - so;            % receiver uses different M

% 4. TIME VECTOR FOR RECEIVER (synchronized with received signal)
t_rx = 1/M:1/M:length(r_received)/M;

% Demodulation - receiver doesn't know about transmitter offsets
c2 = cos(2*pi*fc*t_rx);
x2 = r_received .* c2;

% LPF parameters
fl=50;
fbe=[0 0.1 0.2 1];
damps=[1 1 0 0];
b=firpm(fl,fbe,damps);
x3=2*filter(b,1,x2);

% Pulse correlation filter
y=filter(fliplr(p)/(sum(p.^2)*M),1,x3);

% Downsample to symbol rate (using receiver's M_rx)
% Make sure we don't exceed array bounds
start_idx = floor(0.5*fl+M_rx);
end_idx = length(y);
if start_idx > 0 && start_idx <= end_idx
    indices = start_idx:M_rx:end_idx;
    z = y(indices);
else
    z = y(M_rx:M_rx:end);  % Fallback
end

% Truncate to match message length
z = z(1:min(length(z), N));

%% ===== ANALYSIS AND PLOTTING =====

% Decision device
mprime=quantalph(z,[-3,-1,1,3])';
cvar=(mprime-z)*(mprime-z)'/length(mprime);
lmp=length(mprime);
pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp;

% Display results
printf('\n=== IMPAIRMENTS APPLIED ===\n');
printf('Channel Noise Gain: %.2f\n', cng);
printf('Multipath (0/1/2): %d\n', round(cdi));
printf('Frequency Offset: %.4f%%\n', fo);
printf('Phase Offset: %.4f rad (%.1f deg)\n', po, po*180/pi);
printf('Timing Offset: %.1f%%\n', toper);
printf('Period Offset: %d\n', so);

printf('\n=== RESULTS ===\n');
printf('Cluster variance: %.6f\n', cvar);
printf('Symbol error rate: %.2f%%\n', pererr);
reconstructed_message=pam2letters(mprime);
printf('Reconstructed: %s\n', reconstructed_message);

%% ===== PLOTTING =====

% PLOT 1: Soft Decisions (Constellation)
figure(1)
plot(1:length(z), z, 'b.', 'MarkerSize', 8)
hold on
plot(1:length(mprime), mprime, 'ro', 'MarkerSize', 4)
title('Constellation Diagram: Soft and Hard Decisions')
xlabel('Symbol Index')
ylabel('Amplitude')
legend('Soft Decisions', 'Hard Decisions', 'Location', 'best')
grid on
% Add horizontal lines at ideal symbol values
plot([0 length(z)], [-3 -3], 'k--', 'LineWidth', 0.5)
plot([0 length(z)], [-1 -1], 'k--', 'LineWidth', 0.5)
plot([0 length(z)], [1 1], 'k--', 'LineWidth', 0.5)
plot([0 length(z)], [3 3], 'k--', 'LineWidth', 0.5)
hold off

% PLOT 2: Eye Diagram
figure(2)
tstep = 4*M;
start_eye = floor(0.5*fl+M);
if start_eye > 0 && start_eye < length(y)
    ul = floor((length(y)-start_eye)/tstep);
    if ul > 0
        eyedata = reshape(y(start_eye:(start_eye+ul*tstep-1)), tstep, ul);
        plot(eyedata)
        title('Eye Diagram')
        xlabel('Samples per 4 Symbols')
        ylabel('Amplitude')
        grid on
    end
end

% PLOT 3: Histogram of Soft Decisions
figure(3)
hist(z, 50)
title('Distribution of Soft Decisions')
xlabel('Amplitude')
ylabel('Count')
grid on
hold on
% Add vertical lines at ideal symbol values
ylims = ylim();
plot([-3 -3], ylims, 'r--', 'LineWidth', 2)
plot([-1 -1], ylims, 'r--', 'LineWidth', 2)
plot([1 1], ylims, 'r--', 'LineWidth', 2)
plot([3 3], ylims, 'r--', 'LineWidth', 2)
legend('Soft Decisions', 'Ideal -3', 'Ideal -1', 'Ideal +1', 'Ideal +3')
hold off

% PLOT 4: Time-domain received signal (first 500 samples)
figure(4)
subplot(2,1,1)
plot(r_received(1:min(500,length(r_received))))
title('Received Signal (time domain, first 500 samples)')
xlabel('Sample Index')
ylabel('Amplitude')
grid on

subplot(2,1,2)
plotspec(r_received, 1/M)
title('Received Signal Spectrum')

% PLOT 5: Scatter plot for multipath visualization
if cdi > 0
    figure(5)
    plot(real(z), imag(z), 'b.', 'MarkerSize', 10)
    title('Constellation (if this were QAM)')
    xlabel('In-phase')
    ylabel('Quadrature')
    grid on
end
