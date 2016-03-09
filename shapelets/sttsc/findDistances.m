function distances_out = findDistances(subsequence_in, all_sequences_in)

    numSequences = length(all_sequences_in);
    distances_out = zeros(numSequences,1);

    for i=1:numSequences
        [distances_out(i), ~] = UCR_DTW_matlab(all_sequences_in{i}, subsequence_in, 0.05);
    end

end
