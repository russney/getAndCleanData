## cleaning data project
#
# load dplyr
install.packages("dplyr")
library(dplyr)

# set working directory and download data
# setwd("/Users/rney/JHR/class3/project")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "projdata.zip", method="curl")
# data was unzipped on the command line, otherwise would need an R unzip here

# load feature names for column names
Features <- read.table("./UCI HAR Dataset/features.txt", sep=" ")
F <- as.character(Features[,2])

# load test and training data
DTest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=F)
DTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=F)

# add activity columns
YTest <- read.table("./UCI HAR Dataset/test/y_test.txt")
YTrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
YDTest <- cbind(YTest,DTest)
YDTrain <- cbind(YTrain,DTrain)

# add subject columns
STest <- read.table("./UCI HAR Dataset/test/subject_test.txt")
STrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")
SYDTest <- cbind(STest,YDTest)
SYDTrain <- cbind(STrain,YDTrain)

# merge test and train data sets
SYDTotal <- rbind(SYDTest, SYDTrain)

# name columns correctly
colnames(SYDTotal)[1] <- "SubjectCode"
colnames(SYDTotal)[2] <- "ACode"

# read in descriptions
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
colnames(activities)[1] <- "ACode"
colnames(activities)[2] <- "Activity"
# assign descriptions
mt2 <- merge(activities,SYDTotal,by.x="ACode",by.y="ACode")

# select just rows that contain "mean" and "std"
merged_table <- mt2[ , grepl("Subject|Activity|mean|std", names(mt2))]

# create last data set with mean of each variable for each subject:activity pair
tidyd <- group_by(merged_table, SubjectCode, Activity)
outTable <- summarize_each(tidyd, funs(mean))

# clean up data column names
CodeNames <- names(outTable)
NewCodes <- gsub("\\.", "", CodeNames)
colnames(outTable) <- NewCodes

# write output
write.table(outTable, file="./tidy_data.txt", row.names=FALSE)
