# Getting and Cleaning Data Course Project  

The repository [Getting and cleaning data](https://github.com/rodrigoegodoy/Gettingandcleaningdata) contains four files made to describe and show the process  and results to get tidy data from [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) using the files available at this [link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).  

This repository was created by Rodrigo Espíndola Godoy as part of the "Getting and Cleaning Data" course to obtain the final project peer-reviewed grade.

# Repository Content

1. [**run_analysis.R**](https://github.com/rodrigoegodoy/Gettingandcleaningdata/blob/master/run_analysis.R) - This script execute the preparation and modification 
process to make an "Human Activity Recognition Using Smartphones Data Set" tidy data. Five mains steps were used to accomplish the final result:  
    i) Merges the training and the test sets to create one data set.  
    ii) Extracts only the measurements on the mean and standard deviation for each measurement.  
    iii) Uses descriptive activity names to name the activities in the data set.  
    iv) Appropriately labels the data set with descriptive variable names.  
    v) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

2. [**CodeBook.md**](https://github.com/rodrigoegodoy/Gettingandcleaningdata/blob/master/CodeBook.md) -  a code book that describes the variables, the data, and any transformations or work that were performed to clean up the data.  
3. [**README.md**](https://github.com/rodrigoegodoy/Gettingandcleaningdata/blob/master/README.md) - explains the analysis files present in this repository.  
4. [**tidydata.txt**](https://github.com/rodrigoegodoy/Gettingandcleaningdata/blob/master/tidydata.txt) - the final result of the process performed in```run_analysis.R```.
