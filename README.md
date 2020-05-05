# FYP-A2075-191
Final Year Project code for the echolocation system real time time target classification


The codes in this repository are for the echolocation system to perform real time target classification

Do note that the concatenating, training and testing folders contain the general code on how to perform it.
The proper implementation for those codes varies on the BiLSTM Network the user is using them for.

Eg. Range BiLSTM Network has a total of 5 classes and you would require 3 training sets for it, thus concatenation would require the 3 training sets for each class to be arranged sequentially before concatenation is done.
For concatenating the answers to the training data sets, you would require the class number 1 to 5 to be repeated in every intervals of 199 sets * 3 training sets = 597 
That would concatenate the training data and answers required to train the Range BiLSTM Network

For testing the Range BiLSTM Network, you would require 1 training set which wasnt used previously. concatenation would require all 5 classes training set to be arranged sequentially.
For creating the answer to the test data sets, you would require the class number 1 to 5 to be repeated in every intervals of 199 sets.
That would concatenate the testing data and answers required to test the Range BiLSTM Network.

For Training and testing network code, for the same range BiLSTM eg, Load the concatenated training data and answers data for the Range BiLSTM and edit the parameters inside the train_Network code
to account for all the values required for the Range BiLSTM Network, eg. 5 classes, 10 features etc..
The only values to change to optimize the network are the epochs, Number of hidden units and Number of BiLSTM Layer.
Remember to save ur network trained for access in the future

For test_network code, load the concatenated test data and answers data into the code. After which run the code and the network overall accuracy on classifying the testing data will be calculated.
