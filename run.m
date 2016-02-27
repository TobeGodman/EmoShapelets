% start parallel pool
% NP = str2num(getenv('PBS_NP'));
% myPool = parpool('current', NP);
% start parallel pool
% myCluster = parcluster('local');
% myCluster.NumWorkers = 12;
% parpool;

% define input values
dataInputFile = 'emoDB_IS2009_size0.5_step0.25';
emotogramFunName = 'RF';
notes = '';

% add directories
diary(['diaries/', dataInputFile, '_', emotogramFunName, '_', notes, '.txt'])
diary on

% call main function
speakers = main(dataInputFile, emotogramFunName, notes);

% call classification code
results = classifySpeakers(speakers);

diary off
