clc; clear all; startup;

% start parallel pool
% NP = str2num(getenv('PBS_NP'));
% myPool = parpool('current', NP);
% start parallel pool
myCluster = parcluster('local');
myCluster.NumWorkers = 12;
% parpool;

% define input values
dataInputFile = 'emoDB_IS2009_size0.5_step0.25';
emotogramFunName = 'RF';
notes = '';

% working directory path
file_name = sprintf([dataInputFile, '_', emotogramFunName, '_', notes]);

% add directories
diary(['diaries/', file_name, '.txt'])
diary on

% call main function
speakers = main(dataInputFile, emotogramFunName, notes);

% save statistics figures
% saveFigs(speakers);

% call classification code
results = classifySpeakers(speakers, file_name);

diary off
