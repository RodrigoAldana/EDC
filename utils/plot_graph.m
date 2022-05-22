function plot_graph( A )
% plot_graph: Plots an undirected graph given by adjacency matrix.

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

