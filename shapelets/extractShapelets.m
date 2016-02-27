function shapelets_out = extractShapelets(signals_in, labels_in)

    % number of shapelets to extract from each channel
    k=250;

    % sanity check
    assert(numel(signals_in)==numel(labels_in))

    % get number of channels
    numChannels = size(signals_in{1}, 1);

    % initialize for each channel
    shapelets_out = cell(numChannels, 1);

    % for each channel
    for i=1:numChannels
        fprintf('..servicing channel %d/%d\n', i, numChannels)

        % get all sequences current channel
        currChannelSignals = getChannelSignals(signals_in, i);

        % run extraction algorithm
        shapelets_out{i} = extractSTTSC(currChannelSignals, labels_in, k);
    end
end


function outputs = getChannelSignals(signals_in, channelToExtract)
    outputs = cell(numel(signals_in),1);
    for j=1:numel(signals_in)
        outputs{j} = signals_in{j}(channelToExtract,:);
    end
end
