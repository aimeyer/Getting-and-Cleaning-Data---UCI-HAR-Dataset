## Download and unzip file
UCIHAR_DATA <- if( !dir.exists("UCI HAR Dataset") ) {
  if( !file.exists("UCI HAR Dataset.zip") ) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "UCI HAR Dataset.zip")
  }
  unzip("UCI HAR Dataset.zip") # automatically creates the "UCI HAR Dataset
  
  dateDownloaded<- date() ## get download date
  dateDownloaded
  UCIHAR_DATA

  }
setwd("UCI HAR Dataset")
 
library(dplyr)

  ## Read in X training and test files 
X_train <- read.table("train/X_train.txt")
X_test <- read.table("test/X_test.txt")

  ## merge X data
X <- rbind(X_train, X_test)

  ## read in y  training and test sets

y_train <- read.table("train/y_train.txt")
y_test <- read.table("test/y_test.txt")

  ## merge y data

Y<- rbind(y_train, y_test)


  ## read in Subject data
subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

  ## merge Subject data
Subject <- rbind(subject_train, subject_test)

  ## read in Features data
Features <- read.table("features.txt")

  ## name the variables
names(Subject)<-c("subject")
names(Y)<- c("activity")
names(X)<- Features[ ,2]

   ## find the indices that contain, -mean() and -std()in Features variable
indices <- grep("-mean\\(\\)|-std\\(\\)", Features[, 2])
extracted <- X[, indices]

  ## give names to extracted 
names(extracted) <- Features[indices, 2]

  ## remove "()" from names
names(extracted) <- gsub("\\(|\\)", "", names(extracted))

  ## convert all to lower case 
names(extracted) <- tolower(names(extracted))

dim(extracted)

  ##read in activity labels
activities <- read.table("activity_labels.txt")
  ## see what it looks like
activities

  ## remove the "_" and change to lower case
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
Y[,1] = activities[Y[,1], 2]
names(Y) <- "activity"

  ## take a look at it
Y [1:10,1]

## label data with activity names
names(Subject) <- "subject"

  ## create a new data frame
clean <- cbind(Subject,Y,extracted)

write.table(clean, "merged_and_cleaned_data.txt")

dim(clean)

  ## create tidy dataset with the average of each variable for each activity and subject
tidy<-aggregate(. ~subject + activity, clean, mean)
tidy<-tidy[order(tidy$subject,tidy$activity),]
write.table(tidy, file = "merged_and_cleaned_data2.txt",row.name=FALSE)
dim(tidy)

















  



     


