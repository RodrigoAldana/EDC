function plot_graph( A )
% plot_graph: Plots an undirected graph given by adjacency matrix.

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
n=size(A,1);

% Points in a circle corresponds to nodes in the graph
delta = 2*pi/(n+1);
theta = linspace(0,n*delta,n);
x = cos(theta);
y = sin(theta);

for i = 1 : n
   xi = [x(i),y(i)];
   % Plot node
   plot(xi(1),xi(2),'ro'); hold on;
   for j = i : n
      xj = [x(j),y(j)];
      % For each edge...
      if(1==A(i,j))
          % ...plot a line between the two nodes
          plot([xi(1),xj(1)],[xi(2),xj(2)],'b');
      end
   end
end

axis([-1.5,1.5,-1.5,1.5])
axis equal
end

