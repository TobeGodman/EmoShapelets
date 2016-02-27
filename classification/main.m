function [] = main(matFileRoot, methodsFileNameToLoad, matFileNameToSave)

% get number of methods
numMethods = length(methodsFileNameToLoad);

% add paths
ORIG_PATH = path;
p = genpath('~/GoogleDrive/CHAI/apps/libsvm-3.21/matlab'); addpath(p);
p = genpath('~/GoogleDrive/CHAI/apps/mrmr_d_matlab_src'); addpath(p);
p = genpath('~/GoogleDrive/CHAI/code/SVM'); addpath(p);
p = genpath(pwd); addpath(p);

% define frame size and frame steps values
frameSize_frameStep = {'0.5', '0.25' };

% loop over each frame size-step pair 
for i=1:size(frameSize_frameStep,1)
    fprintf('Running size-step pair: %d/%d\n', i, size(frameSize_frameStep,1));

    % get current frame and step sizes
    frameSize = frameSize_frameStep{i,1};
    frameStep = frameSize_frameStep{i,2};

    % initialize results cell
    results = cell(1,numMethods);

    % for each method
    for j=1:numMethods        

        % read data file
        load([matFileRoot, 'frameSize', frameSize, '_frameStep', frameStep, '/' methodsFileNameToLoad{j}]);
        assert(exist('speakers', 'var')==1)
        speakers = speakers;

        % get global data
        speakers = getEmotogramFeats(speakers);

        % get number of speakers
        numSpeakers = length(speakers);        

        % initialize method results
        methodResultsShape = zeros(numSpeakers,1);
        methodResultsStats = zeros(numSpeakers,1);        
        methodResultsBoth = zeros(numSpeakers,1);

        % for each speaker
        for k=1:numSpeakers
            fprintf('*** speaker (%d/%d); method (%d/%d) ***\n', k, numSpeakers, j, numMethods)
            
            %%%%%%%%%%%    Shapelet features   %%%%%%%%%%%

            % get shapelet data
            Xtr1 = speakers(k).shapeletData.Xtr;
            Ytr = speakers(k).shapeletData.Ytr;
            srcTr = speakers(k).shapeletData.Srctr;
            Xte1 = speakers(k).shapeletData.Xte;
            Yte = speakers(k).shapeletData.Yte;

            % apply dimensionality reduction
            [Xtr1, Xte1] = reduceDim(Xtr1, Ytr, srcTr, Xte1);

            % scale data
            XScaled = scaleData([Xtr1; Xte1]);
            Xtr1 = XScaled(1:size(Xtr1,1),:);
            Xte1 = XScaled(size(Xtr1,1)+1:end,:);

            % tune, train, and test SVM
            params = tuneSVM_LOSO(Xtr1, Ytr, srcTr);
            model = trainSVM(Xtr1, Ytr, params);
            [uar, ~] = testSVM(Xte1, Yte, model);

            % put into method results
            methodResultsShape(k) = uar;

            %%%%%%%%%%%    stats features   %%%%%%%%%%%

            % get shapelet data
            Xtr2 = speakers(k).EmotoStatsData.Xtr;
            Ytr = speakers(k).EmotoStatsData.Ytr;
            srcTr = speakers(k).EmotoStatsData.Srctr;
            Xte2 = speakers(k).EmotoStatsData.Xte;
            Yte = speakers(k).EmotoStatsData.Yte;

            % scale data
            XScaled = scaleData([Xtr2; Xte2]);
            Xtr2 = XScaled(1:size(Xtr2,1),:);
            Xte2 = XScaled(size(Xtr2,1)+1:end,:);         

            % tune, train, and test SVM
            params = tuneSVM_LOSO(Xtr2, Ytr, srcTr);
            model = trainSVM(Xtr2, Ytr, params);
            [uar, ~] = testSVM(Xte2, Yte, model);

            % put into method results
            methodResultsStats(k) = uar;

            %%%%%%%%%%%    combined features   %%%%%%%%%%%

            % combine features
            Xtr3 = [Xtr1, Xtr2];
            Xte3 = [Xte1, Xte2];

            % apply dimensionality reduction
            [Xtr3, Xte3] = reduceDim(Xtr3, Ytr, srcTr, Xte3);

            % tune, train, and test SVM
            params = tuneSVM_LOSO(Xtr3, Ytr, srcTr);
            model = trainSVM(Xtr3, Ytr, params);
            [uar, ~] = testSVM(Xte3, Yte, model);

            % put into method results
            methodResultsBoth(k) = uar;
        end

        % put into overall results
        results{j}.methodResultsShape = methodResultsShape;
        results{j}.methodResultsStats = methodResultsStats;
        results{j}.methodResultsBoth = methodResultsBoth;
    end

    % save all results    
    save([matFileRoot, 'frameSize', frameSize, '_frameStep', frameStep, '/' matFileNameToSave], 'results');
end


% set original path
path(ORIG_PATH);

end