function [p, TC, Cstar] = my_viterbi_step1(test_phones, phones_dump, dict_durations_time) 

p = 0;
TC = {};
Cstar = {};
% Step 1:   Initiate the first unit
for i = 1:length(test_phones)
    
    unit = test_phones(i);
    if strmatch(unit, 'SIL')
        p = p + 1;
    else
        unit
        unit_examples =  phones_dump(strmatch(unit,phones_dump));
        unit_durations = dict_durations_time(strcmp(unit,phones_dump));
        TC{i} = unit_durations - mean(unit_durations) ;
        Cstar{i} = TC{i};
        break;
        
    end
end
p = p  + 1;

end