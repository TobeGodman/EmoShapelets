function IG = computeIG_J(currDistance, allDistances, labels)

% define number of emotions (labels)
numEmotions = 4;

% get total number of sequences
numLabels = length(labels);

% define array that will hold IG results
IGALL = zeros(1,numEmotions);

% loop over all labels
for i=1:numEmotions

	% get new labels (make sure these are correct)
	newLabels = labels==i;

	% compute P(e)
	P_e = sum(1==newLabels)/numLabels;

	% compute P(~e)
	P_ne = sum(1~=newLabels)/numLabels;

	% compute P(e & s)	
	P_es = sum( (allDistances<=currDistance) & (1==newLabels) )/numLabels;

	% compute P(e & ~s)
	P_ens = sum( (allDistances>currDistance) & (1==newLabels) )/numLabels;

	% compute P(~e & s)
	P_nes = sum( (allDistances<=currDistance) & (1~=newLabels) )/numLabels;	

	% compute P(~e & ~s)
	P_nens = sum( (allDistances>currDistance) & (1~=newLabels) )/numLabels;

	% compute P(s)
	P_s = sum(allDistances<=currDistance)/numLabels;

	% compute P(~s)
	P_ns = sum(allDistances>currDistance)/numLabels;

	% compute IG(e_k|newS) = H(e_k) - H(e_k|newS)
	H_ek = - (P_e*log2(P_e+eps) + P_ne*log2(P_ne+eps));
	H_ek_given_newS = -(P_es*log2(eps+P_s/(P_es+eps)) + P_ens*log2(eps+P_ns/(P_ens+eps)) + ...
						P_nes*log2(eps+P_s/(P_nes+eps))+ P_nens*log2(eps+P_ns/(P_nens+eps)));

	% save this IG	
	IGALL(i) = H_ek - H_ek_given_newS;

end

% set output (do sum for now)
IG = max(IGALL);
