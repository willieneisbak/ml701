function inferredGraph = getInferredGraphs(finalSamples)

% this function returns the set of inferred graphs given the  
% results of SMC
%
% Inputs:
% (1) finalSamples is the result cell array of smcSimple, where 
%   (a) finalSamples{1} = finalAsCell
%   (b) finalSamples{2} = finalKsCell
%   (c) finalSamples{3} = finalWeights

finalAs = finalSamples{1};
finalKs = finalSamples{2};
finalWeights = finalSamples{3};

for i=1:length(finalAs)
    [meanGraph,meanWeightedGraph] = meanGraph(finalAs{i},finalWeights{i});
    inferredGraph{i} = meanGraph;
end

