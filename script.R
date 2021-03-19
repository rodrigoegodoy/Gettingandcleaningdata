## Load packages
library(dplyr)
library(data.table)

## Download and unzip the file
zip <- "activity.zip"

if (!file.exists(zip)){
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileurl, zip, method = "curl")
}        

if(!file.exists("UCI HAR Dataset")) {
  unzip(zip)
}    


## 1. Merging the training and the test sets to create one data set

trainx <- fread("UCI HAR Dataset/train/X_train.txt", header = FALSE)

variablenames <- fread("UCI HAR Dataset/features.txt", header = FALSE)
    variables <- variablenames$V2
        colnames(trainx) <- variables

trainy <- fread("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "labels")

trainsub <- fread("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")
  
bindtrain <- cbind(trainsub, trainy, trainx)


testx <- fread("UCI HAR Dataset/test/X_test.txt", header = FALSE)
    colnames(testx) <- variables

testy <- fread("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "labels")

testsub <- fread("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")

bindtest <- cbind(testsub, testy, testx)


mergedata <- rbind(bindtrain, bindtest)


## 2. Extracting only the measurements on the mean and standard deviation for each measurement


meanstd <- select(mergedata, subject, labels, contains("mean"), contains("std"))


## 3. Using descriptive activity names to name the activities in the data set

activities <- fread("UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("labels", "activity"))
 
Dataactivity <- merge(meanstd, activities, by = "labels") %>%
    relocate(activity, .after = subject) %>%
        select(-labels)

## 4. Labeling the data set with descriptive variable names. 

colnames(Dataactivity) <- gsub("^t", "time", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Body", "body", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Gravity", "gravity", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Acc", "accelerometer", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Mag", "magnitude", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Gyro", "gyroscope", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("^f", "frequency", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Freq", "frequency", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Jerk", "jerk", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("[()]", "", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("-mean", "mean", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("Mean", "mean", colnames(Dataactivity))
colnames(Dataactivity) <- gsub("-std", "std", colnames(Dataactivity))
colnames(Dataactivity) <- gsub(",", "-", colnames(Dataactivity))

## 5. Creating an independent tidy data set with the average of each variable for each activity and each subject

tidydataaverage <- Dataactivity %>%
    group_by(subject, activity) %>%
        summarize_all(~mean(.x, nar.rm = TRUE))

write.table(tidydataaverage, file = "tidydata.txt", row.name = FALSE)
