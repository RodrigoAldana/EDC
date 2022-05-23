function [adjacency,laplacian,incidence] = generate_random_graph(N,p)
% generate_random_graph: Generates a random undirected graph which is guaranteed to
% be connected.
% INPUTS:
%       N: Number of nodes
%       p: connectivity in the interval (0,1].
%          p near 0, means more disconected, p=1 means fully connected.
%          for p < 0.05 the funcion may not terminate. 
%          Interval p in [0.1 , 1] is recommended.
% OUTPUTS:
%       adjacency, Laplacian and Incidence matrices for the graph.

% Copyright (c) 2022 Rodrigo Aldana López, Universidad de Zaragoza, Spain. All rights reserved
% Licensed under the MIT license. See LICENSE.txt file in the project root for details.

% higher the p, the more connected the graph. For lower p the function may take longer to find a connected graph of that size. Fo higher N, the function may finish earlier than lower N for p near 0.
laplacian = zeros(N);
p = p/2;
while(rank(laplacian)~=N-1)                             % Loop until a connected graph is generated 
    R = rand(N);                                        % Generate random matrix
    adjacency = (R+R')/2;                               % Make it simetric
    adjacency(abs(adjacency - 0.5) > p) = 0;            % Make it a 0 - 1 matrix
    adjacency(abs(adjacency - 0.5) <= p) = 1;       
    adjacency = adjacency - diag(diag(adjacency));      % Delete diagonal to avoid self loops
    laplacian = diag(sum(adjacency)) - adjacency;       % Compute laplacian
end

incidence=[]; % initialize incidence matrix
for i=1:N
    for j=i:N
        % handle self-loops
        if i==j
            for x=1:adjacency(i,j)
                incidence=[incidence; zeros(1,length(1:i-1)), 1,zeros(1,length(i+1:N))]; 
            end
            continue; 
        end
        % add multiple edges if any
        for x=1:adjacency(i,j)
            incidence=[incidence; zeros(1,length(1:i-1)),1,zeros(1,length(i+1:j-1)),-1,zeros(1,length(j+1:N))]; 
        end
    end
end
incidence=incidence';
end
