function dx = dyn_edcho_components( t,x )
% dyn_edcho_components: dynamics of the EDCHO protocol internal 
% variables. EDCHO achieves dynamic consensus towards the 
% average of time-varying singlas. Test signals are always persistent
% signals of the form A*cos(w*t). 
%
% This version of the protocol (components) is the straightforward
% implementation of the protocol, where each agent adds the 
% correction terms per neighbor.

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
global A; % adjacency matrix
global m; % system order
global k; % system gains
global freq;
global amp;
global phase;

n = size(A,1);                % number of agents
u = amp.*cos(freq*t+phase);   % compute all time varyng signals
x = reshape(x,n,m);           % reshape state: one row per agent, m components for each agent
dx = zeros(size(x));          % placeholder for the dynamics

for i = 1 : n           % for each agent...
    neighbors = find( A(i,:)==1 );  % get all neighbors from adjacency matrix
    y_i = u(i) - x(i,1);            % compute local output
    
    % compute correction terms for each neighbor
    for j = 1 : numel(neighbors)
        y_j = u(neighbors(j)) - x(neighbors(j),1);  % compute neighbor output
        
        % add correction term to each mu-th state dynamics
        for mu = 1 : m
            dx(i,mu) = dx(i,mu) + k(mu)*abs( y_i - y_j )^( (m-mu)/(m) )*sign( y_i - y_j ); 
        end
        
    end
end

% add chain of intergrators to the dynamics
for mu = 1 : m-1
    dx(:,mu) = dx(:,mu) + x(:,mu+1);% - x(:,mu);
end

% rearrange again as stacked vector
dx = dx(:);
end

