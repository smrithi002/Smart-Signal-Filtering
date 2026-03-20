clc;
clear;
close all;
fs = 1000;
t = 0:1/fs:1;
signal = sin(2*pi*50*t);
noise = 0.5 * randn(size(t));
noisy_signal = signal + noise;

% Low Pass Filter
fc_lp = 60;
[b_lp, a_lp] = butter(4, fc_lp/(fs/2), 'low');
lpf_signal = filtfilt(b_lp, a_lp, noisy_signal);

% High Pass Filter
fc_hp = 40;
[b_hp, a_hp] = butter(4, fc_hp/(fs/2), 'high');
hpf_signal = filtfilt(b_hp, a_hp, noisy_signal);

% Band Pass Filter
fc1 = 40;
fc2 = 60;
[b_bp, a_bp] = butter(4, [fc1 fc2]/(fs/2), 'bandpass');
bpf_signal = filtfilt(b_bp, a_bp, noisy_signal);

snr_before = 10*log10(sum(signal.^2) / sum(noise.^2));
snr_lpf = 10*log10(sum(signal.^2) / sum((lpf_signal - signal).^2));
snr_hpf = 10*log10(sum(signal.^2) / sum((hpf_signal - signal).^2));
snr_bpf = 10*log10(sum(signal.^2) / sum((bpf_signal - signal).^2));

disp(['SNR Before Filtering: ', num2str(snr_before), ' dB']);
disp(['SNR After LPF: ', num2str(snr_lpf), ' dB']);
disp(['SNR After HPF: ', num2str(snr_hpf), ' dB']);
disp(['SNR After BPF: ', num2str(snr_bpf), ' dB']);
figure;
subplot(5,1,1);
plot(t, signal);
title('Original Signal');
subplot(5,1,2);
plot(t, noisy_signal);
title('Noisy Signal');
subplot(5,1,3);
plot(t, lpf_signal);
title('Low Pass Filter Output');
subplot(5,1,4);
plot(t, hpf_signal);
title('High Pass Filter Output');
subplot(5,1,5);
plot(t, bpf_signal);
title('Band Pass Filter Output');
figure;
snr_values = [snr_before snr_lpf snr_hpf snr_bpf];
bar(snr_values);
set(gca, 'XTickLabel', {'Before','LPF','HPF','BPF'});
title('SNR Comparison');
ylabel('SNR (dB)');
