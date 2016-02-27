function speakers_out = main(dataInputFile, emotogramFunName, notes)

    % read input file
    fprintf('\n########### read data ###########\n\n')
    fprintf('..reading input data\n')
    data_full = csvread(['data/', dataInputFile, '.csv']);
    data_speakerIdx = data_full(:,1);
    data_frameIdx = data_full(:,2);
    data_frameLabels = data_full(:,3);
    data_frameFeats = data_full(:,4:end);

    % scale all features
    data_frameFeats = scaleData(data_frameFeats);

    % get data information
    unique_speakerIdx = unique(data_speakerIdx);
    unique_frameLabels = unique(data_frameLabels);
    numSpeakers = numel(unique_speakerIdx);
    numLabels = numel(unique_frameLabels);
    numInstances = numel(data_speakerIdx);
    fprintf('..number of examples: %d\n', numInstances);
    fprintf('..number of speakers: %d\n', numSpeakers);
    fprintf('..number of labels: %d\n', numLabels);

    % get label distribution
    for i=1:numLabels
        fprintf('....label %d: %d/%d\n', unique_frameLabels(i), ... 
                        sum(data_frameLabels==unique_frameLabels(i)), numInstances);
    end

    % initialize results cell
    speakers_out = cell(numSpeakers, 1);

    % loop over all speakers    
    for i=1:numSpeakers        

        % get train and test speakers
        currSpeaker = unique_speakerIdx(i);
        train_raw_struct.speakerIdx = data_speakerIdx(data_speakerIdx~=currSpeaker);
        train_raw_struct.frameIdx = data_frameIdx(data_speakerIdx~=currSpeaker);
        train_raw_struct.frameLabels = data_frameLabels(data_speakerIdx~=currSpeaker);
        train_raw_struct.frameFeats = data_frameFeats(data_speakerIdx~=currSpeaker,:);

        test_raw_struct.speakerIdx = data_speakerIdx(data_speakerIdx==currSpeaker);
        test_raw_struct.frameIdx = data_frameIdx(data_speakerIdx==currSpeaker);
        test_raw_struct.frameLabels = data_frameLabels(data_speakerIdx==currSpeaker);
        test_raw_struct.frameFeats = data_frameFeats(data_speakerIdx==currSpeaker,:);

        % ------------------------------------------------------------------------
        % Emotogram generation
        % ------------------------------------------------------------------------        
        fprintf('\n########### generating Emotograms (speaker %d/%d) ###########\n\n', i, numSpeakers)

        save_file = sprintf([dataInputFile, '_', notes, '_emoto%s_emotoTestSpkr%d.mat'], emotogramFunName, i);
        try
            load(['temp/' save_file]);
            fprintf('..loaded Emotogram data for test speaker %d data \n', i)

        catch
            [train_emoto_struct, test_emoto_struct] = generateEmotograms(train_raw_struct, test_raw_struct, emotogramFunName);
            save(['temp/' save_file], 'train_emoto_struct', 'test_emoto_struct');
        end

        % ------------------------------------------------------------------------
        % print Emotogram stats
        % ------------------------------------------------------------------------
        fprintf('..train Emotogram stats\n')
        printSequencesStats(train_emoto_struct.signals)


        fprintf('..test Emotogram stats\n')


        
        keyboard


        % ------------------------------------------------------------------------
        % Shapelet generation
        % ------------------------------------------------------------------------
        fprintf('\n########### generating shapelets (speaker %d/%d) ###########\n\n', i, numSpeakers)
        save_file = sprintf([dataInputFile, '_' , notes, '_emoto%s_shapeTestSpkr%d.mat'], emotogramFunName, i);
        try
            load(['temp/' save_file]);
            fprintf('..loaded shapelet data for test speaker %d data \n', i)

        catch
            [train_shape_struct, test_shape_struct] = generateShapelets(train_emoto_struct, test_emoto_struct);
            save(['temp/' save_file], 'train_shape_struct', 'test_shape_struct');
        end

        % ------------------------------------------------------------------------
        % print shapelet stats
        % ------------------------------------------------------------------------



        % ------------------------------------------------------------------------
        % save data
        % ------------------------------------------------------------------------
        speakers_out{i}.train_raw_struct = train_raw_struct;
        speakers_out{i}.test_raw_struct = test_raw_struct;
        speakers_out{i}.train_emoto_struct = train_emoto_struct;
        speakers_out{i}.test_emoto_struct = test_emoto_struct;
        speakers_out{i}.train_shape_struct = train_shape_struct;
        speakers_out{i}.test_shape_struct = test_shape_struct;
    end

    % ------------------------------------------------------------------------
    % get results
    % ------------------------------------------------------------------------
    fprintf('### classifying ###\n')

end