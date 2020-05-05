% This was for Range BiSLTM classes answers.
% Just do the same for Azimuthal BiLSTM Classes and for testing them

yclass = 1:5;                                    %Number of classes depending if using for Range BiLSTM/ Azimuthal BiLSTM

yclass = repmat(yclass, 2985, 1);                 %create the answers from 1 to 5, the number change at every n interval, in this case is 2985

% Reshape to obtain a vector
yclass = reshape(yclass, 1, numel(yclass));
yclass=yclass';
 
 
y = [yclass];
ydata=categorical(y);                        %Categorical array is needed for the BilSTM NEtwork answers
 
save ydataclass ydata;