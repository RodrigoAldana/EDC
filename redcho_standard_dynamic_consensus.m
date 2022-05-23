% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

addpath('algorithms')
addpath('utils')
close all; clear all; clc;

% Graph matrices (Adjacency and Incidence)
global A; 
global D;

% Signal parameters
global freq;
global amp;
global phase;

% Protocol parameters (gains and order)
global k;
global g;
global m;
%% Generate random network
n = 10;
p= 0.2;
[A,Q,D] = generate_random_graph(n,p);
figure(1);
plot_graph(A)
title('Graph used in the experiment')

% generate time varying signals parameters: u_i(t) = amp_i * cos( freq_i * t + phase_i)
freq = rand(n,1);
amp = rand(n,1);
phase = rand(n,1);

% order of the system and parameters
m = 4;
r = 2; % gain scaling
k = [24,50,35,10].*[r^1, r^2 , r^3, r^4];
g = [1,1,1,1]*2;

% Initial conditions
x0 = 20*(rand(n,m)-0.5); % one row per agent, with m components each
% NO NEED TO account for assumption that sum_i x_{i,\mu} = 0
x0 = x0(:);

%% Set up differential equation solver and run protocol
T = 10; % sim time
h = 5e-4; % time step

% Use REDCHO
[t,X] = ode0(@dyn_redcho,[0,T],x0,h);

% Subsample to only 100 samples in order to aid the plot function
ss = floor(numel(t)/100);
t = t(1:ss:end);
X = X(1:ss:end,:);

%% Plot data: 
% The expected behaviour is to see consensus in finite time
% towards a signal that converges asymptotically towards the average signal

figure(2);
title('Consensus results')

subplot(2,1,1)
plot_edc_data(t, X, 0, 'raw')
axis([0,T,-2*mean(amp),2*mean(amp)]);

subplot(2,1,2)
plot_edc_data(t, X, 0, 'error')
axis([0,T,0,mean(amp)]);