function err=getSmcError(graphcell,networkcell)

% inputs:
% graphcell: each element is adjacency matrix for graph at each time-step
% networkcell: each element is true network at each time-step 

if length(graphcell)~=length(networkcell)
    error('ERROR: graphcell and networkcell must be the same length!');
end

edgeThresh = 0.5;

err = 0;
for i=1:length(graphcell)
    meanGraphMat = zeros(length(graphcell{i})); meanGraphMat(find(graphcell{i}>edgeThresh)) = 1;
    net = triu(logical(networkcell{i}),1);
    err = err + sum(sum(abs(net-meanGraphMat)));
end
