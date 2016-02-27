function [candidates, idxSt, idxEn] = generateCandidates(sequence_in, segmentLen_in)

if length(sequence_in)<segmentLen_in
	candidates = [];
	idxSt = [];
	idxEn = [];

else
	numOfCandidates = length(sequence_in)-segmentLen_in+1;
	candidates = zeros(numOfCandidates, segmentLen_in);
	idxSt = zeros(numOfCandidates,1);
	idxEn = zeros(numOfCandidates,1);

	for i=1:numOfCandidates
		candidates(i,:) = sequence_in(1,i:i+segmentLen_in-1);
		idxSt(i) = i;
		idxEn(i) = i+segmentLen_in-1;
	end


end
