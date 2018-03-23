

## 1.

# Reading train Data 

train_x <- read.table("train/X_train.txt", header = FALSE)
train_y <- read.table("train/y_train.txt", header = FALSE)
feature <- read.table("features.txt", header = FALSE)
subjecttrain <- read.table("train/subject_train.txt", header = FALSE)
activity <- read.table("activity_labels.txt")

# Assigning coloumn names 

colnames(activity) <- c("actID", "activity")
colnames(subjecttrain) <-c("subjectId")
colnames(train_x) <- feature[,2]
colnames(train_y) <- ("actID")

## Merging Train Data 

Datatrain <- cbind(train_x, subjecttrain, train_y)

## Reading test Data 

test_x <- read.table("test/x_test.txt", header = FALSE)
test_y <- read.table("test/y_test.txt", header = FALSE)
subjecttest <- read.table("test/subject_test.txt", header = FALSE)

## Assiging Column names

colnames(subjecttest) <- ("subjectId")
colnames(test_x) <- feature[,2]
colnames(test_y) <- ("actID")

## Merging Test Data 

Datatest <- cbind(test_x, subjecttest, test_y)

## Final Merging (Test + Train)

FinalData <- rbind(Datatrain, Datatest)

## Creating vector for colnames

colNames <- colnames(FinalData)

# 2.

## Extract the measurements on the mean and standard deviation for each measurement

Mean_STDdata <- FinalData[,grep("mean|std|subject|actID", colnames(FinalData))]

# 3

# Naming the activities in the Data 

install.packages("plyr")
library(plyr)

Mean_STDdata <- join(Mean_STDdata, activity, by = "actID", match = "first")
Mean_STDdata <- Mean_STDdata[,-1]

# 4
# Removing parentheses

names(Mean_STDdata) <- gsub("\\(|\\)", "", names(Mean_STDdata), perl = TRUE)

## correcting syntax in names

names(Mean_STDdata) <- make.names(names(Mean_STDdata))

# Adding Desccriptive names

names(Mean_STDdata) <- gsub("Acc", "Acceleration", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("^t", "Time", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("^f", "Frequaency", names(Mean_STDdata))                            
names(Mean_STDdata) <- gsub("BodyBody", "Body", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("mean", "Mean", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("std", "Std", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("Freq", "Frequaency", names(Mean_STDdata))
names(Mean_STDdata) <- gsub("Mag", "Magnitude", names(Mean_STDdata))

#5

# creating a second, independent tidy data set with the average of each variable for each activity and each subject.

tidydata_aver_sub<- ddply(Mean_STDdata, c("subjectId","activity"), numcolwise(mean))

write.table(tidydata_aver_sub,file = "tidydata.txt")
