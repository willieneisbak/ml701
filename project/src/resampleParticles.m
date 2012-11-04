function sampleInd = resampleParticles(weights)

% returns a set of sample indices that have been resampled given the weights vector.
% carries out multinomial resampling.
%
% Inputs:
% (1) weights is a vector of sample weights


% note: if i don't worry about underflow in normalization, this whole function could be:
%sampleInd = catrnd(exp(weights),length(weights));

% normalize weights and check for errors
normWeights = exp(weights)/sum(exp(weights));
if sum(normWeights)==0
    error('NORMALIZED WEIGHTS SUM TO 0. POSSIBLE UNDERFLOW ISSUES.');
end

% resample
sampleInd = catrnd(normWeights,length(weights))
