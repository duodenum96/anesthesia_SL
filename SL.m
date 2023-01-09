function [x, y, time] = SL(lambda, omega, gamma, dt, t, opts)
%% Simulate Stuart-Landau coupled oscillators
% lambda: Coupling parameter
% omega: Natural frequency ın Hz
% gamma: 
% dt: Timestep (s)
% t: Duration (s)
% I: Input as a time series of equal length, must be passed as name-value "I", ...
arguments
    lambda = 0.1;
    omega = 0.05;
    gamma = 1;
    dt = 0.1/1000;
    t = 100;
    opts.I = zeros(t/dt, 1);
end
I = opts.I;
omega = 2*pi*omega;
x = zeros([t/dt 1]); x(1) = 1;
y = zeros([t/dt 1]); y(1) = 1;
time = 0:dt:t;

for t = 2:length(time)
    dx = lambda * x(t-1) - omega * y(t-1) - gamma * (x(t-1)^2 + y(t-1)^2) * x(t-1) + I(t-1);
    dy = lambda * y(t-1) + omega * x(t-1) - gamma * (x(t-1)^2 + y(t-1)^2) * y(t-1);
    x(t) = x(t-1) + dt * dx;
    y(t) = y(t-1) + dt * dy;
end

% % Take only the stable part
% % x = x(round(length(time)/10):end);
% % y = y(round(length(time)/10):end);
% % time = time(round(length(time)/10):end);
end