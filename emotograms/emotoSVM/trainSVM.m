function model = trainSVM(Xtr, Ytr, params, prob_model)

% compute class weights (to deal with imbalance)
% higher weight --> more emphasis
% Cp1 = sum(Ytr==-1)/numel(Ytr);
% Cn1 = sum(Ytr==1)/numel(Ytr);
Cp1 = sum(Ytr==-1);
Cn1 = sum(Ytr==1);

options = sprintf('-c %0.10f -g %0.10f -b %d -q -w1 %0.1f -w-1 %0.1f', ...
                        params.C, params.gamma, prob_model, Cp1, Cn1);
model = svmtrain(Ytr, Xtr, options);

end