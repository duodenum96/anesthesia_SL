%% Tracking script

[x, y, others, time] = SL_tracking;

figure;
subplot(6,1,1)
plot(time, x)

subplot(6,1,2)
plot(time, y)

subplot(6,1,3)
plot(time, others.dx)

subplot(6,1,4)
plot(time, others.dy)

subplot(6,1,5)
plot(time, others.r)

subplot(6,1,6)
plot(time, others.phi)

figure;
plot(others.r, others.phi)
%% 

dt = 0.1/1000;
t = 300;
% noise = cumsum(randn([t/dt 1]));
% noise = 10000*pinknoise([t/dt 1]);
str = 10;
generator = dsp.ColoredNoise('Color', 'brown', 'SamplesPerFrame', 300/(0.1/1000)+1, 'BoundedOutput', true);
noise = generator();
noise = ((noise - min(noise)) / (max(noise) - min(noise))) * (str - (-str)) + (-str);

[x, y, others, time] = SL_tracking("I", noise);
plot(x,y)
plot(time, -others.phi)
hold on
plot(time, noise)
plot(-others.phi, noise)

figure;
subplot(6,1,1)
plot(time, x)

subplot(6,1,2)
plot(time, y)

subplot(6,1,3)
plot(time, others.dx)

subplot(6,1,4)
plot(time, others.dy)

subplot(6,1,5)
plot(time, others.r)

subplot(6,1,6)
plot(time, others.phi)

figure;
plot(others.r, others.phi)
plot(time(1:end-1), noise)
plot(sqrt(time), others.phi)
%%

dt = 0.1/1000;
t = 300;
noise = randn([t/dt 1]);

[x, y, others, time] = SL_tracking("I", noise);

figure;
subplot(6,1,1)
plot(time, x)

subplot(6,1,2)
plot(time, y)

subplot(6,1,3)
plot(time, others.dx)

subplot(6,1,4)
plot(time, others.dy)

subplot(6,1,5)
plot(time, others.r)

subplot(6,1,6)
plot(time, others.phi)

figure;
plot(others.r, others.phi)
plot(time(1:end-1), noise)