% get main_PG parameters
clear;clc
cd('U:\Documents_U\Git\post_processing_detections\')
addpath('utilities')
addpath('utilities\pgmatlab')
addpath('performances\MATLAB')
addpath(genpath(fullfile(fileparts(fileparts(pwd)), 'utilities')))

% user inputs
info_deploy.annotator = 'PAMGuard';
info_deploy.annotation = 'Whistle and moan detector';
info_deploy.dataset = 'C9D7_ST7191';
info_deploy.timezone = '+02:00';
info_deploy.dt_format = 'yyMMddHHmmss'; % APOCADO filename format
% info_deploy.dt_format = 'yyyy-MM-dd_HH-mm-ss'; % CETIROISE filename format


% get wav files
mode = 'file';
% mode = 'folder';
base_folder = 'L:\acoustock\Bioacoustique\DATASETS';

if isequal(mode, 'file')
    msg = sprintf('%s - select waves', info_deploy.dataset);
    [wav_file, folder_wav] = uigetfile('*.wav', msg, 'Multiselect', 'on', base_folder);
    wav_path = fullfile(folder_wav,  wav_file);
    wav_info = cellfun(@dir, wav_path);
    folder_wav = {fileparts(folder_wav)};

elseif isequal(mode, 'folder')
    msg = sprintf('%s - select wav folders', info_deploy.dataset);
    folder_wav = uigetdir2(base_folder, msg);
    wav_info = [];

    for i = 1:numel(folder_wav)
        wav_info = [wav_info; dir(fullfile(folder_wav{i}, '**/*.wav'))];
    end

end

binary_folder = uigetdir2(fileparts(folder_wav{1}), sprintf('%s - select binary folder', info_deploy.dataset));
binary_info = cellfun(@dir, fullfile(binary_folder, '/**/*.pgdf'), 'UniformOutput', false);
binary_info = vertcat(binary_info{:});

% main
% if all the data of a folder is to be analyzed, use the function main_PG
% if only certains dates are to be analyzed in the data folder,
% create list of selected data and use main_PG in a loop
% /!\ input parameters 2 and 3 must be char type, not string type

% PG2APLOSE(infoAplose, folder_wav{1}, binary_folder{2}, format_datestr, TZ);

if numel(binary_info)== numel(wav_info)
    for i=1:numel(binary_folder)
        PG2APLOSE(info_deploy, folder_wav{1}, binary_folder{i});
    end
else
    error('Number of wav files (%.0f) is different than number of pgdf files (%.0f)', numel(wav_info), numel(binary_info))
end
