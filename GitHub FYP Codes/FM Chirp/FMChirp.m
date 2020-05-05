% FM Chirp

Fs = 96000;                                 % Sampling Frequency (Hz)
Tmax = 0.05;                                % Duration (sec)
t = 0:1/Fs:(Tmax-2/Fs);
f0 = 5000;                                  %Start Freq
f1 = 25000;                                 %End Freq
x1 = chirp(t,f0,Tmax,f1);
z = zeros(1);                           	%Zero Padding
x = [x1 z];

Desired_length = 15;                        %Play the signal for 15 seconds
num_samples = round(Desired_length*Fs); 
num_repeats = ceil(num_samples/length(x));
x_long = repmat(x,1,num_repeats);


%BPF the FM Chirp before sending it out
bpf = designfilt('bandpassiir','FilterOrder',10, ...
    'HalfPowerFrequency1',14e3,'HalfPowerFrequency2',22e3, ...
    'DesignMethod','butter','SampleRate',96e3);

bandpasssignal = filtfilt(bpf,x_long);


% sound(bandpasssignal,Fs);             %play the signal

%double check the signal sending out
figure;
spectrogram(bandpasssignal,96,0,96,96e3,'yaxis');