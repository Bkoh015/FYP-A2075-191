%This was for the Range BiLSTM Network testing, for Azimuthal BiLSTM load the trained Azimuthal BiLSTM Network instead
%Testing for both range and azimuthal is similar, except load the relevant Test data set and answers instead

%Load the concatenated training sets and answers based on their file path

load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Test\Xdata\xdata3class1is4.mat');
load('C:\Users\berna\OneDrive\Documents\MATLAB\FYP\Training\032820 Chirp Virtus\Test\Ydata\ydata.mat');

%Equate the variables to local variables

XTest = xdata;
YTest = ydata;

%Classify function to predict the class with the network loaded in
[YPred,error] = classify(net,XTest);


%Calculate accuracies for each individual class
%199 is the number of sets of data
for i=1:1:5
   
    acc(i) = sum(YPred((i-1)*199+1:(199*i)) == YTest((i-1)*199+1:(199*i)))./numel(YTest((i-1)*199+1:(199*i)));
    

end

%Calculate accuracies for the whole network
acc1 = sum(YPred == YTest)./numel(YTest);