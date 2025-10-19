Ts= 0.001;
t=-2:Ts:5;

figure('Name','Plots of CT Signals');

subplot(4,2,1);
x1=(t>=0);
plot(t,x1);
title('x_1(t)=u(t)');
xlabel('Time(s)');
ylabel('Amplitude');
axis([-2 5 -0.5 1.5]);
grid on;

%x2
subplot(4,2,2);
x2=(t>=0) -(t>=1);
plot(t,x2);
title('x_2(t)=u(t)-u(t-1)');
xlabel('Time(s)');
ylabel('Amplitude');
axis([-2 5 -0.5 1.5]);
grid on;

%x3
subplot(4,2,3);
x3=exp(-t) .* (t>=0);
plot(t,x3);
title('x_3(t) = e^{-t}u(t)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([-2 5 -0.5 1.5]);
grid on;

%x4
subplot(4,2,4);
x4=cos(2*pi*t) .* (t>=0);
plot(t,x4);
title('x_4(t) = cos(2\pit)u(t)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([-2 5 -1.5 1.5]);
grid on;

%x5
subplot(4,2,5);
x5=(1-exp(-2*t)) .* exp(-t) .*(t>=0);
plot(t,x5);
title('x_5(t) = (1 - e^{-2t})e^{-t}u(t)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([-2 5 -0.1 0.5]);
grid on;

%x6 
subplot(4,2,6);
x6=cos(2*pi*t) .*exp(-t) .* (t>=0);
plot(t,x6);
title('x_6(t) = cos(2\pit)e^{-t}u(t)');
xlabel('Time (s)');
ylabel('Amplitude');
axis([-2 5 -1.5 1.5]);
grid on;

%x7
subplot(4,2,7);
x7=2*rand(size(t))-1;
plot(t,x7);
title('x_7(t) = Uniform Random Signal, |x_7(t)| \leq 1');
xlabel('Time (s)');
ylabel('Amplitude');
axis([-2 5 -1.5 1.5]);
grid on;