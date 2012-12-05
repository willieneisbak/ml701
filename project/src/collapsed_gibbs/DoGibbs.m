for rep = 1:5

    [data,networkcell] = createData();

    trueA = cell(10,1);
    for t = 1:5
        trueA{t} = triu(double(abs(networkcell{1})>0),1);
    end
    for t = 6:10
        trueA{t} = triu(double(abs(networkcell{2})>0),1);
    end

    [A,errors] = RunGibbsSampling(trueA,data');
    
    filestring = ['gibbs_ws_',num2str(rep)];
    save(filestring);

end
