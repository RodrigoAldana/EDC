function dX = dyn_edcho_vectorial( t,x )
% dyn_edcho_vectorial: dynamics of the EDCHO protocol internal 
% variables. EDCHO achieves dynamic consensus towards the 
% average of time-varying singlas. 
% This version of the protocol (vectorial) is the "compact"
% implementation of the protocol, where the incidence matrix
% is used. The result is (algebraically) identical to the 
% other version in dyn_edcho_components.m

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
global D;
global m; % system order
global k; % system gains
global local_signals; % local signals function handle

u = local_signals(t);      % compute all time varyng signals
n = size(D,1);                % number of agents
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

