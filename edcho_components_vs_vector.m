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
global m;

%% Generate random network
n = 8;
p= 0.04;
[A,Q,D] = generate_random_graph(n,p);
plot_graph(A)

% generate time varying signals parameters: u_i(t) = amp_i * cos( freq_i * t + phase_i)
freq = rand(n,1);
amp = rand(n,1);
phase = rand(n,1);
% order of the system and parameters
m = 4;
r = 1; % gain scaling
k = [24,50,35,10].*[r^1, r^2 , r^3, r^4];

% Initial conditions
x0 = 20*(rand(n,m)-0.5); % one row per agent, with m components each

% Account for assumption that sum_i x_{i,\mu} = 0 (initial orthogonality to vector of ones)
for mu = 1 : m
   x0(1,mu) = -sum(x0(2:end,mu)); 
end
x0 = x0(:);

%% Set up differential equation solver and run protocol
T = 20; % sim time
h = 0.001; % time step

% solve the differential equation to obtain the behaviour of the consensus
% protocol. dyn_edcho_components is the protocol implemented using
% component wise form of the algorithm (i.e. computes dx_{i,\mu} by separate)
[t,x] = ode0(@dyn_edcho_components,[0,T],x0,h);

subplot(2,1,1);
plot_edc_data(t, x, 0, 'raw')
title('System behaviour using component by component form')
axis([0,T,-2*max(amp),2*max(amp)]);


%% This is the same as before but using the protocol implemented in vector form.
% BOTH THE PREVIOUS SIMULATION AND THIS ONE SHOULD BE THE SAME!

% solve the differential equation to obtain the behaviour of the consensus
% protocol. dyn_edcho_vectorial is the protocol implemented using
% vector form of the algorithm (i.e. computes dX_\mu using vector operations)

[t,X] = ode0(@dyn_edcho_vectorial,[0,T],x0,h);

subplot(2,1,2);
plot_edc_data(t, X, 0, 'raw')
title('System behaviour using vector form')
axis([0,T,-2*max(amp),2*max(amp)]);
