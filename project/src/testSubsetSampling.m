% discrete distribution
distro = [0.1,0.1,0.3,0.05,0.45];
numSamples = 100000;

% usual sampling
usuSamples = catrnd(distro,numSamples);
prop1 = [length(find(usuSamples==1)),length(find(usuSamples==2)),length(find(usuSamples==3)),length(find(usuSamples==4)),length(find(usuSamples==5))];
prop1 = prop1/sum(prop1);
fprintf('Usual Samples: 1:%.3f, 2:%.3f, 3:%.3f, 4:%.3f, 5:%.3f\n',prop1);

% subset samplings (attempt #1)
subsetSize = 3;
for i=1:numSamples
    indToZero = randperm(5,5-subsetSize);
    newdist = distro;
    newdist(indToZero) = 0;
    newdist = newdist/sum(newdist);
    newSamples(i) = catrnd(newdist);
end
prop2 = [length(find(newSamples==1)),length(find(newSamples==2)),length(find(newSamples==3)),length(find(newSamples==4)),length(find(newSamples==5))];
prop2 = prop2/sum(prop2);
fprintf('New Samples: 1:%.3f, 2:%.3f, 3:%.3f, 4:%.3f, 5:%.3f\n',prop2);
% Note: the above test was unsuccessful

% subset samplings (attempt #2)
subsetSize = 3;
for i=1:numSamples
    indToZero = randperm(5,5-subsetSize);
    newdist = distro;
    newdist(indToZero) = 0;
    newdist = newdist/((5*sum(newdist)) / subsetSize);
    newdist(indToZero) = (1/subsetSize);
    newSamples(i) = catrnd(newdist);
end
prop2 = [length(find(newSamples==1)),length(find(newSamples==2)),length(find(newSamples==3)),length(find(newSamples==4)),length(find(newSamples==5))];
prop2 = prop2/sum(prop2);
fprintf('New Samples #2: 1:%.3f, 2:%.3f, 3:%.3f, 4:%.3f, 5:%.3f\n',prop2);
% Note: the above test was unsuccessful
