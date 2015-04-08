% This program is to calculate the energy to be used in the unit selection based  voice

% Clear the workspace
clc; clear all; close all;

% Set the paths to the folders
waves = dir('../wav');
energypath = '../energy';

% Loop through all the waves
for i = 3:length(waves)
    
       i
       % Loops through each file in speaker        
        reffilename = waves(i).name;        
        [refstr,tok] = strtok(reffilename,'.');
             
       % Read the wave and apply the diff operation       
        [y,fs] = wavread(strcat('../wav/', reffilename));       
        y = diff(y);
        y(end+1) = y(end);
        
       % Defining the system parameters
        frSize = 20*(fs/1000);
        frShift = 5*(fs/1000);
        frOvlap = frSize - frShift;
        
       % Apply the buffer on the frames 
        yb = buffer(y,frSize,frOvlap,'nodelay');
        ybw = bsxfun(@times,yb,hamming(frSize));
        
       % Obtain energy
        energy = sum(yb.^2);        
      
        % Write in file
        destination = strcat(energypath, '/', refstr, '.energy');
        dlmwrite(destination, energy, 'delimiter', '\n');        

    
end
