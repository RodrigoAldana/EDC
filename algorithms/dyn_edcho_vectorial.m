function dX = dyn_edcho_vectorial( t,x )
% dyn_edcho_vectorial: dynamics of the EDCHO protocol internal 
% variables. EDCHO achieves dynamic consensus towards the 
% average of time-varying singlas. Test signals are always persistent
% signals of the form A*cos(w*t). 
%
% This version of the protocol (vectorial) is the "compact"
% implementation of the protocol, where the incidence matrix
% is used. The result is (algebraically) identical to the 
% other version in dyn_edcho_components.m

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

global D;
global m; % system order
global k; % system gains
global freq;
global amp;
global phase;

n = size(D,1);                % number of agents
u = amp.*cos(freq*t+phase);   % compute all time varyng signals
X = reshape(x,n,m);           % reshape state: one row per agent, m components for each agent
dX = zeros(size(X));          % placeholder for the dynamics

Y0 = u - X(:,1);     % compute all outputs in one step
for mu = 1 : m-1     % for each mu-th state compute \dot{X}_\mu
    % both integrator dynamics and correction terms
    dX(:,mu) = X(:,mu+1) + k(mu)*D*( abs(D'*Y0).^( (m-mu)/m ).*sign(D'*Y0)  );
end

% last state doesnt have integrator dynamics, and correction term is
% discontinous, i.e. sliding mode
dX(:,m) = k(m)*D*sign(D'*Y0);

% rearrange again as stacked vector
dX = dX(:);
end

