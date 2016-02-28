function [hyperParams, models] = tuneRF_LOSO(Xtr, Ytr, SrcTr)

    % get dimension of Xtr
    [~, dim] = size(Xtr);

    % define hyper-parameters to be searched
    mtry_grid = [floor(sqrt(dim)), floor(dim/10):floor(dim/10):floor(dim/2)];

    % get number of speakers
    uniqueSpkrIDs = unique(SrcTr);
    numSpkrs = numel(uniqueSpkrIDs);

    % define variables to hold temp_results  and models
    temp_results = zeros(numSpkrs, numel(mtry_grid));
    temp_models = repmat(struct('model', [], 'ID', []), numSpkrs, numel(mtry_grid));

    % for each speaker
    for i=1:numSpkrs

        currSpeaker = uniqueSpkrIDs(i);

        % get training and validation data
        Xval = Xtr(currSpeaker==SrcTr,:);
        Yval = Ytr(currSpeaker==SrcTr);
        Xtr1 = Xtr(currSpeaker~=SrcTr,:);
        Ytr1 = Ytr(currSpeaker~=SrcTr);

        % for each param value
        for j=1:numel(mtry_grid)
            params = [];
            params.mtry = mtry_grid(j);
            model = trainRF(Xtr1, Ytr1, params);
            [uar, ~, ~] = testRF(Xval, Yval, model);
            temp_results(i,j) = uar;
            temp_models(i,j).model = model;
            temp_models(i,j).ID = currSpeaker;
            fprintf('....tuning speaker %d/%d; pair %0.2d/%0.2d ==> UAR: %0.4f\n', i, numSpkrs, j, numel(mtry_grid), uar);
        end
    end

    % get optimal hyper-parameters
    [maxAcc, maxIdx] = max(mean(temp_results));
    hyperParams.mtry = mtry_grid(maxIdx);

    % get models for these speakers
    models = temp_models(:,maxIdx);

    fprintf('....optimal UAR: %0.5f\n', maxAcc);
    fprintf('....optimal parameters: mtry=%0.5f\n', hyperParams.mtry);

end