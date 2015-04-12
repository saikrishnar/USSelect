function [ Cstar, Kstar, TC ] = my_viterbi_step2( p, test_phones, dict_f0_start, dict_f0_end, TC, Cstar, phones_dump, dict_durations_time) 
%  Step 2:    Compute the cost for all the other units
for i = p+1 : length(test_phones) - 1
    % Concatenation Cost
    % Loop through all the k instants of the current unit and all the l units of the next unit
    i
    previous_unit = test_phones(i-1)
    previousunit_examples = phones_dump(strcmp(previous_unit,phones_dump));
    previousunit_f0 = dict_f0_start(strcmp(previous_unit,phones_dump));
    
    current_unit = test_phones(i)
    currentunit_examples = phones_dump(strcmp(current_unit,phones_dump));
    currentunit_f0 = dict_f0_end(strcmp(current_unit,phones_dump));
    currentunit_duration = dict_durations_time(strcmp(current_unit,phones_dump));
    
    joincostmatrix = zeros(length(currentunit_f0),length(previousunit_f0));
    
    for k = 1:length(currentunit_f0)
        %temp = zeros(length(currentunit_examples),1);
        for l = 1: length(previousunit_f0)
            distance = sqrt((currentunit_f0(k) - previousunit_f0(l)).^2);
            joincostmatrix(k,l) = distance;
        end
        %[temp(k), idx] = min(sum_temp);
    end
    
    TC{i} = currentunit_duration - mean(currentunit_duration);
    strcat('Updated TC in the ', num2str(i))
    size(TC)
    
    % Update Cstar
    cbar = Cstar{i-1};
    abar = TC{i};
    temparray = zeros(length(currentunit_examples),1);
    idx = zeros(length(currentunit_examples),1);
    for k = 1:length(currentunit_examples)
        a = abar(k);
        sum_temp = zeros(length(previousunit_examples),1);
        for l = 1: length(previousunit_examples)
            b = joincostmatrix(k,l);
            c = cbar(l);
            sum_temp(l) = a+b+c;
        end
        [temparray(k), idx(k)] = min(sum_temp);
    end
    Cstar{i} = temparray;
    Kstar{i} = idx;
    
end
end