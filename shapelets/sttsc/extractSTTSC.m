function shapelets_out = extractSTTSC(signals, labels, k)

% get information
[~, minLen, maxLen] = getCvector(signals);
numSequences = length(signals);
kshapelets = repmat(struct('signal', 0, 'src', 0, ...
        'startIdx', 0, 'endIdx', 0, 'quality', 0), 1, k);

% for all time series
for i=1:numSequences
    if ~mod(i,100)
        fprintf('....servicing sequence: %d/%d\n', i, numSequences);
    end

    currSequence = signals{i};

    % initialize shapelets
    shapeLengths = minLen:maxLen;
    numShapeLengths = numel(minLen:maxLen);
    shapelets = cell(numShapeLengths,1);

    parfor l=1:numShapeLengths

        currShapeLength = shapeLengths(l);

        % generate candidates
        [allCandidates, idxSt, idxEn] = generateCandidates(currSequence, currShapeLength);
        if isempty(allCandidates)
            continue;
        end

        shapeletsTemp = repmat(struct('signal', 0, 'src', 0, ...
        'startIdx', 0, 'endIdx', 0, 'quality', 0), 1, size(allCandidates,1));

        % for each candidate
        for j=1:size(allCandidates,1)

            currCandidate = allCandidates(j,:);
            currDistances = findDistances(currCandidate, signals);            
            currQuality = assessCandidate(currDistances, labels);

            shapeletsTemp(j).signal = currCandidate;
            shapeletsTemp(j).src = i;
            shapeletsTemp(j).startIdx = idxSt(j);
            shapeletsTemp(j).endIdx = idxEn(j);
            shapeletsTemp(j).quality = currQuality;            
        end

        shapelets{l} = shapeletsTemp;
    end

    % remove extra allocations
    idx = cellfun(@isempty,shapelets);
    shapelets(idx) = [];
    shapelets = [shapelets{:}];

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