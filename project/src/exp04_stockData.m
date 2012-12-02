function graphcell = exp04_stockData()

% Carry out SMC inference on the stock dataset

data = parseStockData(20,10);
P = 3000;
alpha = 0.4;

tic; graphcell = smc(data,P,alpha); toc

save('exp04_stockData_pt4alpha');
