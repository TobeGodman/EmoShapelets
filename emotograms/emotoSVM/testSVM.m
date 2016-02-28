function [uar, auroc, posScores] = testSVM(Xte, Yte, model, prob_model)

    options = sprintf('-b %d -q', prob_model);
    [Yhat, ~, posScores] = svmpredict(Yte, Xte, model, options);

    % initialize values
    uar = [];
    auroc = [];

    % construct confusion matrix
    K = numel(model.Label);
    confMat = confusionmat(Yte, Yhat);

    Aii = diag(confMat)';
    Ai = sum(confMat,2)';
    uar = sum(Aii./Ai)./K;

    % if probability model
    if prob_model==1
        posScores = posScores(:,(model.Label(1)==-1)+1);
        [~,~,~,auroc] = perfcurve(Yte, posScores, 1);
        if auroc < 0.5
            fprintf('### AUROC < 0.5 : %f \n', auroc)
            auroc = 1 - auroc;    
        end
    end

end

