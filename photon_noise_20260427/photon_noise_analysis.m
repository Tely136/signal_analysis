%% Settings
scriptFolder = fileparts(mfilename('fullpath'));
dataFolder = fullfile(scriptFolder, '..', 'data', '20260427');
processingFolder = fullfile(scriptFolder, '..', '..', 'O3_Lidar', 'proc_functions');
addpath(genpath(processingFolder));

channels = [1 2 3 4];
channelLabels = ["287 far", "299 far", "287 near", "299 near"];
backgroundRange_km = [12 24];
frequencyBand_MHz = [0.05 19.5];
exampleChannel = 1;                   % Index into channels
exampleProfiles = [7 14 20 24];
plotRange_km = [15 16];

%% Read and scale signals
% Arrays use [range bin, profile, channel].
[analogCounts, photonCounts, times, configs] = read_lidar_datafiles(dataFolder, "bin", "ol");
analogCounts = analogCounts(:,:,channels);
photonCounts = photonCounts(:,:,channels);

[nBins, nProfiles, nChannels] = size(photonCounts);

binWidth_m = configs(1).binwidth(channels(1));
binDuration_s = 2 * binWidth_m / physconst("LightSpeed");
range_km = (1:nBins)' * binWidth_m / 1000;

countRate_MHz = zeros(size(photonCounts));
analog_mV = zeros(size(analogCounts));
inputRanges_mV = [500 100 20];

for profile = 1:nProfiles
    for channel = 1:nChannels
        id = channels(channel);

        assert(configs(profile).binwidth(id) == binWidth_m && configs(profile).bins(id) == nBins, 'Range grids must match.');
        shots = configs(profile).shots(id);
        fullScale_mV = inputRanges_mV(configs(profile).range(id) + 1);
        adcScale = 2^configs(profile).adcbits(id) - 1;

        countRate_MHz(:,profile,channel) = photonCounts(:,profile,channel) / shots / binDuration_s / 1e6;
        analog_mV(:,profile,channel) = analogCounts(:,profile,channel) * fullScale_mV / adcScale / shots;
    end
end

%% Background metrics and spectra
backgroundBins = range_km >= backgroundRange_km(1) & range_km <= backgroundRange_km(2);
nBackground = nnz(backgroundBins);
assert(nBackground >= 64, 'Choose a background interval containing at least 64 bins.');

frequency_MHz = (0:floor(nBackground/2))' / nBackground / binDuration_s / 1e6;
frequencyBins = find(frequency_MHz > frequencyBand_MHz(1) & frequency_MHz < frequencyBand_MHz(2));
assert(numel(frequencyBins) >= 10, 'Widen the frequency band.');

meanRate_MHz = reshape(mean(countRate_MHz(backgroundBins,:,:),1),nProfiles,nChannels);
varianceRatio = NaN(nProfiles,nChannels);
lag1Correlation = NaN(nProfiles,nChannels);
peakFrequency_MHz = NaN(nProfiles,nChannels);
peakToMedian = NaN(nProfiles,nChannels);
photonPower = zeros(numel(frequency_MHz),nProfiles,nChannels);
analogPower = zeros(size(photonPower));

for channel = 1:nChannels
    for profile = 1:nProfiles
        counts = photonCounts(backgroundBins,profile,channel);
        residual = detrend(counts);
        if mean(counts) > 0
            varianceRatio(profile,channel) = var(residual,1) / mean(counts);
        end
        if std(residual(1:end-1)) > 0 && std(residual(2:end)) > 0
            correlation = corrcoef(residual(1:end-1),residual(2:end));
            lag1Correlation(profile,channel) = correlation(1,2);
        end

        power = windowed_power(counts);
        photonPower(:,profile,channel) = power;
        analogPower(:,profile,channel) = ...
            windowed_power(analogCounts(backgroundBins,profile,channel));
        [~, location] = max(power(frequencyBins));
        peakBin = frequencyBins(location);
        noiseBins = frequencyBins(abs(frequencyBins-peakBin) > 3);
        noiseFloor = median(power(noiseBins));
        if noiseFloor > 0
            peakToMedian(profile,channel) = power(peakBin) / noiseFloor;
            peakFrequency_MHz(profile,channel) = frequency_MHz(peakBin);
        end
    end
end

%% Figure 1: selected photon-counting and analog profiles
exampleProfiles = exampleProfiles(exampleProfiles >= 1 & exampleProfiles <= nProfiles);
assert(~isempty(exampleProfiles), 'Choose valid example profiles.');
labels = compose('Profile %d',exampleProfiles);
figure('Name','Selected profiles'); tiledlayout(2,1);
nexttile;
plot(range_km,countRate_MHz(:,exampleProfiles,exampleChannel));
xlim(plotRange_km); grid on; legend(labels);
title(channelLabels(exampleChannel) + " photon counting");
xlabel('Range (km)'); ylabel('Observed rate (MHz)');
nexttile;
analog = analog_mV(:,exampleProfiles,exampleChannel);
analog = analog - mean(analog(backgroundBins,:),1);
plot(range_km,analog);
xlim(plotRange_km); grid on; legend(labels);
title(channelLabels(exampleChannel) + " analog");
xlabel('Range (km)'); ylabel('Background-subtracted voltage (mV)');

%% Figure 2: photon-counting and analog background spectra
figure('Name','Background spectra'); tiledlayout(2,1);
for panel = 1:2
    nexttile; hold on;
    for profile = exampleProfiles
        if panel == 1
            power = photonPower(:,profile,exampleChannel);
        else
            power = analogPower(:,profile,exampleChannel);
        end
        power = power / max(median(power(frequencyBins)),eps);
        semilogy(frequency_MHz,max(power,realmin));
    end
    set(gca,'YScale','log'); xlim(frequencyBand_MHz); grid on; legend(labels);
    xlabel('Time-of-flight frequency (MHz)'); ylabel('Power / median power');
end
nexttile(1); title(channelLabels(exampleChannel) + " photon-counting spectrum");
nexttile(2); title(channelLabels(exampleChannel) + " analog spectrum");

%% Figure 3: background metrics across profiles
figure('Name','Background metrics'); tiledlayout(2,2);
values = {meanRate_MHz, varianceRatio, lag1Correlation, peakToMedian};
names = {'Mean count rate (MHz)','Variance / mean','Adjacent-bin correlation','Spectral peak / median'};
for panel = 1:4
    nexttile;
    plot(1:nProfiles,values{panel},'.-');
    grid on; xlabel('Profile'); ylabel(names{panel}); legend(channelLabels);
    if panel == 2, yline(1,'--','Poisson reference'); end
    if panel == 3, yline(0,'--'); end
end

%% Spectrum calculation
function power = windowed_power(samples)
% Linear detrend and periodic Hann window; one-sided power per FFT bin.
n = numel(samples);
window = 0.5 - 0.5*cos(2*pi*(0:n-1)'/n);
transform = fft(detrend(samples(:)) .* window);
power = abs(transform(1:floor(n/2)+1)).^2 / sum(window)^2;
power(2:end) = 2 * power(2:end);
if mod(n,2) == 0, power(end) = power(end)/2; end
end
