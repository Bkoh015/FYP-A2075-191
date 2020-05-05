%This was for the Range BiLSTM Network Training, for Azimuthal BiLSTM
%Network, ensure that the training data and answers loaded in are for it. Make sure
%the parameters are changed as well to optimise the training.


%Load concatenated training data and answers from where it is saved
load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Training\Xdata\xdatacentre.mat');
load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Training\Ydata\ydatacentre.mat');
XTrain = xdata;
YTrain = ydata;

%Set the parameters for the Network
inputSize = 10;
numHiddenUnits1 = 270;
numHiddenUnits2 =90;
numHiddenUnits3 = 30;
numClasses = 3;




layers = [ ...
    sequenceInputLayer(inputSize)
    bilstmLayer(numHiddenUnits1,'OutputMode','sequence')
      bilstmLayer(numHiddenUnits2,'OutputMode','sequence')
       bilstmLayer(numHiddenUnits3,'OutputMode','last')
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

maxEpochs = 90;
 miniBatchSize = 298;

options = trainingOptions('adam', ...
    'ExecutionEnvironment','gpu', ...
    'GradientThreshold',1, ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize, ...
    'SequenceLength','longest', ...
    'Shuffle','once', ...
    'Verbose',0, ...
    'Plots','training-progress');

%Ensure to save the workspace once the netowrk is trained, to allow access to it after u close it. 
%net is the network which u load into classify function
net = trainNetwork(XTrain,YTrain,layers,options);


