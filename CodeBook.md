### Collecting and cleaning "Activity" data
### date: 19 March 2021

Use this script to prepare the "Getting and Cleaning Data" course final project data

**Load packages**  
```library(dplyr)```  
```library(data.table)```

### Download and unzip the file creating the "UCI HAR Dataset" folder

```zip <- "activity.zip"```

**Confirm if the downloaded file already exists, if not, download the file**  
```if (!file.exists(zip)){```       
```fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"```        
```download.file(fileurl, zip, method = "curl")```          
```}```        

**Confirm if the folder with the extracted files already exists , if not, unzip the file**  
```if(!file.exists("UCI HAR Dataset")) {```  
```unzip(zip)```  
```}```    

## 1. Merging the training and the test sets to create one data set

To read the data use "header = FALSE" as the variable names will be inserted after     

**Read "train" group data set**  
```trainx <- fread("UCI HAR Dataset/train/X_train.txt", header = FALSE)```

**Read all variable names and exclude the first columnn, then use it to name the variables in the data set**     
```variablenames <- fread("UCI HAR Dataset/features.txt", header = FALSE)```   
        ```variables <- variablenames$V2```  
              ```colnames(trainx) <- variables```

**Read "train" group data labels and identify the column name as "labels"**  
```trainy <- fread("UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = "labels")```

**Read "train" group subject data to identify the data set rows and identify the column name as "subject"**  
```trainsub <- fread("UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = "subject")```

**Bind all three columns**   
```bindtrain <- cbind(trainsub, trainy, trainx)```


**Read "test" group data set**  
```testx <- fread("UCI HAR Dataset/test/X_test.txt", header = FALSE)```    
    ```colnames(testx) <- variables```

**Read "test" group data labels and identify the column name as "labels"**  
```testy <- fread("UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = "labels")```

**Read "test" group subject data to identify the data set rows and identify the column name as "subject"**  
```testsub <- fread("UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = "subject")```

**Bind all three columns**   
```bindtest <- cbind(testsub, testy, testx)```


**Merge "train" and "test" bound datasets rows**

```mergedata <- rbind(bindtrain, bindtest)```


## 2. Extracting only the measurements on the mean and standard deviation for each measurement

**Use the select function to retain the "subject" and "labels" variables and the contains function to select only the variables with mean and standard deviation in their names**  
```meanstd <- select(mergedata, subject, labels, contains("mean"), contains("std"))```


## 3. Using descriptive activity names to name the activities in the data set

**Read the "activity" labels, naming the first column as "labels" and the second as "activity"**   
```activities <- fread("UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("labels", "activity"))```

**Merge the train and test merged data and the "activity" labels using the variable "labels", and then reallocate the "activity" variable as the second** 
**variable and remove the "labels" variable as it was only needed to merge the two data sets, correlating the labels numbers with the activity name**      
```Dataactivity <- merge(meanstd, activities, by = "labels") %>%```    
    ```relocate(activity, .after = subject) %>%```    
```select(-labels)```    
      
## 4. Labeling the data set with descriptive variable names. 

**Remove captalized words, brakets, unnecessary symbols, and give full name to abbreviated variables**  
```colnames(Dataactivity) <- gsub("^t", "time", colnames(Dataactivity))```  **variables beginning with t changed to time**
```colnames(Dataactivity) <- gsub("Body", "body", colnames(Dataactivity))``` **lower case Body variable**  
```colnames(Dataactivity) <- gsub("Gravity", "gravity", colnames(Dataactivity))```  **lower case Gravity variable**
```colnames(Dataactivity) <- gsub("Acc", "accelerometer", colnames(Dataactivity))``` **Acc changed to accelometer**
```colnames(Dataactivity) <- gsub("Mag", "magnitude", colnames(Dataactivity))``` **Mag changed to magnitude**  
```colnames(Dataactivity) <- gsub("Gyro", "gyroscope", colnames(Dataactivity))``` **Gyro changed to gyroscope** 
```colnames(Dataactivity) <- gsub("^f", "frequency", colnames(Dataactivity))``` **variables beginning with f changed to frequency** 
```colnames(Dataactivity) <- gsub("Freq", "frequency", colnames(Dataactivity))``` **Freq changed to frequency** 
```colnames(Dataactivity) <- gsub("Jerk", "jerk", colnames(Dataactivity))``` **Jerk changed to jerk**
```colnames(Dataactivity) <- gsub("[()]", "", colnames(Dataactivity))``` **"()" removed from variables names**  
```colnames(Dataactivity) <- gsub("-mean", "mean", colnames(Dataactivity))``` **"-" removed from mean** 
```colnames(Dataactivity) <- gsub("Mean", "mean", colnames(Dataactivity))``` **Mean changed to mean** 
```colnames(Dataactivity) <- gsub("-std", "std", colnames(Dataactivity))``` **"-" removed from std**  
```colnames(Dataactivity) <- gsub(",", "-", colnames(Dataactivity))``` **"," changed to "-"** 

## 5. Creating an independent tidy data set with the average of each variable for each activity and each subject  

**Group the tidy data set by "subject" and "activity" variables and use the summarize_all and mean functions to get the average of each variable**  
```tidydataaverage <- Dataactivity %>%```   
    ```group_by(subject, activity) %>%```  
        ```summarize_all(~mean(.x, nar.rm = TRUE))```  

**Save the tidy data as a .txt file**  
```write.table(tidydataaverage, file = "tidydata.txt", row.name = FALSE)```  

