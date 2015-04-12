% This program splits the units from the wavefiles

% Clear the workspace
clc; clear all; close all;

% Add paths
wavepath = '../wav';

% Load the Dictionary
fid = fopen('../dictionary/phones.dict');
phones_dict = textscan(fid, '%s');
fclose(fid);
phones = phones_dict{1};
uniq_phones = unique(phones);
feats_dict = load('../dictionary/feats.dict');
start_sample = feats_dict(:,1);
end_sample = feats_dict(:,2);
fid = fopen('../dictionary/filenames.dict');
filenames_dict = textscan(fid, '%s');
fclose(fid);
filenames = filenames_dict{1};


for i = 2 : length(uniq_phones)
    i
    unit = uniq_phones{i};
    unitfolder = strcat('../units/', unit);
    if exist(unitfolder,'dir') == 7
        'Exists';
    else
        folder = strcat('../units/', unit);
        mkdir(folder);
    end
    filenames_unit = filenames(find(strcmp(uniq_phones(i),phones)>0));
    start_sample_unit = start_sample(find(strcmp(uniq_phones(i),phones)>0));
    end_sample_unit = end_sample(find(strcmp(uniq_phones(i),phones)>0));
    fname = strcat(unitfolder, '/', unit,'.txt');
    fid = fopen(fname,'w');
    for j = 1: length(filenames_unit)
        
        [str,tok] = strtok(filenames_unit(j), '.');
        wavename = strcat(wavepath,'/',str{:},'.wav');
        [y,fs] = wavread(wavename);
        y_unit = y(start_sample_unit(j): end_sample_unit(j));
        str = [num2str(j) '^' wavename '^' num2str(start_sample_unit(j)) '^' num2str(end_sample_unit(j)) '\n' ];  
        fprintf(fid, str);
        wavname = strcat(unitfolder,'/', unit, '_', num2str(j), '.wav');
        wavwrite(y_unit,fs, wavname);
    end
    fclose(fid);
    
end