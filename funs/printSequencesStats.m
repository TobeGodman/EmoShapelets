function [] = printSequencesStats(sequences_in)

    % get number of sequences
    numSequences = numel(sequences_in);

    % initialize vector of lengths
    lengthVec = zeros(numSequences,1);

    % populate vector
    for i=1:numSequences
        lengthVec(i) = size(sequences_in{i},2);         
    end

    % tabulate and display
    tabulate(lengthVec);
end