function [ testcell, indices ] = parseStockData2( tau, T )
%PARSESTOCKDATA returns a 1xT cell where each element in the 
% cell is a 1xtau vector.
%   tau is the threshold for the number of nodes.

D = importdata('stockprices.txt');
[n,T0] = size(D.data);

T = min(T,floor(T0/7));

indices = 1:n;
todel = [];
for i=1:n
    if sum(isnan(D.data(i,:)))>0
        todel(end+1) = i;
    end
end
D.data(todel,:) = [];
indices(todel) = [];

n = length(indices);
k = n - min(n,tau);
todel = randperm(n);
todel(1:n-k) = [];

D.data(todel,:) = [];
indices(todel) = [];

normalized_data = zeros(size(D.data));

testcell = cell(1,T);

for i=1:T
    
    node_sum = zeros(tau,1);
    
    for j=0:6
        node_sum = node_sum + D.data(1:tau, 7*i-6+j);
    end
        
    normalized_data(1:tau, 7*i-6:7*i) = D.data(1:tau,7*i-6:7*i)-1/7*repmat(node_sum,1,7);
    
    for j=1:tau
        normalized_data(j, 7*i-6:7*i) = normalized_data(j, 7*i-6:7*i)/std(normalized_data(j, 7*i-6:7*i));   
    end
    
    testcell{i} = normalized_data(1:tau,7*i-6:7*i)';
end

end

