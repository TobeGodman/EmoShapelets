function output = assessCandidate_J(in_shapelet, in_signals, in_labels)

% get number of sequences in data
numSequences = length(in_labels);

% initialize L
L = zeros(numSequences,1);

% for each sequence in sequences
for i=1:numSequences

	% if numel(in_shapelet) > numel(in_signals{i})		
		% L(i) = inf;
	% else
		% find shortest distance using UCR suite
		[L(i), ~] = UCR_DTW_matlab(in_signals{i}, in_shapelet, 0.05);
	% end
end

% set maxIG
maxIG = 0;
optDist = 0;

% for each distance
for i=1:numSequences

	% get current distance
	currDistance = L(i);

	% compute IG using this distance
	currIG = computeIG_J(currDistance, L, in_labels);	

	% check against maxIG and update
	if currIG>maxIG
		maxIG = currIG;
		optDist = currDistance;
	end
end

% set output
output.shapelet = in_shapelet;
output.IG = maxIG;
output.d = optDist;
output.L = L;

% assert(isinf(optDist)==0)

end
