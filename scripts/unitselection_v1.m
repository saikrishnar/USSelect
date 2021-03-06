% This program concatenates the units based on Viterbi algorithm with
% duration as target cost and pitch as join cost.
% Source : Enhancements of Viterbi Search for Fast Unit Selection Synthesis INTERSPEECH 2010

% Need to add  - Context


% Clear the workspace
clc; clear all; close all;


% Load a test sentence
fid = fopen('../test/phones.phone');
phones = textscan(fid, '%s');
fclose(fid);
test_phones = phones{1};
% durations_frame = load('../test/durations.phone');
% start_frame = durations_frame(:,1);
% end_frame = durations_frame(:,2);
% duration_frame = end_frame - start_frame;
% test_durations_time = duration_frame*80/16;

% Load the Mean Durations
fid = fopen('../mean/phones.dict');
phones_mean = textscan(fid, '%s');
fclose(fid);
mean_duration = load('../mean/durations.dict');

% Load the Dictionary
fid = fopen('../dictionary/phones.dict');
phones_dict = textscan(fid, '%s');
fclose(fid);
temp = phones_dict{1};
feats_dict = load('../dictionary/feats.dict');
start_frame = feats_dict(:,1);
end_frame = feats_dict(:,2);
duration_frame = end_frame - start_frame;
dict_durations_time = duration_frame*80/16;
dict_f0_start = feats_dict(:,7);
dict_f0_end = feats_dict(:,8);

% Start the Viterbi Algorithm
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
        unit_examples =  temp(strmatch(unit,temp));
        unit_durations = dict_durations_time(strcmp(unit,temp));
        TC{i} = unit_durations - mean(unit_durations) ;
        Cstar{i} = TC{i};
        break;
        
    end
end
p = p  + 1;


%  Step 2:    Compute the cost for all the other units
for i = p+1 : length(test_phones) - 1
    % Concatenation Cost
    % Loop through all the k instants of the current unit and all the l units of the next unit
    i
    previous_unit = test_phones(i-1)
    previousunit_examples = temp(strcmp(previous_unit,temp));
    previousunit_f0 = dict_f0_start(strcmp(previous_unit,temp));
    
    current_unit = test_phones(i)
    currentunit_examples = temp(strcmp(current_unit,temp));
    currentunit_f0 = dict_f0_end(strcmp(current_unit,temp));
    currentunit_duration = dict_durations_time(strcmp(current_unit,temp));
    
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

clear idx;

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

k_i
test_phones

% Find the units
exemplar_array = [];
for i = 1:length(test_phones)
       
    unit = test_phones(i);
    if strmatch(unit, 'SIL')
        p = p + 1;
    else
        unit
        unit_examples = find(strcmp(test_phones(i),temp)>0);
        best_cost = k_i(i);
        exemplar = unit_examples(best_cost);
        exemplar_array = [ exemplar_array exemplar];
    end
    
end
    
