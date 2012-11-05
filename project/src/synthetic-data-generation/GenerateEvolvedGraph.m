% Micol Marchetti-Bowick
% CMU School of Computer Science

% Adapted from Ankur Parikh

% This function generates a graph by randomly adding and deleting a few
% edges from a previous graph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function newG = GenerateEvolvedGraph(G,MIN_EDGE_CHANGE,MAX_EDGE_CHANGE)

global MAX_DEGREE
global THETA_MIN
global THETA_MAX

[V ~] = size(G);

newG = G;

totalChanges = MIN_EDGE_CHANGE + round(rand(1) * (MAX_EDGE_CHANGE-MIN_EDGE_CHANGE));
edgeChanges = zeros(size(G));
numChanges = 0;

while(numChanges < totalChanges),
    
    vertex1 = ceil(rand(1) * V);
    vertex2 = vertex1 + ceil(rand(1) * (V-vertex1));
    
    edge = newG(vertex1,vertex2);
    
    if (vertex1 == vertex2)
        continue;
    elseif (edgeChanges(vertex1,vertex2))
        continue;
    end
    
    if (edge == 0)
        if (sum(newG(vertex1,:))+sum(newG(:,vertex1)) >= MAX_DEGREE)
            continue;
        elseif (sum(newG(vertex2,:))+sum(newG(:,vertex2)) >= MAX_DEGREE)
            continue;
        end
        
        half = rand(1);
        if (half < .5)
            newG(vertex1, vertex2) = rand(1) * (THETA_MAX - THETA_MIN) + THETA_MIN;
        else
            newG(vertex1, vertex2) = -1 * (rand(1) * (THETA_MAX - THETA_MIN) + THETA_MIN);
        end 
    end
    
    if (edge > 0)
        newG(vertex1,vertex2) = 0;
    end
    
    newG(vertex2,vertex1) = newG(vertex1,vertex2);
    
    edgeChanges(vertex1,vertex1) = 1;
    numChanges = numChanges + 1;

end

end
