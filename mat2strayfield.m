clear all
% Get and process/plot data from oommf vector files (previously converted 
% into .mat with oommf tools.

% Each vector file is for a different slice through time. The vector file
% contains the magnetisation vector for different positions throughout the
% simulation area.


% Vector file location - give the folder containing the omf files converted
% with omf2mat.py
% ohf_dir = 'C:\hpc\ppxdep\experiments\oommf\depinning_fields\output\2013-07-05\365531TransverseUp.omf\x2000nm_y100nm\Ks0\Hconst40\mat';
% ohf_dir = 'C:\hpc\ppxdep\experiments\oommf\depinning_fields\output\2013-06-14\x2000nm_y100nm\Ks0\Hconst0\mat';
ohf_dir = 'C:\hpc\ppxdep\experiments\oommf\depinning_fields\output\2013-07-22\687032TransverseUpNotch.omf\x2000nm_y100nm\Ks0\Hconst1\mat';
px_size = 4; %Set the size of each pixel.
x_size = 2000;
x_steps = x_size/px_size;
y_size = 100;
y_steps = y_size/px_size;


% Hunt through this folder for vector files.
[vector_files, is_dir] = glob(sprintf('%s\\*.ohf.mat', ohf_dir));

% Loop through this list of files. Extract the various parameters we care
% about. (Another option is to have each imported omf file as a class, but
% I don't know much about doing this at the moment - see mat2object.m and
% ovf.m)
% OOMMFData(x_slice, y_slice, z_slice, data_component
% for file_num = 1:length(vector_files)
figure;
hold on
for y_slice = [1,10]
    for file_num = 1:1
        load(vector_files{file_num})
        local_SimTime(file_num) = SimTime;
        field_data(file_num,:) = (OOMMFData(:,y_slice,1,1));
        disp(sprintf('Working on file %d', file_num))
        iteration_checker(file_num) = Iteration;
    end
    
    % Cutout the first/last few pixels since they can sometimes give spurious
    % results.
    num_time_steps = size(field_data,1);
    num_space_steps = size(field_data,2);
    left_pad = 50; % px
    right_pad = 50; %px
%     Cut out a particular region to plot:
%     plot_zone = left_pad:num_space_steps-right_pad;
    % Show how magnetisation changes with position
%     hold on
%     for i = 1:num_time_steps
%         plot(field_data(i,plot_zone)*(4*pi*1e-7))
%     end
    
%     % Remove massive spikes coming from the steps down at the taper by setting
%     % them to some offset value (probably just leave as zero is easiest).
    offset = 0;
    
    for i = 1:num_time_steps
        field_data(i,1:left_pad) = offset;
        field_data(i,num_space_steps-right_pad:num_space_steps) = offset;
        plot(field_data(i,:)*(4*pi*1e-7*1e3))
    end
end
xlabel('position px (multiply by step size to get nm)')
ylabel('Field Strength (mT)')
title('x-field along the wire 716369')
hold off
