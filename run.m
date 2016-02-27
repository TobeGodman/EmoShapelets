% start parallel pool
NP = str2num(getenv('PBS_NP'));
myPool = parpool('current', NP);

% add current directory to paths
p = genpath(pwd); addpath(p);
ORIG_PATH = path;

% define input values
dataInputFile = 'emoDB_IS2009_size0.5_step0.25';
emotogramFunName = 'RF';
notes = '';

% call main function
results = main(dataInputFile, emotogramFunName, notes);

% set original path
path(ORIG_PATH);