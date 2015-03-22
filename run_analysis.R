## cleaning data project
#
setwd("/Users/rney/JHR/class3/project")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "projdata.zip", method="curl")

## this crashed R Studio
##library("data.table")
##DT <- fread("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/X_test.txt")

## this uses too much memory
##w=rep(16:16, 561)
##DT <- read.fwf("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/X_test.txt", widths=w)

Features <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/features.txt", sep=" ")
F <- as.character(Features[,2])

# this works
#DTest <- read.csv("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/X_test.csv", col.names=F)
#DTrain <- read.csv("/Users/rney/JHR/class3/project/UCI HAR Dataset/train/X_train.csv", col.names=F)

# this also works
DTest <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/X_test.txt", col.names=F)
DTrain <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/train/X_train.txt", col.names=F)

# add activity columns
YTest <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/y_test.txt")
YTrain <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/train/y_train.txt")
YDTest <- cbind(YTest,DTest)
YDTrain <- cbind(YTrain,DTrain)

# add subject columns
STest <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/test/subject_test.txt")
STrain <- read.table("/Users/rney/JHR/class3/project/UCI HAR Dataset/train/subject_train.txt")
SYDTest <- cbind(STest,YDTest)
SYDTrain <- cbind(STrain,YDTrain)

# merge test and train data sets
SYDTotal <- rbind(SYDTest, SYDTrain)

# name columns correctly
colnames(SYDTotal)[1] <- "Subject"
colnames(SYDTotal)[2] <- "Activity"


# select just rows that contain "mean" and "std"
merged_table <- SYDTotal[ , grepl("Subject|Activity|mean|std", names(SYDTotal))]
