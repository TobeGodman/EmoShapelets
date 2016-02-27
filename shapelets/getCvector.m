function [C, lMin, lMax] = getCvector(sequences_in)

% get number of sequences supplied
numSequences = length(sequences_in);

% get max length of sequence
maxLength = 0;
minLength = inf;
for i=1:numSequences
	if length(sequences_in{i})>maxLength
		maxLength = length(sequences_in{i});
	end
	if length(sequences_in{i})<minLength
		minLength = length(sequences_in{i});
	end
end

% define subsequence length to extract
lMin = 4; %minLength; %floor(maxLength/4);
lMax = floor(maxLength*3/4);

% initialize C
C = zeros(1, lMax);

% populate each element in C
for i=lMin:lMax

	currLength = i;
	tempSum = 0;

	% for each sequence
	for j=1:numSequences

		% get one channel of current sequence
		currSequenceSingle = sequences_in{j}(1,:);

		% skip sequence if no segments are present
		if currLength>length(currSequenceSingle)
			continue;
		else
			% get length of current sequence
			currSeqLen = length(currSequenceSingle);
			for k=1:currSeqLen-currLength+1
				tempSum = tempSum + 1;
			end
		end
	end

	% update C vector with sum
	C(i) = tempSum;

end

end
    
