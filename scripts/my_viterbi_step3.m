function [k_i] = my_viterbi_step3(Cstar, Kstar)


% Step 3:
idx = zeros(length(Cstar),1);
k_i = zeros(length(Cstar),1);
for i = 1: length(Cstar)
    
    dummyvariable = Cstar{i};
    dummyvariable2 = Kstar{i};
    if isempty(dummyvariable)
        continue;
    else
        if isempty(dummyvariable2)
            k_i(i) = 1;
        else
            [~,idx(i)] = min(dummyvariable);
            k_i(i) = dummyvariable2(idx(i));
        end
    end
end


end