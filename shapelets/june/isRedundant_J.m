function output = isRedundant_J(tempShapelet, SS)

% set output to false
output = false;

% check if empty
if isempty(SS)
	return
end

% get shapelet
newS = tempShapelet.shapelet;
alpha = 0.1;

% for each collected shapelet
for i=1:length(SS)

	currShapelet = SS{i}.shapelet;
	currShapeletThresh = SS{i}.d;	

	% compute distance
	[dist, ~] = UCR_DTW_matlab(currShapelet, newS, 0.05);

	if dist<alpha*currShapeletThresh
		output = true;		
		return;
	end
end

end
