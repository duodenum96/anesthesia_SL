function [x, y, others, time] = SL_tracking(lambda, omega, gamma, dt, t, opts)
%% Simulate Stuart-Landau coupled oscillators
% lambda: Coupling parameter
% omega: Natural frequency ın Hz (assume omega = 1)
% gamma: (Assume gamma = 1)
% dt: Timestep (s)
% t: Duration (s)
% I: Input as a time series of equal length, must be passed as name-value "I", ...
arguments
    lambda = 0.1;
    omega = 1;
    gamma = 1;
    dt = 0.1/1000;
    t = 300;
    opts.I = zeros(t/dt, 1);
end
I = opts.I;
omega = 2*pi*omega;
x = zeros([t/dt 1]); x(1) = 1;
y = zeros([t/dt 1]); y(1) = 0; % Starting point = (1, 0)
time = 0:dt:t;
dx = zeros([t/dt 1]);
dy = zeros([t/dt 1]);
r_squared = zeros([t/dt 1]); r_squared(1) = x(1)^2 + y(1)^2;

for t = 2:length(time)
    dx(t) = lambda * x(t-1) - omega * y(t-1) - gamma * (x(t-1)^2 + y(t-1)^2) * x(t-1) + I(t-1);
    dy(t) = lambda * y(t-1) + omega * x(t-1) - gamma * (x(t-1)^2 + y(t-1)^2) * y(t-1);
    x(t) = x(t-1) + dt * dx(t);
    y(t) = y(t-1) + dt * dy(t);
    r_squared(t) = x(t)^2 + y(t)^2;
end

others.r = r_squared;
others.dx = dx;
others.dy = dy;
others.phi = x .* (lambda - r_squared);
% Take only the stable part
% x = x(round(length(time)/10):end);
% y = y(round(length(time)/10):end);
% time = time(round(length(time)/10):end);
end