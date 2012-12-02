function exp03_plotResults()

tvErr = [230,121,110,98,78,65,58];
staticErr = [239,118,140,114,94,116,89];
aveTvErr = tvErr / length(tvErr);
aveStaticErr = staticErr / length(staticErr);
samples = [50,500:500:3000];

plot(samples,aveTvErr,'r-*',samples,aveStaticErr,'b-x')
legend('Dynamic Bayesian GGM', 'Static Bayesian GGM');
ylabel('Average Error in Inferred Adjacency Matrix');
xlabel('Number of Samples');
