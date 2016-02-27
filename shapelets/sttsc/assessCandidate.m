function fScore = assessCandidate(distances_in, labels_in)

    n = length(labels_in);
    uniqueLabels = unique(labels_in);
    numUniqueLabels = numel(uniqueLabels);

    Di = zeros(numUniqueLabels, 1);
    Dall = mean(distances_in);

    den = 0;
    for i=1:numUniqueLabels
    	d_js = distances_in(labels_in==uniqueLabels(i));
    	Di(i) = mean(d_js);
    	den = den + (d_js-Di(i))'*(d_js-Di(i));
    end
    den = den./(n-numUniqueLabels);
    num = ((Di-Dall)'*(Di-Dall)) ./ (numUniqueLabels-1);

    fScore = num./den;

end