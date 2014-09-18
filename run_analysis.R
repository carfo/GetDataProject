library(data.table)
# Load data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")
features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")
# Naming
names(activity_labels)<-c("Code","Label")
# Step 4, using feature's names as variable's names, as explained
#in features_info.txt
names(X_test)<-features$V2
names(X_train)<-features$V2
X_test<-cbind(X_test,y_test)
names(X_test)[562]<-"Activity"
X_train<-cbind(X_train,y_train)
names(X_train)[562]<-"Activity"
X_test<-cbind(X_test,subject_test)
names(X_test)[563]<-"Subject"
X_train<-cbind(X_train,subject_train)
names(X_train)[563]<-"Subject"
X_test<-cbind(X_test,"test")
names(X_test)[564]<-"DataSet"
X_train<-cbind(X_train,"train")
names(X_train)[564]<-"DataSet"
# Step 1, merging training and testing set
X<-rbind(X_train,X_test)
# Step 2, extracting only means and stds 
#for time and frequency signals, including meanFreq()
tidy_data<-X[,grep(pattern="mean()|std()|Activity|Subject|DataSet",
                   names(X))]
# Step 3, using descriptive activity names to name the 
#activities in the data set
tidy_data<-data.table(tidy_data)
activity_labels<-data.table(activity_labels)
setkey(activity_labels,Code)
setkey(tidy_data,Activity)
tidy_data<-activity_labels[tidy_data]
tidy_data[,':='(Activity.code=Code,Activity.label=Label)]
tidy_data[,':='(Code=NULL,Label=NULL)]
# Step 5, second, independent tidy data set with the average 
#of each variable for each activity and each subject
tidy_avg<-tidy_data[,lapply(.SD,mean),
                    by=list(Activity.label,Subject),
                    .SDcols=grep("[^DataSet&Subject&Activity.label]"
                                 ,names(tidy_data))]
# Exporting tidy data from step 5
write.table(tidy_avg,file="./tidy_avg.txt",row.names=FALSE)
