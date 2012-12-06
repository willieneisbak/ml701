function errorcell = exp03Three_syntheticExperiment()

% testing SMC inference on synthetic data

errVec = [];
ptsToAve = 5;

errorSMC = zeros(1,10);
errorStaticBD = zeros(1,10);
errorCollapsedBD = zeros(1,10);


for ptToAve=1:ptsToAve
    
    bob = generateData;
    data = bob{1};
    networkcell = bob{2};
    netCell = {networkcell{1},networkcell{1},networkcell{1},networkcell{1},networkcell{1},networkcell{2},networkcell{2},networkcell{2},networkcell{2},networkcell{2}};
    
    alpha = 0.47;
    samples = 1000;
    graphcell = smc(data,samples,alpha);
    
    for t=1:10
        errorSMC(t) = errorSMC(t) + (1/ptsToAve)*(sum(sum(abs(graphcell{t}-netCell{t}))));
    end
    
end

errorcell = {errorSMC, errorStaticBD, errorCollapsedBD};
