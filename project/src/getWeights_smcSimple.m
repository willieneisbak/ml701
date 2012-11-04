function weights = getWeights_smcSimple(precCell,data_t)

% Compute importance weights (smcSimple version) for each sample at a given time step
%
% Inputs:
% (1) precCell is a cell-array, where the elements are precision matrix samples from a single time step
% (1) data_t is an nxd matrix of observations from a single time step

d = size(data_t,2); % dimension of data / MVN params 
for k=1:length(precCell)
    weights(k) = sum(my_log_mvnpdf_prec(data_t,zeros(1,d),precCell{k}));
end
