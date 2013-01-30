% Micol Marchetti-Bowick
% CMU School of Computer Science

% This function initializes the adjacency matrix from graph data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A] = InitializeGraph(X,method)

[n p] = size(X);

% Random Initialization
if (method == 1)
    A = zeros(p,p);
    for i = 1:p
        for j = i+1:p
            A(i,j) = round(rand(1));
        end
    end
end

% BD-MCMC Initializtion
if (method == 2)
end

% GLasso Initialization
if (method == 3)
    A = GraphicalLasso(X,0.1);
end

end