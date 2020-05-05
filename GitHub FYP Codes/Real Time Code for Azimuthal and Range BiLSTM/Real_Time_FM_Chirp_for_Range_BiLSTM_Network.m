%Load (saved Range BiLSTM Network that is trained here)

% while(1==1)

% Record for 10 seconds of data.
Fs = 96000;
recObj = audiorecorder(Fs, 16, 2);
disp('Start speaking.') 
recordblocking(recObj, 10);
disp('End of Recording.');

% Store data in double-precision array.
myRecording = getaudiodata(recObj);
filename = 'realtime.mat';
save(filename, 'myRecording','Fs');

% Load in the theoretical emitted FM Chirp 
load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\bandpassoriginalFMchirp.mat');


Dfactor=100;
%number of data sets
z=199;
%Number of frequencies used
numfreq=5;


%Bandpass filter the Recorded signal
bpf = designfilt('bandpassiir','FilterOrder',10, ...
    'HalfPowerFrequency1',15e3,'HalfPowerFrequency2',21e3, ...
    'DesignMethod','butter','SampleRate',96e3);

filteredRecording = filtfilt(bpf,myRecording);

%Time Shift the left channel to approximate starting location of the recording and reshape them into individual periods

[M,I]=max(filteredRecording(1:4800,1));

startpulse1=I-1500;

circRecording1=circshift(filteredRecording(:,1),-startpulse1);

shiftedRecording1= reshape(circRecording1(:,1),4800,[],1);



%BPF Theoretical signal and reshape them into individual period
filterednormal=filtfilt(bpf,bandpasssignal);
setssignal= reshape(filterednormal,4800,[],1);

for i=1:1:z+1
    
    setssignal(4700:4800,i)=0;
       
end


%Time Shift theoretical emitted signal onto the falling edge

lastslopesignalset=zeros(1,z+1);
for i = 1:1:200
    
     
 lastslopesignalset(1,i)= 1600;
    
    
end
locationS=zeros(1,z+1);

for k = 1:1:z+1
    
    locationS(:,k)=lastslopesignalset(:,k);
    
end

shiftedsignal = zeros(4800,z+1);

for n = 1:1:z+1
   
    shiftedsignal(:,n) = circshift(setssignal(:,n),-(locationS(1,n)));
    
end


%Cross Correlate Left Channel and Theoretical Signal

for i=1:1:z+1
    temp1=squeeze(shiftedsignal(:,i));
    temp2=squeeze(shiftedRecording1(:,i));
    matched1(:,i) = xcorr(temp2,temp1,'normalized');
   
    
end


% Time shift cross-correlated signal for left channel to align them to the falling edge of
% the emitted pulse

for i = 1:1:z+1
        
   [M,I]=max(matched1(:,i));
    
   startpoint1(:,i)=I-1;
        
   circmatch1(:,i)=circshift(matched1(:,i),-startpoint1(:,i));
    
   postmatch1(:,i)=circmatch1(1:2400,i);
      
end

%Extract PSD of cross correlated data

for i=1:1:z+1
    
    [S1,F1,T1,P1(:,:,i)]=spectrogram(postmatch1(:,i),24,0,96,96e3,'yaxis');
    
end

x1=zeros(numfreq,Dfactor,z+1);

for d = 17:1:21
    
    x1(d-16,:,:)=P1(d,:,:);
    
  end

for a=1:1:z+1
    
    for b= 1:1:numfreq
        
        for e=1:1:Dfactor 
            
            B(a,e,b)=x1(b,e,a);
            
            
        end
        
    end
    
  
end

%Normalize and log the PSD

for i=1:1:numfreq
   
    
    logC(:,:,i)=log((B(:,:,i)./100)./(max(max(B(:,:,i)./100))));
    
     
end
    

  
%Time Shift to approximate starting location of right channel and Reshape right channel data
[M,I]=max(filteredRecording(1:4800,2));
startpulse2=I-1500;
circRecording2=circshift(filteredRecording(:,2),-startpulse2);
shiftedRecording2= reshape(circRecording2(:,1),4800,[],1);


%Cross Correlate Right Channel with Theoretical emitted FM Chirp

for i=1:1:z+1
    temp1=squeeze(shiftedsignal(:,i));
    temp2=squeeze(shiftedRecording2(:,i));
    matched2(:,i) = xcorr(temp2,temp1,'normalized');
   
    
end


% Time shift cross-correlated signal for right channel to align them to the falling edge of
% the emitted pulse


for i = 1:1:z+1
        
    [M,I]=max(matched2(:,i));
    
    startpoint2(:,i)=I-1;
    
        
    circmatch2(:,i)=circshift(matched2(:,i),-startpoint2(:,i));
    
    postmatch2(:,i)=circmatch2(1:2400,i);
       
          

end

%Extracting PSD of right channel

for i=1:1:z+1
    
    [S2,F2,T2,P2(:,:,i)]=spectrogram(postmatch2(:,i),24,0,96,96e3,'yaxis');
    
end

x2=zeros(numfreq,Dfactor,z+1);

for d = 17:1:21
    
    x2(d-16,:,:)=P2(d,:,:);
    
    
end

for a=1:1:z+1
    
    for b= 1:1:numfreq
        
        for e=1:1:Dfactor
            
            
            BB(a,e,b)=x2(b,e,a);
            
            
        end
        
        
    end
    
    
    
end


%taking Log and Normalizing of the data for Right Channel

for i=1:1:numfreq
   
    logCC(:,:,i)=log((BB(:,:,i)./100)./(max(max(BB(:,:,i)./100))));
    
   
end
    


    
%Combining both Left and Right Channel together


for a=1:1:199
      n=1;
    for b= 1:1:numfreq
        for c=1:1:2
            for e=1:1:Dfactor 
            
            if c==1
                out(n,e)=logC(a,e,b);
                
            else
                
                out(n,e)=logCC(a,e,b);
            end
            
            end
    
            n=n+1;
        end
        
    end
    final{a,1}= out;   
    
end
 
%Loading the pre-processed data into a varaiable to use for classifying
%netD is the Range BiLSTM Network
XTestD = final;
[YPred,error] = classify(netD,XTestD);




% Heat Map Code
heat = hist(YPred);
heat=heat';
xvalues = {'0'};                                %Azimuth
yvalues = {'250','225','200','175','150'};      %Ranges
h = heatmap(xvalues,yvalues,heat);

h.Title = 'Location';
h.XLabel = 'Position';
h.YLabel = 'Distance';



 