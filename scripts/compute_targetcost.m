function [idx, targetcost] = compute_targetcost(duration, mean_duration)
% This program calculates the target cost of the individual units. In this
% case, the deviation from the mean duration is taken as the target cost.

% Input 
% duration - vector of exemplar durations in milliseconds
% mean_duration - Mean Duration of the exemplar

[targetcost, idx] =  (duration - mean_duration);

end

     