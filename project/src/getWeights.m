function weights = getWeights(samples,data)

% getWeights(samples,data) Compute importance weights for each sample (for smcSimple)
%
% Description of function
%
% Inputs:
% (1) samples are 
% (2) data from a single time step (matrix of size n x d)

%%%% input samples could be: only the newest precision matrices, or newest precision matrices and graphs, or all precision matrices and graphs.

d = size(data,2); % dimension of data / MVN params 
Kvec = %%%% a cell of precision-matrix-samples, gotten from samples input
for k=1:length(Kvec)
    weights(k) = sum(my_log_mvnpdf_prec(data,zeros(1,d),Kvec{k}));
end
