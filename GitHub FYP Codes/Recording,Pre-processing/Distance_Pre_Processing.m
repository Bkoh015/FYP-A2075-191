%Record 10 seconds of data
Fs = 96000;
recObj = audiorecorder(Fs, 16, 2);

disp('Start speaking.') 
recordblocking(recObj, 10);
disp('End of Recording.');



% Store raw recorded data
myRecording = getaudiodata(recObj);

%filename = '032020powersupply17kHz9msburstcycle200set8.mat';
filename = '03282020chirpsignal25kHz200set4.mat';

%filename =  '03202017kHz9msburstcycle20030cmleftset4.mat';
%filename = '03282020chirpsignal25kHz10045cmleftset4.mat';

% filename = '03202017kHz9msburstcycle20050cmrightset4.mat';
%filename = '03282020chirpsignal25kHz10045cmrightset4.mat';



save(filename, 'myRecording','Fs');

%this is for storing processed data and will be used at the last few lines
%of the code
filename2 = '200set4.mat';




%Load Theoretical Emitted Signal 
load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\bandpassoriginalFMchirp.mat');


%Variables used to process the loops and plot graphs
t=0:1:99;
factor=100;
z=199;                                                          %Number of sets of individual period
numfreq=5;                                                      %Number of freq used

bpf = designfilt('bandpassiir','FilterOrder',10, ...
    'HalfPowerFrequency1',15e3,'HalfPowerFrequency2',21e3, ...
    'DesignMethod','butter','SampleRate',96e3);

%BPF the recorded data, 
filteredRecording = filtfilt(bpf,myRecording);


%Time Shift to apporximate start of recording location for Left channel and reshape them into individual periods
[M,I]=max(filteredRecording(1:4800,1));

startpulse1=I-1500;

circRecording1=circshift(filteredRecording(:,1),-startpulse1);

shiftedRecording1= reshape(circRecording1(:,1),4800,[],1);

%BPF Theoretical Emitted signal and reshape into individual periods
filterednormal=filtfilt(bpf,bandpasssignal);
setssignal= reshape(filterednormal,4800,[],1);

for i=1:1:z+1
    
    setssignal(4700:4800,i)=0;
       
end


%Time Shift Theoretical emitted signal to apporximate start of signal location
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

%Cross correlate Theoretical signal with left channel of recording

for i=1:1:z+1
    temp1=squeeze(shiftedsignal(:,i));
    temp2=squeeze(shiftedRecording1(:,i));
    matched1(:,i) = xcorr(temp2,temp1,'normalized');
   
    
end


%Time Shift cross correlaated signal to emitted pulse's falling edge.

for i = 1:1:z+1
    
    
    [M,I]=max(matched1(:,i));
    
    startpoint1(:,i)=I-1;
       
    circmatch1(:,i)=circshift(matched1(:,i),-startpoint1(:,i));
    
    postmatch1(:,i)=circmatch1(1:2400,i);
       

end

%Extract PSD of Left Channel Cross correlated signal

for i=1:1:z+1
    
    [S1,F1,T1,P1(:,:,i)]=spectrogram(postmatch1(:,i),24,0,96,96e3,'yaxis');
    
end

x1=zeros(numfreq,factor,z+1);

for d = 17:1:21
    
    x1(d-16,:,:)=P1(d,:,:);
        
end

for a=1:1:z+1
    
    for b= 1:1:numfreq
        
        for e=1:1:factor
            
            
            B(a,e,b)=x1(b,e,a);
            
            
        end
        
        
    end
    
    
    
end

%Normalize and Log the PSD of the Left Channel

for i=1:1:numfreq

    logC(:,:,i)=log((B(:,:,i)./100)./(max(max(B(:,:,i)./100))));
       
end
    

%Time Shift the right channel to approximate start of recording location and reshape into individual periods
[M,I]=max(filteredRecording(1:4800,2));

startpulse2=I-1500;

circRecording2=circshift(filteredRecording(:,2),-startpulse2);

shiftedRecording2= reshape(circRecording2(:,1),4800,[],1);

%Cross correlate theoretical emitted signal with Right channel of recording

for i=1:1:z+1
    temp1=squeeze(shiftedsignal(:,i));
    temp2=squeeze(shiftedRecording2(:,i));
    matched2(:,i) = xcorr(temp2,temp1,'normalized');
   
    
end

%Time Shift cross correlated data to emitted pulse falling edge location

for i = 1:1:z+1
            
   [M,I]=max(matched2(:,i));
    
   startpoint2(:,i)=I-1;
       
   circmatch2(:,i)=circshift(matched2(:,i),-startpoint2(:,i));
    
   postmatch2(:,i)=circmatch2(1:2400,i);
          
end

%Extract PSD of right channel of cross correlated data
for i=1:1:z+1
    
    [S2,F2,T2,P2(:,:,i)]=spectrogram(postmatch2(:,i),24,0,96,96e3,'yaxis');
    
end

x2=zeros(numfreq,factor,z+1);

for d = 17:1:21
    
    x2(d-16,:,:)=P2(d,:,:);
    
    
end

for a=1:1:z+1
    
    for b= 1:1:numfreq
        
        for e=1:1:factor
            
            
            BB(a,e,b)=x2(b,e,a);
            
            
        end
        
        
    end
    
    
    
end


for i=1:1:numfreq

    logCC(:,:,i)=log((BB(:,:,i)./100)./(max(max(BB(:,:,i)./100))));
    
end
    
%Combine left and right channel of cross correlated data
for a=1:1:199
      n=1;
    for b= 1:1:numfreq
        for c=1:1:2
            for e=1:1:factor 
            
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


save(['C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Training\Xdata\' filename2], 'final');


%  close all




    