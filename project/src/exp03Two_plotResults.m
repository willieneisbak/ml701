load exp03Two_synth_pt47alpha_trials
tmp = sum(errorMat,2) / size(errorMat,2); tmp=fliplr(tmp'); tmp = tmp/10; % 10 time steps

figure,

plot(numSamples,tmp,'-or','LineWidth',2);
%xlim([-50,1050])
%ylim([0,29])
%ylabel('Average Error in Inferred Adjacency Matrix');
%xlabel('Number of Observations');

addpath('collapsed_gibbs')
load gibbs_errors_obs 
hold on

plot(numSamples,gibbsErrors,'-xb','LineWidth',2);

xlim([-50,1050])
ylim([-2,30])
ylabel('Average Error in Inferred Adjacency Matrix');
xlabel('Number of Observations');
legend('SMC Inference', 'Collapsed Gibbs Inference');
