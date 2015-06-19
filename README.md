# tidyData
Course Project for Getting and Cleaning Data

Course Assignment is the following steps:
You should create one R script called run_analysis.R that does the following. 
 1 Merges the training and the test sets to create one data set.
 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
 3 Uses descriptive activity names to name the activities in the data set
 4 Appropriately labels the data set with descriptive variable names. 
 5 From the data set in step 4, creates a second, independent tidy data set with 
   the average of each variable for each activity and each subject.

The following data should be downloaded and unzipped in your working directory:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

This program will go through the data to create one table of the test and training data sets
and will return a text file titled "tidyData.txt" in your working directory. 

The program finds all measures that include the term "mean" or "std" within the variable name.
The final table provided finds the mean of all measures for each variable, for each subject and each activity.
