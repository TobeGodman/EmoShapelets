% start parallel pool
% NP = str2num(getenv('PBS_NP'));
% myPool = parpool('current', NP);
% start parallel pool
myCluster = parcluster('local');
myCluster.NumWorkers = 12;
parpool;

% add current directory to paths
p = genpath(pwd); addpath(p);
ORIG_PATH = path;

% define input values
dataInputFile = 'emoDB_IS2009_size0.5_step0.25';
emotogramFunName = 'RF';
notes = '';

% add directories
if ~exist('diaries', 'dir')
    mkdir('diaries')
end
diary(['diaries/', dataInputFile, '_', emotogramFunName, '_', notes, '.txt'])
diary on

% call main function
results = main(dataInputFile, emotogramFunName, notes);

diary off

% set original path
path(ORIG_PATH);