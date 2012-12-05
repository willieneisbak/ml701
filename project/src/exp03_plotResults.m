function exp03_plotResults()

%% attempt
%tvErr = [230,121,110,98,78,65,58];
%staticErr = [239,118,140,114,94,116,89];
%staticColErr = [282,192,306,300,306,132,306];
%aveTvErr = tvErr / 10;
%aveStaticErr = staticErr / 10;
%aveStaticColErr = staticColErr / 10;
%samples = [50,500:500:3000];

% 2nd attempt (using averages)
tvErr = [240.8000  135.0000   91.8000   76.2000   65.0000   61.4000   58.6000];
staticErr = [278.4000  140.4000  108.0000  101.4000  95.2000   84.2000  75.4000];
staticColErr = [246.0000  237.6000  162.0000   98.4000  99.6000  97.2000  94.6000];
aveTvErr = tvErr / 6;
aveStaticErr = staticErr / 6;
aveStaticColErr = staticColErr / 6;
samples = [50,500:500:3000];

plot(samples,aveTvErr,'r-*',samples,aveStaticErr,'b-x',samples,aveStaticColErr,'g-o','LineWidth',2);
legend('Dynamic Bayesian GGM', 'Static Bayesian GGM (expanded)', 'Static Bayesian GGM (collapsed)');
ylabel('Average Error in Inferred Adjacency Matrix');
xlabel('Number of Samples');
