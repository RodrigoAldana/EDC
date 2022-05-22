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

% Initial conditions
x0 = 20*(rand(n,m)-0.5); % one row per agent, with m components each

% Account for assumption that sum_i x_{i,\mu} = 0 (initial orthogonality to vector of ones)
for mu = 1 : m
   x0(1,mu) = -sum(x0(2:end,mu)); 
end
x0 = x0(:);

%% Set up differential equation solver and run protocol
T = 10; % sim time
h = 5e-4; % time step

% Use EDCHO
[t,X] = ode0(@dyn_edcho_vectorial,[0,T],x0,h);

% Subsample to only 100 samples in order to aid the plot function
ss = floor(numel(t)/100);
t = t(1:ss:end);
X = X(1:ss:end,:);

%% Plot data

figure(2);
title('Consensus results')

subplot(2,1,1)
plot_edc_data(t, X, 0, 'raw')
axis([0,T,-2*mean(amp),2*mean(amp)]);

subplot(2,1,2)
plot_edc_data(t, X, 0, 'error')
axis([0,T,0,mean(amp)]);


