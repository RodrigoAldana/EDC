% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

addpath('algorithms')
addpath('utils')
close all; clear all; clc;

% Graph matrices: adjacency, incidence and maximum number of nodes
global A; 
global D;
global nmax;

% Signal parameters
global freq;
global amp;
global phase;

% Protocol parameters (gains and order)
global k;
global g;
global m;
global Tc;

%% Generate random network
n = 8;
nmax = n;
n_leaders = 3;
p= 0.2;
[A,Q,D] = generate_random_graph(n,p);
figure(1);
plot_graph(A)
title('Graph used in the experiment')

% order of the system and parameters
m = 4;
r = 2; % gain scaling
k = [24,50,35,10].*[r^1, r^2 , r^3, r^4];
g = [1,1,1,1]*2;
Tc = 1;

% Initial conditions
x0 = zeros(n,m);
x0 = x0(:);

%% Set up differential equation solver and MDVO in two parts
T = 10; % sim time
h = 1e-4; % time step


% Use modulated REDCHO for the average of signals 
% label = 1 if leader, label = 0 if follower
amp = [zeros(n-n_leaders,1) ; ones(n_leaders,1) ];
freq = zeros(n,1);
phase = zeros(n,1);

modulating('init',m);
[t,X_l] = ode0(@dyn_modulated_redcho,[0,T],x0,h);


% Use modulated REDCHO for the average of signals 
% u_i(t) = amp_i * cos( freq_i * t + phase_i) oly for the leaders. 
% Zero signals for the followers
freq = [ zeros(n-n_leaders,1) ; rand(n_leaders,1) ];
amp = [ zeros(n-n_leaders,1) ; rand(n_leaders,1) ];
phase = [ zeros(n-n_leaders,1) ; rand(n_leaders,1) ];

modulating('init',m);
[t,X_s] = ode0(@dyn_modulated_redcho,[0,T],x0,h);

% Subsample to only 1000 samples in order to aid the plot function
ss = floor(numel(t)/1000);
t = t(1:ss:end);
X_l = X_l(1:ss:end,:);
X_s = X_s(1:ss:end,:);

%% Plot data: 
% The expected behaviour is to see consensus in finite time
% towards a signal that converges asymptotically towards the average signal

figure(2);
title('Consensus results')
Z = mean(amp((n-n_leaders+1):n));

subplot(3,1,1)
plot_mdvo_data(t, X_s, X_l, n_leaders, 'raw')
h = plot([Tc,Tc],[-2*Z,2*Z],'k--', 'Linewidth',2); skip_legend(h)
axis([0,T,-2*Z,2*Z]);

subplot(3,1,2)
plot_mdvo_data(t, X_s, X_l, n_leaders, 'error')
h = plot([Tc,Tc],[0,Z],'k--', 'Linewidth',2); skip_legend(h)
axis([0,T,0, Z]);

subplot(3,1,3)
plot_mdvo_data(t, X_s, X_l, n_leaders, 'scale')
h = plot([Tc,Tc],[0,1.5*n/n_leaders],'k--', 'Linewidth',2); skip_legend(h)
axis([0,T,0, 1.5*n_leaders/n]);


