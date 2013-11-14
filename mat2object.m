clear all
omf_dir = 'C:\hpc\ppxdep\experiments\oommf\depinning_fields\output\2013-04-09\x960nm_y48nm\Ks10000\mat';



[vector_files, is_dir] = glob(sprintf('%s\\*.omf.mat', omf_dir));
for file_num = 1:length(vector_files)
    disp(sprintf('Working on file_num %d', file_num));
    load(vector_files{file_num})
    omf(file_num) = ovf;
    omf(file_num).file_num = file_num;
    omf(file_num).GridSize = GridSize;
    omf(file_num).Iteration = Iteration;
    omf(file_num).MIFSource = MIFSource;
    omf(file_num).OOMMFData = OOMMFData;
    omf(file_num).SimTime = SimTime;
    omf(file_num).Stage = Stage;    
end

