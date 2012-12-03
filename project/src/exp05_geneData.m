function graphcell = exp05_geneData()

% Carry out SMC inference on the gene dataset

load('gene_data.mat')
data = path1Data';

P = 3000;

%alpha = 0.4;
%tic; graphcell = smc(data,P,alpha); toc
%save('exp05_geneData_pt4alpha');

%alpha = 0.2;
%tic; graphcell = smc(data,P,alpha); toc
%save('exp05_geneData_pt2alpha');

alpha = 0.49;
tic; graphcell = smc(data,P,alpha); toc
save('exp05_geneData_pt47alpha');
