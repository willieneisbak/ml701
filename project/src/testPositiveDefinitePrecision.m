addpath('synthetic-data-generation');
[network,sampleData] = StaticNetworkSimulation();
net = triu(logical(network),1);
for p=1:10000                               
    jo = SamplePrecisionMatrix(net,3,eye(20));
    i = randi(length(jo));
    j = randi(length(jo));
    if i~=j
        jo(i,j) = 0; jo(j,i) = 0;
        disp('rm edge')                 
    end
    chol(jo);
    disp([p,i,j])
end
