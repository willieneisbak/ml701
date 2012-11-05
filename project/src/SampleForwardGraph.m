function newA = SampleForwardGraph(A)

% SampleForwardGraph(A,b,D) Sample graph G_{t} given graph G_{t-1}  
%
% <Description of function>
%
% Inputs:
% (1) A is the adjacency matrix of the previous graph
% (2) Input two
% (3) Input three


% Default params:
% for two beta distributions, want default params:(?)
%alpha1 = 9;
%beta1 = 1;
%alpha0 = 1;
%beta0 = 9;

% param1 is fixed prob of edge flipping on->off or off->on
param1 = 0.01;

% generate a matrix of uniformly distributed random numbers
randMat = rand(length(A));

newA = A;
newA(intersect(find(randMat<param1),find(A))) = 0;
newA(intersect(find(randMat<param1),find(~A))) = 1;
newA = triu(newA,1);
