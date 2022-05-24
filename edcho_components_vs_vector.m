%% Copyright (C) 2022 Rodrigo Aldana-López <rodrigo.aldana.lopez at gmail dot com> (University of Zaragoza)
% For more information see <https://github.com/RodrigoAldana/EDC/blob/master/README.md>
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%
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
