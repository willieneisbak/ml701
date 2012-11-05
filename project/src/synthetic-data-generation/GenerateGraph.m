% Micol Marchetti-Bowick
% CMU School of Computer Science

% Adapted from Ankur Parikh

% This function generates a random undirected graph with a certain number
% of vertices and edges, subject to constraints on the degree of each node
% and on the minimum and maximum weight of each edge

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function G = GenerateGraph(NUM_VERTICES,NUM_EDGES)

global MAX_DEGREE
global THETA_MIN
global THETA_MAX

G = zeros(NUM_VERTICES, NUM_VERTICES);

edgeCount = 0;

while(edgeCount < NUM_EDGES),
    
    vertex1 = ceil(rand(1) * NUM_VERTICES);
    vertex2 = vertex1 + ceil(rand(1) * (NUM_VERTICES-vertex1));
    
    if (vertex1 == vertex2)
        continue;
    elseif (G(vertex1,vertex2) == 1)
        continue;
    elseif (sum(G(vertex1,:))+sum(G(:,vertex1)) >= MAX_DEGREE)
        continue;
    elseif (sum(G(vertex2,:))+sum(G(:,vertex2)) >= MAX_DEGREE)
        continue;
    end
    
    half = rand(1);
    
    if (half < .5)
        G(vertex1, vertex2) = rand(1) * (THETA_MAX - THETA_MIN) + THETA_MIN;
    else
        G(vertex1, vertex2) = -1 * (rand(1) * (THETA_MAX - THETA_MIN) + THETA_MIN);
    end

    G(vertex2,vertex1) = G(vertex1,vertex2);
    
    edgeCount = edgeCount + 1;
 
end


