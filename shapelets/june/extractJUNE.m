function SS = extractJUNE(in_signals, in_labels, in_srcs, in_len)

% generate initial set of shapelets
allShapelets = generateCandidates_J(in_signals, in_len);

% initialize output list
SS = cell(size(allShapelets, 1), 1);
SS_idx = 1;

% for each shapelet
for i=1:size(allShapelets, 1)
	if mod(i, 200)==0		
		fprintf('....servicing shapelet (%d/%d)\n', i, size(allShapelets, 1))
	end	

	% assess and update candidate
	tempShapelet = assessCandidate_J(allShapelets(i,:), in_signals, in_labels);
	tempShapelet = updateCandidate_J(tempShapelet, in_signals, in_labels);

	% check for redundancy 
	redundant = isRedundant_J(tempShapelet, SS(1:SS_idx-1));

	% add to LL
	if redundant==0		
		SS{SS_idx} = tempShapelet;
		SS_idx = SS_idx + 1;
	end
	
end

% clean SS
SS(SS_idx:end) = [];

end