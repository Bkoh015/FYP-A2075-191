% Ensure all the pre-processed data is stored in this folder and name them
% in the way for easy loading and changing of the loading names
% This was for Range BiLSTM 5 classes, and 3 sets of each class.
% make sure to do for the testing network which only consist of 1 set for each class
% Do the same for Azimuthal BiLSTM just with 3 classes and 3 sets of each class


a1=load('250set1.mat');
f1=fieldnames(a1);
a2=load('250set2.mat');
f2=fieldnames(a2);
a3=load('250set3.mat');
f3=fieldnames(a3);


a4=load('225set1.mat');
f4=fieldnames(a4);
a5=load('225set2.mat');
f5=fieldnames(a5);
a6=load('225set3.mat');
f6=fieldnames(a6);

a7=load('200set1.mat');
f7=fieldnames(a7);
a8=load('200set2.mat');
f8=fieldnames(a8);
a9=load('200set3.mat');
f9=fieldnames(a9);

a10=load('175set1.mat');
f10=fieldnames(a10);
a11=load('175set2.mat');
f11=fieldnames(a11);
a12=load('175set3.mat');
f12=fieldnames(a12);

a13=load('150set1.mat');
f13=fieldnames(a13);
a14=load('150set2.mat');
f14=fieldnames(a14);
a15=load('150set3.mat');
f15=fieldnames(a15);

%Concatenate them all and save
xdata5class=[a1.(f1{1});a2.(f2{1});a3.(f3{1});a4.(f4{1});a5.(f5{1});a6.(f6{1});a7.(f7{1});a8.(f8{1});a9.(f9{1});a10.(f10{1});a11.(f11{1});a12.(f12{1});a13.(f13{1});a14.(f14{1});a15.(f15{1})];
save xdata5class xdata5class;





