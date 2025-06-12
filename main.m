%% ============================================================
% MAIN EMI CLASSIFICATION EXPERIMENT
% ============================================================

clear;
close all;
clc;

%% Configuration

params = parameters();

rng(params.randomSeed);


%% Generate dataset

fprintf('\nGenerating EMI dataset...\n');

[features,labels,exampleSignals] = ...
    buildDataset(params);


%% Dataset summary

fprintf('\nDataset:\n');

for c = 1:params.numClasses

    fprintf('%-20s : %d samples\n', ...
        params.classNames{c}, ...
        sum(labels == c));

end


%% Train classifier

fprintf('\nTraining k-NN...\n');

modelData = trainKNN( ...
    features, ...
    labels, ...
    params);


%% Evaluate classifier

results = evaluateModel( ...
    modelData, ...
    params);


%% Results

fprintf('\n');
fprintf('============================================\n');
fprintf('              EMI RESULTS\n');
fprintf('============================================\n');

fprintf('k-NN k value       : %d\n',params.k);

fprintf('Training samples   : %d\n', ...
    length(modelData.YTrain));

fprintf('Testing samples    : %d\n', ...
    length(modelData.YTest));

fprintf('5-fold CV accuracy : %.2f%%\n', ...
    modelData.cvAccuracy);

fprintf('Test accuracy      : %.2f%%\n', ...
    results.accuracy);

fprintf('Macro precision    : %.2f%%\n', ...
    results.macroPrecision);

fprintf('Macro recall       : %.2f%%\n', ...
    results.macroRecall);

fprintf('Macro F1-score     : %.2f%%\n', ...
    results.macroF1);

fprintf('============================================\n');


%% Per-class results

fprintf('\nPer-Class Performance\n');

fprintf('%-20s %10s %10s %10s\n', ...
    'Class','Precision','Recall','F1');

fprintf('------------------------------------------------\n');

for c = 1:params.numClasses

    fprintf('%-20s %9.2f%% %9.2f%% %9.2f%%\n', ...
        params.classNames{c}, ...
        results.precision(c)*100, ...
        results.recall(c)*100, ...
        results.F1(c)*100);

end


%% Save dataset

datasetTable = array2table( ...
    features, ...
    'VariableNames', ...
    {'P_sym','IR','EnvelopeVariance'});

datasetTable.Class = categorical( ...
    labels, ...
    1:params.numClasses, ...
    params.classNames);

if ~exist('data','dir')
    mkdir('data');
end

writetable( ...
    datasetTable, ...
    'data/EMI_Feature_Dataset.csv');


%% Save results

if ~exist('results','dir')
    mkdir('results');
end

save( ...
    'results/EMI_Classification_Results.mat', ...
    'results', ...
    'modelData', ...
    'params');


fprintf('\nDataset and results saved.\n');