function params = parameters()
% PARAMETERS
% Central configuration for EMI classification experiment

params.fs = 1000;

params.segmentDuration = 0.2;

params.samplesPerSegment = ...
    round(params.fs * params.segmentDuration);

params.numClasses = 5;

params.samplesPerClass = 500;

params.totalSamples = ...
    params.numClasses * params.samplesPerClass;

params.trainRatio = 0.70;

params.k = 11;

params.cvFolds = 5;

params.randomSeed = 42;

params.classNames = {
    'Wi-Fi'
    'Bluetooth'
    'Peripheral'
    'Background Noise'
    'Mixed Interference'
    };

end