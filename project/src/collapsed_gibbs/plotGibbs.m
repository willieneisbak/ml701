figure,

% plotting time varying
numRep = 5;
aveErr = zeros(20,1);
for i=1:numRep
    evalstr = ['load gibbs_ws_', num2str(i)];
    eval(evalstr);
    aveErr = aveErr + (sum(errors,2)/size(errors,2));
end
errPerRep = aveErr/numRep;
plot(1:length(errPerRep),errPerRep,'-*r','LineWidth',2);

% plotting static_expanded
numRep = 3;
aveErr = zeros(20,1);
for i=1:numRep
    evalstr = ['load gibbs_se_', num2str(i)];
    eval(evalstr);
    aveErr = aveErr + (sum(errors,2)/size(errors,2));
end
errPerRep = aveErr/numRep;
hold on
plot(1:length(errPerRep),errPerRep,'-xb','LineWidth',2);

%plotting static_collapsed
numRep = 5;
aveErr = zeros(20,1);
for i=1:numRep
    evalstr = ['load gibbs_sc_', num2str(i)];
    eval(evalstr);
    aveErr = aveErr + (sum(errors,2)/size(errors,2));
end
errPerRep = aveErr/numRep;
hold on
plot(1:length(errPerRep),errPerRep,'-og','LineWidth',2);


legend('Dynamic Bayesian GGM', 'Static Bayesian GGM (expanded)', 'Static Bayesian GGM (collapsed)');
xlabel('Number of Gibbs Samples');
ylabel('Average Error in Inferred Adjacency Matrix');
xlim([0,21])
ylim([0,24])
