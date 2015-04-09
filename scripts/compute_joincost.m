function [idx, joincost] = compute_joincost(i_f0, j_f0)
% This program calculates the join cost between the individual units. In this
% case, the deviation from the f0 is taken as the target cost.
idx = [];
min_val = inf;
for i = 1:length(i_f0)
   for j = 1: length(j_f0)
       distance = sqrt((i_f0(i) - j_f0(j)).^2);
       if distance < min_val
          min_val = distance;
          idx = [idx i];
       end       
   end  
end
joincost = min_val;
end

     