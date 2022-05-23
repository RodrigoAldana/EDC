function [t,x] = ode0(sys, inter,x0,h)
% ode0 : Euler method implementation of differential equation solver
% INPUT:
%   sys:   function which computes dx/dt as a function of x,t. i.e. dx/dt =
%          sys(x,t)
%   inter: time interval to obtain solution
%   x0:    initial condition
%   h:     discretization time step

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

t = inter(1):h:inter(end);
x = zeros(numel(t), numel(x0));
x(1,:) = x0';

for index = 2 : numel(t)
    print_progress( t(index),inter,0.01, h);
    x(index,:) = x(index-1,:) + h*sys(t(index),x(index-1,:)')'; % euler method
end

end

