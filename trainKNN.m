function modelData = trainKNN( ...
    features,labels,params)

%% Stratified train/test split

trainIdx = false( ...
    length(labels),1);

testIdx = false( ...
    length(labels),1);

for c = 1:params.numClasses

    indices = find(labels == c);

    indices = ...
        indices(randperm(length(indices)));

    nTrain = round( ...
        params.trainRatio * ...
        length(indices));

    trainIdx(indices(1:nTrain)) = true;

    testIdx(indices(nTrain+1:end)) = true;

end


%% Training and testing data

XTrain = features(trainIdx,:);
YTrain = labels(trainIdx);

XTest = features(testIdx,:);
YTest = labels(testIdx);


%% Z-score normalization

mu = mean(XTrain,1);

sigma = std(XTrain,[],1);

sigma(sigma == 0) = 1;

XTrainNorm = ...
    (XTrain-mu)./sigma;

XTestNorm = ...
    (XTest-mu)./sigma;


%% k-NN model

knnModel = fitcknn( ...
    XTrainNorm, ...
    YTrain, ...
    'NumNeighbors',params.k, ...
    'Distance','euclidean', ...
    'DistanceWeight','equal', ...
    'Standardize',false);


%% Five-fold cross-validation

cvModel = crossval( ...
    knnModel, ...
    'KFold',params.cvFolds);

cvLoss = kfoldLoss(cvModel);

cvAccuracy = ...
    (1-cvLoss)*100;


%% Store everything

modelData.model = knnModel;

modelData.XTrain = XTrainNorm;
modelData.YTrain = YTrain;

modelData.XTest = XTestNorm;
modelData.YTest = YTest;

modelData.mu = mu;
modelData.sigma = sigma;

modelData.cvAccuracy = cvAccuracy;

end