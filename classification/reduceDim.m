function [Xtr_out, Xte_out] = reduceDim(Xtr, Ytr, Xte, numFeats)

% first discretize
XtrMean = mean(Xtr);
XtrStd = std(Xtr);

% for each feature
XtrDiscrete = Xtr;
for i=1:numel(XtrMean)

	currMean = XtrMean(i);
	currStd = XtrStd(i);
	currFeats = Xtr(:,i);

	temp1 = (currFeats<=(currMean-currStd*3/2))*1;
	temp2 = ((currFeats>(currMean-currStd*3/2)) & (currFeats<=(currMean-currStd/2)))*2;
	temp3 = ((currFeats>(currMean-currStd/2)) & (currFeats<=(currMean+currStd/2)))*3;
	temp4 = ((currFeats>(currMean+currStd/2)) & (currFeats<=(currMean+currStd*3/2)))*4;
	temp5 = (currFeats>(currMean+currStd*3/2))*5;
	XtrDiscrete(:,i) = temp1 + temp2 + temp3 + temp4 + temp5;	
end

% run MRMR
featsRank = mrmr_mid_d(XtrDiscrete, Ytr, numFeats);

% set outputs
Xtr_out = Xtr(:,featsRank);
Xte_out = Xte(:,featsRank);

