function saveFigs(speakers)
    
    % ------------------------------------------------------------------------
    % emotograms sequences
    % ------------------------------------------------------------------------

    % get all sequences from all speakers
    signals_all = [];
    for i=1:length(speakers)
        signals_all = [signals_all; speakers{i}.test_emoto_struct.signals];
    end

    lengths_all = zeros(length(signals_all), 1);
    idx = 1;
    for i=1:length(speakers)
        for j=1:length(speakers{i}.test_emoto_struct.signals)
            lengths_all(idx) = size(speakers{i}.test_emoto_struct.signals{j}, 2);
            idx = idx + 1;
        end
    end

    % convert to time
    lengths_all = (lengths_all-1)*0.25 + 0.5;

    % ------------------------------------------------------------------------
    % shapelet sequences
    % ------------------------------------------------------------------------

    % get all sequences from all speakers
    signals_all = [];
    for i=1:length(speakers)
        signals_all = [signals_all; speakers{i}.test_shape_struct.shapelets{4}];
    end

    lengths_all = zeros(length(signals_all), 1);
    idx = 1;
    for i=1:length(speakers)
        for j=1:length(speakers{i}.test_shape_struct.shapelets{4})
            lengths_all(idx) = size(speakers{i}.test_shape_struct.shapelets{4}{j}, 2);
            idx = idx + 1;
        end
    end

    % convert to time
    lengths_all = (lengths_all-1)*0.25 + 0.5;
    histogram(lengths_all)
    xlabel('Length (Seconds)')
    ylabel('Frequency')
end
