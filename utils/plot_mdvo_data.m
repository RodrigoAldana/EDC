function plot_mdvo_data(t, x_s, x_l, n_leaders, plot_type)
% plot_mdvo_data: receives data generated from EDC simulation data and
% plots the results
% INPUTS:
%     t, x_s, x_l: time and internal state variables from MDVO ode0 simulation
%                  x_s correspond to signal block, and x_l to label block
%     n_leaders:   number of leaders
%     plot_type:   which is 'raw' for outputs as they are
%                  and 'error' to plot the error signal instead

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

global A;
global freq;
global amp;
global phase;
global g;
global m;
global nmax;

n = size(A,1);
u_mean = zeros(numel(t),1);

f_slot = 1:(n-n_leaders);
l_slot = (n-n_leaders+1):n;

for i = 1 : numel(t)
    % Computes current leader signals signal. 
    u = amp.*cos(freq*t(i)+phase);
    
    % Compute the actual global average signal (only for leaders)
    u_mean(i) =  sum(u(l_slot))/n_leaders;
end

% Compute followers outputs (u-x as in REDCHO but u=0)
y_l = -x_l(:,f_slot);
y_s = -x_s(:,f_slot);

% Compute actual MDVO output by the ratio strategy
y = y_s./max(y_l,1/nmax);

if(strcmp(plot_type,'raw'))
    plot(t,y); hold on;
    %plot(t,1./max(y_l,1/nmax)); hold on;
    plot(t,u_mean,'r--','Linewidth',2)
    xlabel('t')
    legend('y_{i,0}','u_{leaders}')
    grid on;
end


if(strcmp(plot_type,'error'))
    err = abs(y-u_mean);
    plot(t,err); hold on;
    xlabel('t')
    legend('|y_{i,0}-u_{leaders}|')
    grid on;
end

if(strcmp(plot_type,'scale'))
    plot(t,y_l); hold on;
    plot([t(1),t(end)], [n_leaders/n,n_leaders/n] ,'r--','Linewidth',2)
    xlabel('t')
    legend('estimation  of n_{leaders}/n ', 'n_{leaders}/n');
    grid on;
end

end