function matOrdered = reorderMatrix(mat,orderInd)

% this function reorders the square matrix(/graph representation) mat according the order-vector of indices, orderInd

% reorder the rows
for i=1:size(mat,1)
    mat2(i,:) = mat(orderInd(i),:);
end

% reorder the columns
for i=1:size(mat2,2)
    matOrdered(:,i) = mat2(:,orderInd(i));
end
