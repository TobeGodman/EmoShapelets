function [train_emoto_struct, test_emoto_struct] = generateEmotograms(train_raw_struct, test_raw_struct, emotogramFunName)

    % set generation function
    switch emotogramFunName
        case 'RF'
            tuneFun = @tuneRF_LOSO;
            applyModelsFun = @applyRF_models;            
        case 'SVM'
            tuneFun = @tuneSVM_LOSO;
            applyModelsFun = @applySVM_models;            
        otherwise
            error('unknown Emotogram generation function')
    end

    % get unique number of emotions
    uniqueLabels = unique(train_raw_struct.frameLabels);
    numUniqueLabels = numel(uniqueLabels);

    % initialize predictions matrix
    train_scores = zeros(numel(train_raw_struct.frameLabels), numel(uniqueLabels));
    test_scores = zeros(numel(test_raw_struct.frameLabels), numel(uniqueLabels));

    for i=1:numUniqueLabels
        fprintf('..getting emotogram label %d/%d \n', i, numUniqueLabels)
        currLabel = uniqueLabels(i);

        % transform labels to +1/-1
        trainLabelsT = (train_raw_struct.frameLabels==currLabel)*1;
        trainLabelsT(trainLabelsT==0) = -1;
        testLabelsT = (test_raw_struct.frameLabels==currLabel)*1;
        testLabelsT(testLabelsT==0) = -1;

        fprintf('..optimizing hyper-parameters \n')
        [~, models] = tuneFun(train_raw_struct.frameFeats, trainLabelsT, train_raw_struct.speakerIdx);

        fprintf('..applying models \n')
        [train_scores(:,i), test_scores(:,i)] = applyModelsFun(models, train_raw_struct.frameFeats, ...
                                                    trainLabelsT, train_raw_struct.speakerIdx, ...
                                                    test_raw_struct.frameFeats, testLabelsT);        
    end

    % ------------------------------------------------------------------------
    % form training signals
    % ------------------------------------------------------------------------

    % get number of signals in train
    uniqueTrainSignals = sum(train_raw_struct.frameIdx==1);

    % create a vector for holding signal ID
    trainSignalIDs = zeros(numel(train_raw_struct.frameLabels), 1);
    utt_ID = 0;
    for i=1:numel(trainSignalIDs)
        if train_raw_struct.frameIdx(i)==1
            utt_ID = utt_ID+1;
        end
        trainSignalIDs(i) = utt_ID;
    end

    % form time series
    trainTimeSeries = cell(uniqueTrainSignals, 1);
    for i=1:uniqueTrainSignals
        currSignalID = i;
        idx = (trainSignalIDs==currSignalID);
        trainTimeSeries{i} = train_scores(idx,:)';
    end

    % form labels
    trainTimeSeriesLabels = train_raw_struct.frameLabels(train_raw_struct.frameIdx==1);

    % form speaker IDs
    trainTimeSeriesIDs = train_raw_struct.speakerIdx(train_raw_struct.frameIdx==1);

    % form stats data
    trainTimeSeriesFeats = captureTimeSeriesStats(trainTimeSeries);

    % set outputs
    train_emoto_struct.signals = trainTimeSeries;
    train_emoto_struct.labels = trainTimeSeriesLabels;
    train_emoto_struct.IDs = trainTimeSeriesIDs;
    train_emoto_struct.statFeats = trainTimeSeriesFeats;


    % ------------------------------------------------------------------------
    % form test signals
    % ------------------------------------------------------------------------

    % get number of signals in train
    uniqueTestSignals = sum(test_raw_struct.frameIdx==1);

    % create a vector for holding signal ID
    testSignalIDs = zeros(numel(test_raw_struct.frameLabels), 1);
    utt_ID = 0;
    for i=1:numel(testSignalIDs)
        if test_raw_struct.frameIdx(i)==1
            utt_ID = utt_ID+1;
        end
        testSignalIDs(i) = utt_ID;
    end

    % form time series
    testTimeSeries = cell(uniqueTestSignals, 1);
    for i=1:uniqueTestSignals
        currSignalID = i;
        idx = (testSignalIDs==currSignalID);
        testTimeSeries{i} = test_scores(idx,:)';
    end

    % form labels
    testTimeSeriesLabels = test_raw_struct.frameLabels(test_raw_struct.frameIdx==1);

    % form speaker IDs
    testTimeSeriesIDs = test_raw_struct.speakerIdx(test_raw_struct.frameIdx==1);

    % form stats data
    testTimeSeriesFeats = captureTimeSeriesStats(testTimeSeries);

    % set outputs
    test_emoto_struct.signals = testTimeSeries;
    test_emoto_struct.labels = testTimeSeriesLabels;
    test_emoto_struct.IDs = testTimeSeriesIDs;
    test_emoto_struct.statFeats = testTimeSeriesFeats;

end
