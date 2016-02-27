function [train_scores, test_scores] = applyRF_models(models, Xtr, Ytr, IDstr, Xte, Yte)

    train_scores = zeros(numel(Ytr), 1);
    test_scores = zeros(numel(Yte), 1);

    % loop over all models
    for i=1:numel(models)
        currSpkr = models(i).ID;
        currModel = models(i).model;
        currXtr = Xtr(IDstr==currSpkr,:);
        currYtr = Ytr(IDstr==currSpkr,:);
        [~, ~, train_scores(IDstr==currSpkr)] = testRF(currXtr, currYtr, currModel);

        [~, ~, test_scores_temp] = testRF(Xte, Yte, currModel);
        test_scores = test_scores + test_scores_temp;
    end

    test_scores = test_scores./numel(models);
end