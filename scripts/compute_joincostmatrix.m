function [joincostmatrix] = compute_joincostmatrix(i_f0, j_f0)
% This program calculates the join cost between the individual units. In this
% case, the deviation from the f0 is taken as the target cost.

joincostmatrix = zeros(length(i_f0),length(j_f0));

for i = 1:length(i_f0)
   for j = 1: length(j_f0)
       distance = sqrt((i_f0(i) - j_f0(j)).^2);
       joincostmatrix(i,j) = distance;    
   end  
end
end

     