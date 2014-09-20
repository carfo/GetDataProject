GetDataProject
==============

Getting and Cleaning Data Course Project (Coursera)

run_analysis.R
First, the script load training and test set of measurements, features and activity labels; 
then proceed to assign appropriate names to the training and test set variables using the features labels, for completness it adds three variables "Subject", "Activity" and "DataSet"; DataSet contains the label defining the data set of origin;
subsequently the train and test set are merged;
tidy_data contains the merged dataset subsetted, extracted using regular expression on the variables name;
the tidy_data dataset is then appropriatedly labeled and from this data.frame a second data set is extracted tidy_avg, calculating the mean of each variables by Activity and Subject;
tidy_avg is then exported in a .csv file
