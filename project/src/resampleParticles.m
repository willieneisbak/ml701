function newSamples = resampleParticles(samples,weights)

% returns a new set of samples that have been resampled given the weights vector 
%
% Inputs:
% (1) samples is
% (2) weights is a vector of sample weights

% normalize weights
normWeights = exp(weights)/sum(exp(weights));
if sum(normWeights)==0
    error('NORMALIZED WEIGHTS SUM TO 0. POSSIBLE UNDERFLOW ISSUES.');
end

% resample
newSamples = catrnd(normWeights,length(samples)) %%%% I'm assuming length(samples) is number of samples
