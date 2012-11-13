%
% hw03 section 1 implementation for ml701 class.
% willie neiswanger, 11/2012.
%

function hw03()
    dat = csvread('hw3-cluster.csv'); 
    doPartsBandC(dat,'initrand');
    doPartsBAndC(dat,'init++')';
    doPartsEandF(dat);
    dat2 = csvread('hw3-cluster2.csv');
    doPartsEandF(dat2);

    function doPartsBandC(data,initstring)
        % carry out 200 iterations of kmeans
        [meanscell,wcsosVec] = runMultipleKMeans(data,5,200,initstring);
        % plot data and means for all iterations
        plot(dat(:,1),dat(:,2),'o','color',[0.5,0.5,0.5]);
        for i=1:length(meanscell)
            hold on; plot(meanscell{i}(:,1), meanscell{i}(:,2), 'o','k');
        end
        % get min, mean, and st-dev of the within-cluster sum of squares
        fprintf('Minimum within-cluster sum of squares:%f\n',min(wcsosVec));
        fprintf('Mean within-cluster sum of squares:%f\n',mean(wcsosVec));
        fprintf('Standard deviation of within-cluster sum of squares:%f\n',std(wcsosVec));
    end

    function doPartsEandF(data)
        % find best K
        initstring = 'initrand'; % or should I use 'init++'
        wcsosPerK = [];
        for k=1:15
            [meanscell,wcsosVec] = runMultipleKMeans(data,k,200,initstring);
            wcsosPerK(k) = min(wcsosVec);
        end
        plot(1:15,wcsosPerK,'o');
        %plot(1:15,sqrt(wcsosPerK),'o');
    end

    function [meanscell,wcsosVec] = runMultipleKMeans(data,k,iter,initstring)
        % run kmeans multiple times, get within-cluster sum of squares each time
        meanscell = {}; wcsosVec = [];
        for i=1:iter
            [dataLabels,dataMeans] = kmeans(data,k,initstring);
            meanscell{end+1} = dataMeans;
            wcsosVec(end+1) = getWcSumOfSquares(data,dataLabels,dataMeans);
        end
    end

    function [labels,means]=kmeans(data,k,whichInit)
        if strcmpi(whichInit,'initrand')
            means = initMeans_rand(data,k);
        elseif strcmpi(whichInit,'init++')
            means = initMeans_plusplus(data,k);
        end
        % kmeans algorithm
        lastmeans = [];
        itercount = 0;
        while lastmeans~=means
            itercount = itercount+1;
            lastmeans=means;
            % assign each example to closest mean in means vec  (euc distance)
            for k = 1 : size(means,1)
                diffmat = data - repmat(means(k,:), size(data,1), 1);
                distmat(:,k) = sqrt(sum(diffmat .* diffmat, 2));  % distmat(i,k) holds distance of i_th data to k_th mean
            end
            for i = 1 : size(data,1)
                [del, keep] = max(distmat(i,:));
                labels(i) = keep;
            end
            % assign each mean in means vec to mean of assigned examples
            for k = 1 : length(means)
                assignedInd = find(labels == k);
                means(a,:) = sum(data(assignedInd, :))/length(assignedInd); % compute mean
            end
        end
        fprintf('Number of iters taken for convergence: %d\n',itercount);

    function means = initMeans_rand(data,k)
        % initialize clusters to random data points
        temp = [1:size(data,1)];
        for a = 1 : k
            nextInd = floor((rand * length(temp)) - 0.0001) + 1;   % in place of randi() for compatibility with older MATLAB
            means(a,:) = data(temp(nextInd),:);
            temp(nextInd) = [];
        end
    end
    
    function means = initMeans_plusplus(data,k)
        % write k-means++ initialization here
    end

    function wcsos = getWcSumOfSquares(data,labels,means)
        % get the within-cluster sum of squares
        % sum, over all data points, the square of the norm of  (the data point minus its assigned cluster center)
        wcsos = 0;
        for i=1:size(data,1)
            wcsos = wcsos + norm(data(i,:) - means(labels(i),:))^2;
        end
    end
end
