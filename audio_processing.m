clc;
clear;
close all;
[x, fs_audio] = audioread('audio.wav');
if size(x,2) > 1
    x = mean(x, 2);
end
t_audio = (0:length(x)-1)/fs_audio;
noise_audio = 0.02 * randn(size(x));
noisy_audio = x + noise_audio;

% Low Pass Filter
fc_lp = 3000;
[b_lp, a_lp] = butter(4, fc_lp/(fs_audio/2), 'low');
lpf_audio = filtfilt(b_lp, a_lp, noisy_audio);

% High Pass Filter
fc_hp = 500;
[b_hp, a_hp] = butter(4, fc_hp/(fs_audio/2), 'high');
hpf_audio = filtfilt(b_hp, a_hp, noisy_audio);

% Band Pass Filter
fc1 = 500;
fc2 = 3000;
[b_bp, a_bp] = butter(4, [fc1 fc2]/(fs_audio/2), 'bandpass');
bpf_audio = filtfilt(b_bp, a_bp, noisy_audio);

snr_before_audio = 10*log10(sum(x.^2)/sum(noise_audio.^2));
snr_lpf_audio = 10*log10(sum(x.^2)/sum((lpf_audio - x).^2));
snr_hpf_audio = 10*log10(sum(x.^2)/sum((hpf_audio - x).^2));
snr_bpf_audio = 10*log10(sum(x.^2)/sum((bpf_audio - x).^2));

disp('--- AUDIO RESULTS ---');
disp(['SNR Before: ', num2str(snr_before_audio), ' dB']);
disp(['SNR LPF: ', num2str(snr_lpf_audio), ' dB']);
disp(['SNR HPF: ', num2str(snr_hpf_audio), ' dB']);
disp(['SNR BPF: ', num2str(snr_bpf_audio), ' dB']);

figure;
subplot(4,1,1);
plot(t_audio, x);
title('Original Audio');
subplot(4,1,2);
plot(t_audio, noisy_audio);
title('Noisy Audio');
subplot(4,1,3);
plot(t_audio, lpf_audio);
title('LPF Audio');
subplot(4,1,4);
plot(t_audio, bpf_audio);
title('BPF Audio');
disp('Playing Original Audio...');
sound(x, fs_audio);
pause(3);
disp('Playing Noisy Audio...');
sound(noisy_audio, fs_audio);
pause(3);
disp('Playing Filtered Audio...');
sound(bpf_audio, fs_audio);
figure;
snr_values_audio = [snr_before_audio snr_lpf_audio snr_hpf_audio snr_bpf_audio];
bar(snr_values_audio);
set(gca, 'XTickLabel', {'Before','LPF','HPF','BPF'});
title('Audio SNR Comparison');
ylabel('SNR (dB)');
figure;
plot(t_audio, noisy_audio, 'y'); hold on;
plot(t_audio, bpf_audio, 'b');
title('Noisy vs Filtered Audio');
xlabel('Time');
ylabel('Amplitude');
legend('Noisy Audio','Filtered Audio');

figure;
subplot(2,1,1);
spectrogram(noisy_audio, 256, [], [], fs_audio, 'yaxis');
title('Noisy Audio Spectrogram');
subplot(2,1,2);
spectrogram(bpf_audio, 256, [], [], fs_audio, 'yaxis');
title('Filtered Audio Spectrogram');