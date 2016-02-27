% start parallel pool
% myCluster = parcluster('local');
% myCluster.NumWorkers = 12;
% matlabpool

% define paths
matFileRoot = '~/GoogleDrive/CHAI/data/EmoDB/extracted/MAT/';
methodsFileNameToLoad{1,1} = 'EmotogramData_IS2009_SVM_STTSC';
matFileNameToSave = 'results_EmoDB.mat';

main(matFileRoot, methodsFileNameToLoad, matFileNameToSave)
