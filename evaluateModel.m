function results = evaluateModel( ...
    modelData,params)
% EVALUATEMODEL
% Evaluates the trained k-NN classifier.

%% Prediction

YPred = predict( ...
    modelData.model, ...
    modelData.XTest);


%% Accuracy

accuracy = ...
    mean(YPred == modelData.YTest)*100;


%% Confusion matrix

confMat = confusionmat( ...
    modelData.YTest, ...
    YPred);


%% Per-class metrics

precision = zeros( ...
    params.numClasses,1);

recall = zeros( ...
    params.numClasses,1);

F1 = zeros( ...
    params.numClasses,1);


for c = 1:params.numClasses

    TP = confMat(c,c);

    FP = sum(confMat(:,c))-TP;

    FN = sum(confMat(c,:))-TP;

    precision(c) = ...
        TP/max(TP+FP,eps);

    recall(c) = ...
        TP/max(TP+FN,eps);

    F1(c) = ...
        2*precision(c)*recall(c) / ...
        max(precision(c)+recall(c),eps);

end


%% Store results

results.predictions = YPred;

results.accuracy = accuracy;

results.confusionMatrix = confMat;

results.precision = precision;

results.recall = recall;

results.F1 = F1;

results.macroPrecision = ...
    mean(precision)*100;

results.macroRecall = ...
    mean(recall)*100;

results.macroF1 = ...
    mean(F1)*100;

end