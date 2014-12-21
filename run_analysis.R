## get and unzip data
zipname = "Dataset.zip"
if (!file.exists(zipname)) {
  url <- ('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip')
  download.file(url, destfile = zipname, method = "curl")
}
if (!file.exists('UCI HAR Dataset/README.txt')) {
  unzip(zipfile=zipname)
}

# load data
data_X_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
data_y_test <- read.table(file = "UCI HAR Dataset/test/y_test.txt")
data_subject_test <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")
data_X_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
data_y_train <- read.table(file = "UCI HAR Dataset/train/y_train.txt")
data_subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")
activity_labels <- read.table(file = "UCI HAR Dataset/activity_labels.txt")

#Merge the training and the test sets to create one data set.
data <- rbind(data_X_test,data_X_train)
labels <- rbind(data_y_test,data_y_train)
subj <- rbind(data_subject_test,data_subject_train)

# Appropriately label the data set with descriptive variable names
feat <- read.table(file = "UCI HAR Dataset/features.txt")
feat <- transform(feat,V2 = as.character(V2))
colnames(data) <- feat$V2 

#and attaching subject and activity
data$activity <- activity_labels$V2[labels$V1]
summary(data$activity)
data$subject <- as.factor(subj$V1)

#Extract only the measurements on the mean and standard deviation for each measuremen
mask_mean <- grepl('mean',feat$V2, ignore.case = T)
mask_std <- grepl('std',feat$V2, ignore.case = T)
#now masking both
mask=mask_std|mask_mean 
datmn <- data[,mask]
head(datmn)
dim(datmn)

#creating a 2nd, independent tidy data set with the average of each variable for each activity and each subject.
aggdata <-aggregate(datmn, by=list(Group.subj=datmn$subj,Group.activity=datmn$activity), FUN=mean, na.rm=TRUE)
aggdata$activity <- NULL
aggdata$subject <- NULL
dim(aggdata)
write.table(aggdata,file = 'aggdata.txt',row.name=FALSE)