function incidence = get_incidence( adjacency )
incidence=[]; % initialize incidence matrix
N = size(adjacency,1);
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

