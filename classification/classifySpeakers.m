function results = classifySpeakers(speakers_in, file_name)

    % get number of speakers
    numSpeakers = numel(speakers_in);

    % initialize results vectors
    results_stats = zeros(numSpeakers+1,1);
    results_shapes = zeros(numSpeakers+1,1);
    results_combined = zeros(numSpeakers+1,1);

    for i=1:numSpeakers
        % --------------------------------------------------------------------
        % get stats results
        % --------------------------------------------------------------------
        % get train and test data
        currSpeaker = speakers_in{i};
        Xtr1 = currSpeaker.train_emoto_struct.statFeats;
        Ytr1 = currSpeaker.train_emoto_struct.labels;
        IDtr1 = currSpeaker.train_emoto_struct.IDs;

        Xte1 = currSpeaker.test_emoto_struct.statFeats;
        Yte1 = currSpeaker.test_emoto_struct.labels;

        % scale data
        XScaled = scaleData([Xtr1; Xte1]);
        Xtr1 = XScaled(1:size(Xtr1,1),:);
        Xte1 = XScaled(size(Xtr1,1)+1:end,:);

        % tune, train, and test SVM
        params = tuneSVM_LOSO(Xtr1, Ytr1, IDtr1);
        model = trainSVM(Xtr1, Ytr1, params, 0);
        [uar, ~] = testSVM(Xte1, Yte1, model, 0);
        results_stats(i) = uar;

        % --------------------------------------------------------------------
        % get shapelet results
        % --------------------------------------------------------------------
        % get train and test data
        currSpeaker = speakers_in{i};
        Xtr2 = currSpeaker.train_shape_struct.shapeletsFeats;
        Ytr2 = currSpeaker.train_shape_struct.labels;
        IDtr2 = currSpeaker.train_shape_struct.IDs;

        Xte2 = currSpeaker.test_shape_struct.shapeletsFeats;
        Yte2 = currSpeaker.test_shape_struct.labels;

        % dimensionality reduction
        dim = size(Xtr1,2);        
        [Xtr2, Xte2] = reduceDim(Xtr2, Ytr2, Xte2, dim);

        % scale data
        XScaled = scaleData([Xtr2; Xte2]);
        Xtr2 = XScaled(1:size(Xtr2,1),:);
        Xte2 = XScaled(size(Xtr2,1)+1:end,:);

        % tune, train, and test SVM
        params = tuneSVM_LOSO(Xtr2, Ytr2, IDtr2);
        model = trainSVM(Xtr2, Ytr2, params, 0);
        [uar, ~] = testSVM(Xte2, Yte2, model, 0);
        results_shapes(i) = uar;

        % --------------------------------------------------------------------
        % get combined results
        % --------------------------------------------------------------------
        % combine features
        Xtr3 = [Xtr1, Xtr2];
        Xte3 = [Xte1, Xte2];

        % apply dimensionality reduction
        [Xtr3, Xte3] = reduceDim(Xtr3, Ytr2, Xte3, dim);

        % tune, train, and test SVM
        params = tuneSVM_LOSO(Xtr3, Ytr2, IDtr2);
        model = trainSVM(Xtr3, Ytr2, params, 0);        
        [uar, ~] = testSVM(Xte3, Yte2, model, 0);

        % put into method results
        results_combined(i) = uar;
    end

    % get the mean
    results_stats(numSpeakers+1) = mean(results_stats(1:numSpeakers));
    results_shapes(numSpeakers+1) = mean(results_shapes(1:numSpeakers));
    results_combined(numSpeakers+1) = mean(results_combined(1:numSpeakers));

    % set output
    results.results_stats = results_stats;
    results.results_shapes = results_shapes;
    results.results_combined = results_combined;
    
    % save outputs as text
    dlmwrite(['temp/', file_name,'.txt'], [results_stats, results_shapes, results_combined]);


end