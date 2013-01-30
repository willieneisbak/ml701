load('gene_data.mat');
data = path1Data;

trueA = cell(9,1);
for t = 1:9
    trueA{t} = zeros(25,25);
end

[A,errors] = RunGibbsSampling(trueA,data);

save('gene_data_results.mat');