function [candidates, candidatesSrc] = generateCandidates_J(sequences, segmentLength)

% get number of sequences supplied
numSequences = length(sequences);

% get max length of sequence
maxLength = 0;
for i=1:numSequences
	if length(sequences{i})>maxLength
		maxLength = length(sequences{i});
	end
end

% return if no segment available
if segmentLength>maxLength
	candidates = [];
	return
end

% figure out worst case number of subsequence
worstCaseSubSeqNum = (maxLength-segmentLength+1)*numSequences;

% initialize for worst case
candidates = zeros(worstCaseSubSeqNum, segmentLength);
candidatesSrc = zeros(worstCaseSubSeqNum, 1);
candidateIdx = 1;

% for each sequence
for i=1:numSequences

	% skip sequence if no segments are present
	if segmentLength>length(sequences{i})
		continue;

	else
		% get length of current sequence
		currSeqLen = length(sequences{i});

		for j=1:currSeqLen-segmentLength+1
			candidates(candidateIdx,:) = sequences{i}(j:j+segmentLength-1);
			candidatesSrc(candidateIdx) = i;
			candidateIdx = candidateIdx + 1;
		end

	end

end

% clean up unfilled fields
candidates(candidateIdx:end,:) = [];
candidatesSrc(candidateIdx:end) = [];
