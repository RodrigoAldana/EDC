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
global g;
%% Generate random network
n = 8;
p= 0.2;
[A,Q,D] = generate_random_graph(n,p);
figure(1);
plot_graph(A)
title('Graph used in the experiment')

% generate time varying signals parameters: u_i(t) = amp_i * cos( freq_i * t )
freq = rand(n,1);
amp = rand(n,1);
phase = rand(n,1);

% order of the system and parameters
m = 4;
r = 4; % gain scaling
k = [24,50,35,10].*[r^1, r^2 , r^3, r^4];
g = ones(m,1)*1;

% Initial conditions
x0 = 20*(rand(n,m)-0.5); % one row per agent, with m components each
% NO NEED TO account for assumption that sum_i x_{i,\mu} = 0
x0 = x0(:);

%% Set up differential equation solver and run protocol
T = 20; % sim time
h = 5e-6; % time step

% Use REDCHO
[t,X] = ode0(@dyn_redcho,[0,T],x0,h);

% Subsample to only 100 samples in order to aid the plot function
ss = floor(numel(t)/100);
t = t(1:ss:end);
X = X(1:ss:end,:);

%% Plot data

figure(2);
title('Consensus results')

% Plot the 0-th derivative
subplot(3,2,1);
plot_edc_data(t, X, 0, 'raw')
axis([0,T,-mean(amp),mean(amp)]);
subplot(3,2,2);
plot_edc_data(t, X, 0, 'error')
axis([0,T,0,mean(amp)]);

% Plot the 1-st derivative
subplot(3,2,3);
plot_edc_data(t, X, 1, 'raw')
axis([0,T,-mean(amp.*freq),mean(amp.*freq)]);
subplot(3,2,4);
plot_edc_data(t, X, 1, 'error')
axis([0,T,0,mean(amp.*freq)]);

% Plot the 2-nd derivative
subplot(3,2,5);
plot_edc_data(t, X, 2, 'raw')
axis([0,T,-mean(amp.*freq.^2),mean(amp.*freq.^2)]);
subplot(3,2,6);
plot_edc_data(t, X, 2, 'error')
axis([0,T,0,mean(amp.*freq.^2)]);
