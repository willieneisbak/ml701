function vizCompareGraphs(g1,g2)
    
    if size(g1)~=size(g1)
        fprintf('ERROR vizCompareGraphs: the two input graphs are not the same size!\n');
    end
    
    for i=1:size(g1,1)
        fprintf( [mat2str(g1(i,:),3), '\t', mat2str(g2(i,:),3), '\n'] );
    end
