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
start_frame = feats_dict(:,3);
end_frame = feats_dict(:,4);
duration_frame = end_frame - start_frame;
dict_durations_time = duration_frame*80/16;
dict_f0_start = feats_dict(:,7);
dict_f0_end = feats_dict(:,8);


% Start the Viterbi Algorithm
[p, TC, Cstar] = my_viterbi_step1(test_phones, temp, dict_durations_time); 
[ Cstar, Kstar, TC ] = my_viterbi_step2( p, test_phones, dict_f0_start, dict_f0_end, TC, Cstar, temp, dict_durations_time); 
k_i = my_viterbi_step3(Cstar, Kstar)
%exemplar_array = my_viterbi_step4(test_phones, phones_dump, k_i);
% 
% clear idx;
% k_i
% test_phones

    
