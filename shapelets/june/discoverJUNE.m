function shapelets_out = discoverJUNE(TS_in)

% get number of channels
numChannels = length(TS_in.signals);

% initialize output
shapelets_out = cell(numChannels,1);

% initialize SS_ch
SS_ch = cell(numChannels,1);

% for each channel
for i=1:numChannels
	fprintf('.. current channel (%d/%d)\n', i, numChannels)

	% get time series and labels
	currSignals = TS_in.signals{i};
	currLabels = TS_in.labels;
	currSrcs = TS_in.srcs;

	% get lengths
	[~, lMin, lMax] = getCvector(currSignals);

	% initialize SS_len
	SS_len = cell(1, lMax-lMin+1);
	SS_len_idx = 1;

	% loop over all possible lengths
	for j=lMin:lMax		
		fprintf('.. current length (%d/%d)\n', j, lMax)

 		% get set of shapelets
		SS_len{SS_len_idx} = extractJUNE(currSignals, currLabels, currSrcs, j);
		SS_len_idx = SS_len_idx + 1;
	end

	SS_ch{i} = vertcat(SS_len{:});

	% get number of shapelets in this channel
	numShapelets = length(SS_ch{i});
	shapelets_out{i} = cell(numShapelets, 1);

	for k=1:numShapelets
		currStruct = SS_ch{i}{k};
		shapelets_out{i}{k} = currStruct.shapelet;
	end

end



