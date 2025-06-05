function featureVector = extractFeatures(signal)
% EXTRACTFEATURES
% Extracts the three EMI classification features:
%
% 1. Spectrum Symmetry
% 2. Impulsiveness Ratio
% 3. Envelope Variance

%% Spectrum Symmetry

X = fft(signal);

X_power = abs(X).^2;

N = length(X_power);

fc = round(N/2);

B = round(N/6);

lowerStart = max(1,fc-B);
lowerEnd = max(1,fc-1);

upperStart = min(N,fc+1);
upperEnd = min(N,fc+B);

if lowerEnd >= lowerStart
    P_L = sum(X_power( ...
        lowerStart:lowerEnd));
else
    P_L = 0;
end

if upperEnd >= upperStart
    P_U = sum(X_power( ...
        upperStart:upperEnd));
else
    P_U = 0;
end

P_sym = ...
    (P_L-P_U)/max(P_L+P_U,eps);


%% Impulsiveness Ratio

V_rms = sqrt(mean(signal.^2));

V_avg = mean(abs(signal));

IR = ...
    20*log10( ...
    max(V_rms/max(V_avg,eps),eps));


%% Envelope Variance

analyticSignal = hilbert(signal);

envelope = abs(analyticSignal);

envelopeVariance = var(envelope);


%% Feature vector

featureVector = [
    P_sym
    IR
    envelopeVariance
    ];

end