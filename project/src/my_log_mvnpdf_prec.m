function prob = my_log_mvnpdf_prec(X,m,prec)

% returns the log pdf of a multivariate normal observations, 
% with mean and precision matrix params
%
% Inputs:
% (1) X is a matrix of observation vectors (each row an observation, can be a single row)
% (2) m is the mean vector (size 1xD)
% (3) prec is the precision matrix

M = repmat(m,size(X,1),1);
t1 = (-1/2) * (X-M) * prec * (X-M)';
t2 = (1/2) * log(det(inv(prec)));
t3 = (length(m)/2) * log(2*pi);
prob = diag(t1 - t2 - t3);
