function X_out = captureTimeSeriesStats(timeSeries_in)

    assert(iscell(timeSeries_in))
    dim = 6*4+1;

    % initialize
    numInstances = numel(timeSeries_in);
    X_out = zeros(numInstances, dim);

    % for each signal
    for i=1:numel(timeSeries_in)
        X_out(i,:) = extractFeats(timeSeries_in{i});
    end
end

function feats_out = extractFeats(signal_in)

    meanFeats = mean(signal_in,2);
    stdFeats = std(signal_in, [], 2);
    [maxFeats, maxLocFeats] = max(signal_in, [], 2);
    [minFeats, minLocFeats] = min(signal_in, [], 2);

    feats_out = [meanFeats', stdFeats', maxFeats', maxLocFeats', ...
                 minFeats', minLocFeats', size(signal_in,2)];
end
