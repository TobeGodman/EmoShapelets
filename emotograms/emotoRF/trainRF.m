function model = trainRF(Xtr, Ytr, params)

    NumTrees = 5;
    NumPredictorsToSample = params.mtry;
    options = statset('UseParallel', 1);
    model = TreeBagger(NumTrees, Xtr, Ytr, 'NumPredictorsToSample', NumPredictorsToSample, 'Options', options, 'NumPrint', 0);

end