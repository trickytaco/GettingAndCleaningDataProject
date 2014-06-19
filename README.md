GettingAndCleaningDataProject
=============================

Repository for Coursera Getting and Cleaning Data Course Project

The run_analysis.R script works with data available from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.  The unzipped folder containing the data should be placed into the R working directory.

Script walkthrough:

The script reads in the data rows, subject rows, and activity rows from the test data into separate data frames.  It reads in the column (variable) names from the features.txt file into an additional data frame.  The column names are then assigned to the appropriate columns in the data rows data frame.  The subject and activity rows are then assigned column names of "Subject" and "TrainingType", respectively.  The subject, activity, and data columns are then combined with the cbind command into a single data frame.

The script then performs the same operation with the training data.

The rbind command is then used to combine the test and training rows into a single large data frame (allData).

The activity names are read into their own data frame, and then the activity codes within the allData data frame are converted into their appropriate activity names.

The grep command is then used to pick out all of the columns that have "mean(" or "std(" in the column names, and a smaller data frame (meanStdCols) is created containing only the Subject column, the TrainingType column, and the columns with "mean(" and "std(" in the name.

The script then removes all parentheses from the column names because the parentheses can break subsequent functions.

The aggregate command then creates a final data frame (aggMeans) that aggregates the data rows by the Subject and TrainingType columns using the mean function.  As there are 30 subjects and 6 training types, the final data frame has 180 rows.

Finally, the script uses the write.table command to output the aggMeans data frame to a text file as a tidy data set.