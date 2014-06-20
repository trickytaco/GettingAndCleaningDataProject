# Read in the test rows, subject data, and trial data
testRows <- read.table("./UCI HAR Dataset/test/X_test.txt", comment.char = "", colClasses="numeric")
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt", comment.char = "", colClasses="numeric")
testLabels <- read.table("./UCI HAR Dataset/test/Y_test.txt", comment.char = "", colClasses="numeric")

# Assign the column names to the test rows

# Read in the column names
colInfo <- read.table("./UCI HAR Dataset/features.txt", comment.char = "", colClasses="character")

# Get the column names as a vector
colNames <- colInfo[['V2']]

# Save some memory
rm(colInfo)

# Assign the column names to the test rows
names(testRows) <- colNames

# Assign a column name to the subject IDs
names(testSubjects) <- c("Subject")

# Assign a column name to the labels
names(testLabels) <- c("TrainingType")

# Combine the three datasets into a single data frame
testData <- cbind(testSubjects,testLabels,testRows)

# Save some memory
rm(testSubjects,testLabels,testRows)

# Read in the training rows, subject data, and trial data
trainRows <- read.table("./UCI HAR Dataset/train/X_train.txt", comment.char = "", colClasses="numeric")
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt", comment.char = "", colClasses="numeric")
trainLabels <- read.table("./UCI HAR Dataset/train/Y_train.txt", comment.char = "", colClasses="numeric")

# Assign the column names to the training rows
names(trainRows) <- colNames

# Save some memory
rm(colNames)

# Assign a column name to the subject IDs
names(trainSubjects) <- c("Subject")

# Assign a column name to the labels
names(trainLabels) <- c("TrainingType")

# Combine the three datasets into a single data frame
trainData <- cbind(trainSubjects,trainLabels,trainRows)

# Save some memory
rm(trainSubjects,trainLabels,trainRows)

# Combine the test and training data frames into a single data frame
allData <- rbind(testData,trainData)

# Save some memory
rm(testData,trainData)

# Read in the activity names
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", comment.char = "")

# Change the activity codes to activity names
allData[,2][allData[,2]==1] <- as.character(activities[1,2])
allData[,2][allData[,2]==2] <- as.character(activities[2,2])
allData[,2][allData[,2]==3] <- as.character(activities[3,2])
allData[,2][allData[,2]==4] <- as.character(activities[4,2])
allData[,2][allData[,2]==5] <- as.character(activities[5,2])
allData[,2][allData[,2]==6] <- as.character(activities[6,2])

# Save some memory
rm(activities)

# Find the columns that contain the mean and std of the measurements
meanColNums <- grep(pattern = "mean\\(", x = names(allData), perl = TRUE)
stdColNums  <- grep(pattern = "std\\(", x = names(allData), perl = TRUE)

# Extract the columns with subject number, training type, and mean or std columns
meanStdCols <- allData[c(1,2,meanColNums,stdColNums)]

# Save some memory
rm(meanColNums,stdColNums,allData)

# Remove the parentheses from the names so that they don't interfere with future function calls
names(meanStdCols) <- gsub("\\(\\)","",names(meanStdCols))

# Aggregate the data, calculating the mean of each data column by each
# combination of subject and training type
aggMeans <- aggregate(meanStdCols[,3:68], by=list(meanStdCols$Subject,meanStdCols$TrainingType), FUN=mean)

# Save some memory
rm(meanStdCols)

# Change the Group.1 and Group.2 column names to more meaningful names
names(aggMeans)[1:2] <- c("Subject","TrainingType")

# Write the output tidy data set
write.table(aggMeans, "variable_averages.txt")