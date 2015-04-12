function exemplar_array = my_viterbi_step4(test_phones, phones_dump, k_i)
% Find the units
exemplar_array = [];
p = 1;
for i = 1:length(test_phones)
       
    unit = test_phones(i);
    if strmatch(unit, 'SIL')
        p = p + 1;
    else
        unit
        unit_examples = find(strcmp(test_phones(i),phones_dump)>0);
        best_cost = k_i(i);
        exemplar = unit_examples(best_cost);
        exemplar_array = [ exemplar_array exemplar];
    end
    
end
end