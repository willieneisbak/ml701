function handle = viz_makeSimClusterHeatmap(fnedMat)

% make heatmap of reordered-for-clusters version of the fnedMat distance matrix

% find correct ordering
tree = linkage(fnedMat);
D = pdist(fnedMat);
%leafOrder = fliplr(optimalleaforder(tree,D));
leafOrder = optimalleaforder(tree,D);
clustMat = reorderMatrix(fnedMat,leafOrder);

% make heatmaps
HeatMap(clustMat)
figure, imagesc(clustMat)

% set custom colormap
temp = colormap(hsv);
%temp = colormap(lines);
temp = temp(9:60,:);
colormap(temp);
