function accVsPartMat = exp01_smcAccuracyVsParticles()

% this function returns a (2 x numTrials) matrix containing results of 
%  empirical accuracy vs precision.

addpath('synthetic-data-generation');
[network,sampleData] = StaticNetworkSimulation();
net = triu(logical(network),1);

%trials = [1:200:2000];
trials = [6000];
accVsPartMat = zeros(length(trials),2); accVsPartMat(:,1) = trials;
for i=1:length(trials)
    P = trials(i);
    result = bdmcmc_new(sampleData,P,3,eye(size(sampleData,2)));
    [meanGraphMat,meanWeightedGraph] = meanGraph(result{2},result{4});
    accVsPartMat(i,2) = sum(sum(abs(net-meanGraphMat)));
    vizCompareGraphs(int8(net),int8(meanGraphMat)); disp('spacer'); vizCompareGraphs(int8(net),meanWeightedGraph); % my viz
    fprintf('finished P=%d\n',P);
    disp(accVsPartMat);
end
