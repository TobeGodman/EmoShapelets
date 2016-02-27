function hyperParams = tuneSVM_LOSO(Xtr, Ytr, SrcTr)    

% define hyper-parameters to be searched
C_grid = 2.^(-5:2:4);
gamma_grid = 2.^(-10:2:1);

[p,q] = meshgrid(C_grid, gamma_grid);
pairs = [p(:) q(:)];

% get number of speakers
speakers = unique(SrcTr);
numSpeakers = numel(speakers);

% define variable to hold results 
results = zeros(numSpeakers, size(pairs,1));

% for each speaker
for i=1:numSpeakers

    currSpeaker = speakers(i);

    % get training and validation data
    Xval = Xtr(currSpeaker==SrcTr,:);
    Yval = Ytr(currSpeaker==SrcTr);
    Xtr1 = Xtr(currSpeaker~=SrcTr,:);
    Ytr1 = Ytr(currSpeaker~=SrcTr);

    % for each pair
    for j=1:size(pairs,1)
        params = [];
        params.C = pairs(j,1);
        params.gamma = pairs(j,2);
        model = trainSVM(Xtr1, Ytr1, params, 0);
        [uar, ~, ~] = testSVM(Xval, Yval, model, 0);
        results(i,j) = uar;
        fprintf('......tuning speaker %d/%d; pair %0.2d/%0.2d ==> UAR: %0.4f\n', i, numSpeakers, j, size(pairs,1), uar);
    end
end

% get optimal hyper-parameters
[maxAcc, maxIdx] = max(mean(results));
hyperParams.C = pairs(maxIdx,1);
hyperParams.gamma = pairs(maxIdx,2);

fprintf('......optimal uar: %0.5f%%\n', maxAcc);
fprintf('......optimal parameters: C=%0.5f; gamma=%0.5f\n', hyperParams.C, hyperParams.gamma);

end