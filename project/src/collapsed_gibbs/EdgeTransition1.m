% Micol Marchetti-Bowick
% CMU School of Computer Science

% This function calculates probability that edge ij is on (equals 1) 
% at time t

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [PAcurr,PAnext] = EdgeTransition1(A,P,q,t,i,j,T)

% Calculate P(a_t = 1|a_{t-1})
if (t == 1)
    PAcurr = q; % Use prior P(a_t = 1) = q
elseif (A{t-1}(i,j) == 1)
    PAcurr = 1 - P{2}(i,j); % P(a_t = 1|a_{t-1} = 1)
elseif (A{t-1}(i,j) == 0)
    PAcurr = P{1}(i,j); % P(a_t = 1|a_{t-1} = 0)
else
    display('ERROR: Invalid edge assignment');
end

% Calculate P(a_{t+1}|a_t = 1)
if (t == T)
    PAnext = 1; % Since there's no a_{T+1}, this factor is 1
elseif (A{t+1}(i,j) == 1)
    PAnext = 1 - P{2}(i,j); % P(a_{t+1} = 1|a_t = 1)
elseif (A{t+1}(i,j) == 0)
    PAnext = P{2}(i,j); % P(a_{t+1} = 0|a_t = 1)
else
    display('ERROR: Invalid edge assignment');
end

end