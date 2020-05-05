% Record for 10 seconds of data

Fs = 96000;
recObj = audiorecorder(Fs, 16, 2);

disp('Start speaking.') 
recordblocking(recObj, 10);
disp('End of Recording.');


% Store raw recorded data
myRecording = getaudiodata(recObj);


%filename = '032020powersupply17kHz9msburstcycle200set8.mat';
filename = '03282020chirpsignal25kHz150set4.mat';

%filename =  '03202017kHz9msburstcycle20030cmleftset4.mat';
%filename = '03282020chirpsignal25kHz17545cmleftset4.mat';

% filename = '03202017kHz9msburstcycle20050cmrightset4.mat';
 %filename = '03282020chirpsignal25kHz20045cmrightset3.mat';

save(filename, 'myRecording','Fs');
 
%this is for storing processed data which will be used at the last few
%lines of the code
filename2 = '200set3.mat';


%Variables used for the loops in the code

factor=480;
z=199;                  %Number of individual period data sets
numfreq=5;              %Number of frequencies used

%BandPass filter the recorded signal
bpf = designfilt('bandpassiir','FilterOrder',10, ...
    'HalfPowerFrequency1',15e3,'HalfPowerFrequency2',21e3, ...
    'DesignMethod','butter','SampleRate',96e3);

filteredRecording = filtfilt(bpf,myRecording);

%Time Shift the both channel to approximate starting location of the recording and reshape them into individual periods

[M,I]=max(filteredRecording(1:4800,1));

startpulse1=I-1500;

circRecording1=circshift(filteredRecording(:,1),-startpulse1);

shiftedRecording1= reshape(circRecording1(:,1),4800,[],1);

circRecording2=circshift(filteredRecording(:,2),-startpulse1);

shiftedRecording2= reshape(circRecording2(:,1),4800,[],1);


  
%Cross Correlate Left and Right Channels

for i=1:1:z+1
    temp1=squeeze(shiftedRecording1(:,i));
    temp2=squeeze(shiftedRecording2(:,i));
    LRxcorr(:,i) = xcorr(temp2,temp1,'normalized');

end

%Extract left and right section of middle
postLRxcorr=LRxcorr(3600:5999,:);

%Extract PSD of Left Right Cross correlated data
for i=1:1:z+1
    
    [SLR,FLR,TLR,PLR(:,:,i)]=spectrogram(postLRxcorr(:,i),4.8,0,96,96e3,'yaxis');
    
end

xLR=zeros(numfreq,factor,z+1);

for d = 17:1:21
    
    xLR(d-16,:,:)=PLR(d,:,:);
    
    
end

for a=1:1:z+1
    
    for b= 1:1:numfreq
        
        for e=1:1:factor
            
            
            BLR(a,e,b)=xLR(b,e,a);
            
            
        end
        
        
    end
    
    
    
end


% Normalize and Log the Cross correlated data

for i=1:1:numfreq

    logCLR(:,:,i)=log((BLR(:,:,i)./100)./(max(max(BLR(:,:,i)./100))));
 
end
    

%Ensuring final array is ready to be funnelled into the network for
%classification

for a=1:1:z
      
    for b= 1:1:numfreq
        for e=1:1:factor 
            
            
                out(b,e)=logCLR(a,e,b);
                           
            end
             
            
        end
        final{a,1}= out; 
end
      
    


%Save the processed left and right cross correlated data into the training
%and testing folder, for easy access to the same file when concatenating
%them together

  save(['C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Training\LRcorrdata\Xdata\' filename2], 'final');
  save(['C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Test\LRCorr\Xdata\' filename2], 'final');
 
%  close all




    