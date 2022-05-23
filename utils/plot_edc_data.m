function plot_edc_data(t, x, mu, plot_type)
% plot_edc_data: receives data generated from EDC simulation data and
% plots the results
% INPUTS:
%       t, x:      time and internal state variables from EDC ode0 simulation
%       mu:        which is the algorithm output of interest corresponding
%                  to the mu-th derivative of the average signal
%       plot_type: which is 'raw' for outputs as they are
%                  and 'error' to plot the error signal instead

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

global A;
global freq;
global amp;
global phase;
global g;
global m;

% This condition means we are using EDCHO and not REDCHO
if(numel(g)==0)
    g = zeros(1, m); % REDCHO with all gamma = 0 is equivalent to EDCHO
end

% Only useful for REDCHO, this is not used for EDCHO
Gamma = -diag(g) + [ zeros(m-1,1) , eye(m-1) ; zeros(1,m) ];
G = [1, zeros(1,m-1)]*Gamma^mu;

n = size(A,1);
y = zeros(numel(t),n);
u_mean = zeros(numel(t),1);

for i = 1 : numel(t)
    
    % Computes current value of the mu-th derivative
    % of the average signal. Since the mu-th derivative of cos(t)
    % alternates between cos/sin, we precompute each alternative and then
    % select the correct one.
    
    % In the actual implementation, this corresponds to a
    % local differentiator. In practice this should be implemented either
    % with actual knowledge of the derivative expresion, a Levant's exact
    % differentiator or a Khalil's high gain observer.
    A = freq.^mu;
    f = [+cos(freq*t(i)+phase),...
        -sin(freq*t(i)+phase),...
        -cos(freq*t(i)+phase),...
        +sin(freq*t(i)+phase)];
    u = amp.*A.*f(:,mod(mu,m)+1);
    
    % Compute the output of the algorithm using the local differentiator
    % and the internal state x
    % If using EDCHO, matrix G is just the identity.
    y(i,:) = u';
    for nu = 0 : mu
        y(i,:) = y(i,:) - G(nu+1)*x(i, nu*n+1 : (nu+1)*n);
    end
    
    % Compute the actual global average signal
    u_mean(i) =  mean(u);
end


if(strcmp(plot_type,'raw'))
    plot(t,y); hold on;
    plot(t,u_mean,'r--','Linewidth',2)
    xlabel('t')
    legend('y_{i,'+string(mu)+'}','u_{mean}^{('+string(mu)+')}')
    grid on;
end


if(strcmp(plot_type,'error'))
    err = abs(y-u_mean);
    plot(t,err); hold on;
    xlabel('t')
    legend('|y_{i,'+string(mu)+'}-u_{mean}^{('+string(mu)+')}|')
    grid on;
end

end