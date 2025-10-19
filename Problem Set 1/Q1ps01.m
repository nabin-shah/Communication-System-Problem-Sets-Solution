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
subplot