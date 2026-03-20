Fs = 44100;
recObj = audiorecorder(Fs, 16, 1);

disp('Start speaking...');
recordblocking(recObj, 5);
disp('Recording finished');

audioData = getaudiodata(recObj);

audiowrite('audio.wav', audioData, Fs);