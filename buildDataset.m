function [features, labels, exampleSignals] = ...
    buildDataset(params)
% BUILDDATASET
% Generates the complete synthetic EMI dataset.

features = zeros( ...
    params.totalSamples,3);

labels = zeros( ...
    params.totalSamples,1);

exampleSignals = cell( ...
    params.numClasses,1);

counter = 1;

for classID = 1:params.numClasses

    for sampleID = 1:params.samplesPerClass

        signal = generateEMISignal( ...
            classID,params);

        featureVector = ...
            extractFeatures(signal);

        features(counter,:) = ...
            featureVector';

        labels(counter) = classID;

        if sampleID == 1
            exampleSignals{classID} = signal;
        end

        counter = counter + 1;

    end

end

end