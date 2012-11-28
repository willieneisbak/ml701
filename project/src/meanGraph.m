function [meanGraph,meanWeightedGraph] = meanGraph(graphCell,weightVec)

% this function returns the expected graph given a cell of graph samples
% and a vector of weights-per-sample
%
% Inputs:
% (1) graphCell is a 1xP cell-array of adjacency matrices 
% (2) weightVec is a 1xP vector of weights-per-sample

sumGraphs = zeros(length(graphCell{1})); % init sumGraphs to all zeros
for i=1:length(graphCell)
    sumGraphs = sumGraphs + (graphCell{i}/weightVec(i)); % add each graph, weighted, onto sumGraphs
end
denom = sum(ones(1,length(graphCell))./weightVec); % compute denominator
meanWeightedGraph = sumGraphs / denom;
%meanGraph = zeros(length(meanWeightedGraph)); meanGraph(find(meanWeightedGraph>0.05)) = 1; %%%%fixed 0.15 here for now
meanGraph = zeros(length(meanWeightedGraph)); meanGraph(find(meanWeightedGraph>0.15)) = 1; %%%%fixed 0.15 here for now
