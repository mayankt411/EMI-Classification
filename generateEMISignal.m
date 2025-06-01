function signal = generateEMISignal(classID, params)
% GENERATEEMISIGNAL
% Generates a synthetic EMI signal for a specified class.
%
% classID:
%   1 = Wi-Fi
%   2 = Bluetooth
%   3 = Peripheral
%   4 = Background Noise
%   5 = Mixed Interference

N = params.samplesPerSegment;
fs = params.fs;

switch classID

    %% Wi-Fi
    case 1

        t = (0:N-1)/fs;

        fc = 70 + 5*randn;

        modulation = ...
            1 + ...
            0.35*cos(2*pi*(4+rand)*t) + ...
            0.15*sin(2*pi*(8+rand)*t);

        signal = ...
            modulation .* sin(2*pi*fc*t);

        signal = signal + ...
            0.12*randn(size(signal));

        signal = signal * ...
            (0.8 + 0.4*rand);


    %% Bluetooth
    case 2

        t = (0:N-1)/fs;

        signal = zeros(1,N);

        burstLength = round(N*0.20);

        numberBursts = randi([2 4]);

        for b = 1:numberBursts

            startIndex = randi( ...
                [1 max(1,N-burstLength)]);

            idx = startIndex:min( ...
                startIndex+burstLength-1,N);

            localT = ...
                (0:length(idx)-1)/fs;

            carrierFreq = ...
                45 + 10*randn;

            burst = ...
                0.55*sin( ...
                2*pi*carrierFreq*localT);

            signal(idx) = ...
                signal(idx) + burst;

        end

        signal = signal + ...
            0.10*randn(size(signal));


    %% Electronic peripherals
    case 3

        t = (0:N-1)/fs;

        switchingFreq = ...
            15 + 10*rand;

        signal = ...
            0.9*sign( ...
            sin(2*pi*switchingFreq*t)) + ...
            0.25*randn(size(t));

        numberImpulses = randi([4 10]);

        for p = 1:numberImpulses

            idx = randi(N);

            width = randi([1 4]);

            idx2 = min(N,idx+width);

            signal(idx:idx2) = ...
                signal(idx:idx2) + ...
                (2+rand)*randn( ...
                1,idx2-idx+1);

        end


    %% Background noise
    case 4

        t = (0:N-1)/fs;

        signal = ...
            0.20*randn(1,N);

        signal = signal + ...
            0.03*sin(2*pi*5*t);


    %% Mixed interference
    case 5

        t = (0:N-1)/fs;

        % Wi-Fi component
        wifiFreq = ...
            65 + 5*randn;

        wifi = ...
            0.45*sin(2*pi*wifiFreq*t) .* ...
            (1+0.3*cos(2*pi*5*t));

        % Bluetooth component
        bluetooth = zeros(1,N);

        for b = 1:3

            burstLength = ...
                round(N*0.15);

            startIndex = randi( ...
                [1 max(1,N-burstLength)]);

            idx = startIndex:min( ...
                startIndex+burstLength-1,N);

            localT = ...
                (0:length(idx)-1)/fs;

            bluetooth(idx) = ...
                bluetooth(idx) + ...
                0.35*sin(2*pi*45*localT);

        end

        % Electronic component
        switching = ...
            0.4*sign(sin(2*pi*18*t));

        % Background noise
        noise = ...
            0.20*randn(size(t));

        signal = ...
            wifi + bluetooth + switching + noise;


    otherwise

        error('Invalid EMI class.');

end

end