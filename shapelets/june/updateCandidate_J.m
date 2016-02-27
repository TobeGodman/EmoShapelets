function output = updateCandidate_J(in_shapelet, in_signals, in_labels)

% will have to run this a number of times
shapelet_to_update = in_shapelet;
oldIG = 0;
newIG = 1;
iter = 0;

% keep updating until no more increase in IG
while (abs(newIG-oldIG) > 0.0000001) && (iter<1000)

	iter = iter + 1;
	% fprintf('*** running DBA iteration %d\n', iter)

	% get original IG
	oldIG = shapelet_to_update.IG;

	% get current shapelet threshold and computed thresholds
	currentThresh = shapelet_to_update.d;
	signalsThresh = shapelet_to_update.L;

	% collect instances < threshold
	collectionIdx = currentThresh<=signalsThresh;
	collection = in_signals(collectionIdx);

	% run DBA on current shapelet and collection
	updatedShapelet = DBA([shapelet_to_update.shapelet; collection]);

	% assess new shapelet
	shapelet_to_update = assessCandidate_J(updatedShapelet, in_signals, in_labels);
	newIG = shapelet_to_update.IG;

	% fprintf('oldIG: %f\n', oldIG)
	% fprintf('newIG: %f\n', newIG)
	% fprintf('newIG-oldIG: %f\n', abs(newIG-oldIG))
end

% set output
output = shapelet_to_update;
