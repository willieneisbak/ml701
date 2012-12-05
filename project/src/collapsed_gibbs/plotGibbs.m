
numRep = 5;
aveErr = zeros(20,1);
for i=1:numRep
    evalstr = ['load gibbs_ws_', num2str(i)];
    eval(evalstr);
    aveErr = aveErr + (sum(errors,2)/size(errors,2));
end
errPerRep = aveErr/numRep;

plot(1:length(errPerRep),errPerRep,'-*r','LineWidth',2);
xlabel('Number of Gibbs Samples');
ylabel('Average Error in Inferred Adjacency Matrix');
