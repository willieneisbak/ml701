% Micol Marchetti-Bowick
% CMU School of Computer Science

% Adapted from Ankur Parikh

% generates Gaussian samples

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function sampleMatrix = GenerateData(precisionMatrix,NUM_SAMPLES)

    [V ~] = size(precisionMatrix);
    meanVector = zeros(1,V);
	covarianceMatrix = inv(precisionMatrix);
	sampleMatrix = mvnrnd(meanVector,covarianceMatrix,NUM_SAMPLES);
    
end	
	

