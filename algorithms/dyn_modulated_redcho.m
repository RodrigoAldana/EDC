function dX = dyn_modulated_redcho( t,x )
% dyn_modulated_redcho: dynamics of the REDCHO protocol internal 
% variables with modulation function. This version achieves dynamic 
% consensus towards the average of time-varying signals in a prescribed
% time. Test signals are always persistent signals of the form A*cos(w*t). 

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.


global D;

global m; % system order
global k; % system gains
global g;

global freq;
global amp;
global phase;

global Tc % Prescribed convergence time

u = amp.*cos(freq*t+phase);% compute all time varyng signals
n = size(D,1);             % number of agents
X = reshape(x,n,m);        % reshape state: one row per agent, m components for each agent
dX = zeros(size(X));       % placeholder for the dynamics

u = u*modulating(t/Tc); % Modulate signals

Y0 = u - X(:,1);     % compute all outputs in one step
for mu = 1 : m-1     % for each mu-th state compute \dot{X}_\mu
    % both integrator dynamics and correction terms
    dX(:,mu) = ...
        + X(:,mu+1)...
        + k(mu)*D*( abs(D'*Y0).^( (m-mu)/m ).*sign(D'*Y0)  )...
        - g(mu)*(X(:,mu));
end

% last state doesnt have integrator dynamics, and correction term is
% discontinous, i.e. sliding mode
dX(:,m) = ...
    + k(m)*D*sign(D'*Y0)...
    - g(m)*X(:,m);

% rearrange again as stacked vector
dX = dX(:);
end

