for rep = 1:5

[data,networkcell] = createData();

trueA = cell(10,1);
for t = 1:5
    trueA{t} = triu(double(abs(networkcell{1})>0),1);
end
for t = 6:10
    trueA{t} = triu(double(abs(networkcell{2})>0),1);
end

T = length(data);
A = cell(T,1);
errors = zeros(20,T);
for t = 1:T
    trueA_t{1} = trueA{1};
    data_t{1} = data{1};
    [A_t,errors_t] = RunGibbsSampling(trueA_t,data_t);
    A{t} = A_t;
    errors(:,t) = errors_t;
end

save(['gibbs_se_' num2str(rep) '.mat']);

end
