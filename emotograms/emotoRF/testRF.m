function [uar, auroc, posScores] = testRF(Xte, Yte, model)

    % make predictions
    [Yhat, scores] = model.predict(Xte);
    Yhat = str2double(Yhat);

    % get positive prediction scores and set outputs
    posScores = scores(:,(strcmp(model.ClassNames(1),'-1')+1));
    [~,~,~,auroc] = perfcurve(Yte,posScores,1);

    % construct confusion matrix
    K = numel(model.ClassNames);
    confMat = confusionmat(Yte, Yhat);
    Aii = diag(confMat)';
    Ai = sum(confMat,2)';
    uar = sum(Aii./Ai)./K;

end