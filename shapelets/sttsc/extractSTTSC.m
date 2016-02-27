function shapelets_out = extractSTTSC(signals, labels, k)

% get information
[~, minLen, maxLen] = getCvector(signals);
numSequences = length(signals);
kshapelets = repmat(struct('signal', 0, 'src', 0, ...
        'startIdx', 0, 'endIdx', 0, 'quality', 0), 1, k);

% for all time series
for i=1:numSequences
    fprintf('....servicing sequence: %d/%d\n', i, numSequences);

    currSequence = signals{i};
    currSequenceLen = length(currSequence);

    % initialize for worst case
    worstCaseN = currSequenceLen*currSequenceLen;     
    shapelets = repmat(struct('signal', 0, 'src', 0, ...
        'startIdx', 0, 'endIdx', 0, 'quality', 0), 1, worstCaseN);    
    idx = 1;

    for l=minLen:maxLen

        % generate candidates
        [allCandidates, idxSt, idxEn] = generateCandidates(currSequence, l);
        if isempty(allCandidates)
            continue;
        end

        % for each candidate
        for j=1:size(allCandidates,1)

            currCandidate = allCandidates(j,:);
            currDistances = findDistances(currCandidate, signals);            
            currQuality = assessCandidate(currDistances, labels);

            shapelets(idx).signal = currCandidate;
            shapelets(idx).src = i;
            shapelets(idx).startIdx = idxSt(j);
            shapelets(idx).endIdx = idxEn(j);
            shapelets(idx).quality = currQuality;
            idx = idx + 1;
        end
    end
    
    % remove extra allocations
    shapelets(idx:end) = [];

    % sort shapelets by quality
    qualities = [shapelets(:).quality];
    [~, sortIdx] = sort(qualities, 'descend');
    shapelets = shapelets(sortIdx);

    % remove self similar
    shapelets = removeSelfSimilar(shapelets);

    % merge
    kshapelets = mergeShapelets(kshapelets, shapelets);
end

% set output
shapelets_out = {kshapelets(:).signal}';

end