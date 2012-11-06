function accVsPartMat = smc_accuracyVsParticles()

% this function returns a 2xnumTrials matrix containing results of 
% empirical accuracy vs precision
%

addpath('synthetic-data-generation');
[network,sampleData] = StaticNetworkSimulation();
net = triu(logical(network),1);

trials = [1:50:1500];
accVsPartMat = zeros(length(trials),2); accVsPartMat(:,1) = trials;
for i=1:length(trials)
    P = trials(i);
    result = bdmcmc_static(sampleData,P,3,eye(size(sampleData,2)),false);
    [meanGraphMat,meanWeightedGraph] = meanGraph(result{2},result{4});
    accVsPartMat(i,2) = sum(sum(abs(net-meanGraphMat)));
    fprintf('finished P=%d\n',P);
    disp(accVsPartMat);
end
