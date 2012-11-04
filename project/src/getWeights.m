function weights = getWeights(samples,data)

% getWeights(A,b,D) Compute importance weights for each sample (for smcSimple)
%
% Description of function
%
% Inputs:
% (1) Input one
% (2) Input two
% (3) Input three


% Notes:
% input samples could be: only the newest precision matrices, or newest precision matrices and graphs, or all precision matrices and graphs.
% data could be: entire data cell or just data for relevant time step

% instead of likelihood (product) of prob of each data point, could take sum of log prob of each data point.


weight = mvnpdf(data,0*
