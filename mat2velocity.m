clear all
close all
% Get and process/plot data from oommf vector files (previously converted 
% into .mat with oommf tools.

% Each vector file is for a different slice through time. The vector file
% contains the magnetisation vector for different positions throughout the
% simulation area.


% Vector file location - give the folder containing the omf files converted
% with omf2mat.py
omf_dir = 'C:\hpc\ppxdep\experiments\oommf\depinning_fields\output\2013-05-08\x960nm_y48nm\Ks0\mat';

% Hunt through this folder for vector files.
[vector_files, is_dir] = glob(sprintf('%s\\*.omf.mat', omf_dir));

% Loop through this list of files. Extract the various parameters we care
% about. (Another option is to have each imported omf file as a class, but
% I don't know much about doing this at the moment - see mat2object.m and
% ovf.m)
for file_num = 1:length(vector_files)
    load(vector_files{file_num})
    local_SimTime(file_num) = SimTime;
    mag_data(file_num,:) = OOMMFData(:,6,1,1);
    dw_position(file_num) = max(OOMMFData(50:150,6,1,1));
    disp(sprintf('Working on file %d', file_num))
    iteration_checker(file_num) = Iteration;
end

% Cutout the first/last few pixels since they can sometimes give spurious
% results. 
num_time_steps = size(mag_data,1);
num_space_steps = size(mag_data,2);
left_pad = 5; % px
right_pad = 3; %px
plot_zone = left_pad:num_space_steps-right_pad;

% Show how magnetisation changes with position
hold on
for i = 1:num_time_steps
    plot(mag_data(i,plot_zone))
end
xlabel('position')
ylabel('Mx')
title('Magnetisation (maximum in differential should give domain position')


% Plot the (absolute of the) differential, which will ultimately give me the domain wall
% position. We loop through time and plot them on top of each other. This
% is not ideal. We sort of improve this further down with a contour plot.
% We find the maximum value and, crucially, the index of the maximum value
% at the same time.
figure
hold on
for i = 1:num_time_steps
    diff_mag(i,:) = abs(diff(mag_data(i,plot_zone)));
    [diff_mag_max(i), diff_mag_I(i,:)] = max(diff_mag(i,:));
    max_pos(i) = plot_zone(diff_mag_I(i,:));
    plot(diff_mag(i,:))
end

xlabel('position')
ylabel('dMx/dx')
title('Absolute differential the maximum of each of these curves gives the domain wall position at that time')
hold off

% A contour plot of the absolute value of the differential of the
% magnetisation. This seems to be the simplest way of visually representing
% the movement of the domain wall. It would be nice to do one of those
% plots you see of X-ray spectra with a different line - for each time step
% in our case.
figure;
contour(diff_mag)
xlabel('position')
ylabel('time')
title(sprintf('%s', omf_dir))

% Plot the line of the maximum position found by the position at the index
% of the maximum value.
hold on 
plot(max_pos,1:num_time_steps, 'r-')
hold off
% figure; surf(diff_mag, 'EdgeColor', 'none')
% ylabel('time')
% xlabel('position')
% zlabel('Mx')
% diff_plot = abs(diff(mag_data(i,plot_zone)));
% time_plot = local_SimTime(1:length(local_SimTime)-1);
% time_plot = time_plot(plot_zone);
% plot_range = 1:657;
% plot_range = plot_range(plot_zone);
% figure; plot3(plot_range(1:220),time_plot(1:220),diff_plot(1:220))
% 
% % Find the domain wall position, which is the maximum absolute
% % differential for each time slice. This is the point at which the
% % magnetisation changes sign from +ve x to -ve x.
% for i = 1:length(local_SimTime)
%     dw_pos(i) = max(abs(diff(mag_data(i,plot_zone))));
% end
% 
% figure
% plot(local_SimTime,dw_pos)
% title('maximum of the magnetisation differential (~DW position)')