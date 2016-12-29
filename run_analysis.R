# Load the required library
library(dplyr)

# Load the data into R
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activity")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activity")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")


# Label the data set with descriptive variable names
colnames(x_test) <- features[,2]
colnames(x_train) <- features[,2]

# Build a complete test data & train data
test_data <- cbind(subject_test, y_test, x_test)
train_data <- cbind(subject_train, y_train, x_train)

# Combine both test & train data
all_data <- rbind(test_data, train_data)

# Extract only the measurements on mean and standard deviation
keep_features <- grep(".mean.|.std.", features[,2])
my_data <- all_data[,c(1,2,keep_features+2)]

# Convert the subject and activity into factors
my_data$activity <- factor(my_data$activity, levels = activity_labels[,1], labels = activity_labels[,2])
my_data$subject <- as.factor(my_data$subject)

# Group the subject + activity and tabulate average of each variable
my_data <- tbl_df(my_data)
tidy_data <- group_by(my_data, subject, activity, add = TRUE) %>%
                summarize_each(funs(mean))

