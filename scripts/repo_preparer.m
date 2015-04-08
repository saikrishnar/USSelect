% This program is to prepare the repository of mean values for the unit
% selection synthesis

clc; clear all; close all;

fid = fopen('../lab/phones.dict');
phones = textscan(fid, '%s');
fclose(fid);
phone_list = phones{1};

prosody = load('../lab/prosody.dict');

start_sample = prosody(:,1);
end_sample = prosody(:,2);
start_frame = prosody(:,3);
end_frame = prosody(:,4);
energy_start = prosody(:,5);
energy_end = prosody(:,6);
f0_start = prosody(:,7);
f0_end = prosody(:,8);
duration = (end_sample - start_sample)/16;

mean_durations = [ ];
phn_array = [ ];

unique_phnlist = unique(phone_list)

for i = 1: length(unique_phnlist)
    i
    phone = unique_phnlist(i);
    K = find( strcmp( phone , phones{1}) > 0);
    size(K);
    phn_dur = duration(K);
    mean_durations = [ mean_durations mean(phn_dur) ];
    phn_array = [phn_array phone];
    
end
  
 dlmwrite('../lab/mean_durs.txt', mean_durations,'delimiter', '\n');

fid = fopen('../lab/phones.txt','w');
for i = 1 :length(phn_array)
    i
    str = phn_array{i}
    fprintf(fid, '%s\r\n', str); 
end
fclose(fid);
 