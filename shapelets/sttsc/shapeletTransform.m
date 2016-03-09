function X_out = shapeletTransform(TS_in, shapelets)

	% get number of sequences and channels
	numSequences = length(TS_in); 
	numChannels = length(shapelets);

	assert(length(shapelets)==numChannels);

	% get total number of shapelets
	numShapelets = 0;
	for i=1:numChannels
		numShapelets = numShapelets + length(shapelets{i});
	end

	% initialize output
	X_out = zeros(numSequences, numShapelets);

	% for each sequence
	for j=1:numSequences
		idx = 1;

		% for each channel
		for i=1:numChannels
			currSequence = TS_in{j}(i,:);

			% for each shapelet
			for k=1:length(shapelets{i})
				currShapelet = shapelets{i}{k};
				[X_out(j,idx), ~] = UCR_DTW_matlab(currSequence, currShapelet, 0.05);
				idx = idx + 1;
			end
		end
	end
end

