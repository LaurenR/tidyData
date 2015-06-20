setwd("C:/Users/Lauren/Documents/Data/tidy/UCI HAR Dataset")    #SET WORKING DIRECTORY TO INSIDE FIRST FILE
list.files()                              #LIST FILES IN DIRECTORY
setwd("C:/Users/Lauren/Documents/Data/tidy/UCI HAR Dataset/test") #SET WORKING DIRECTORY TO FIRST DATA FILES NAMED TEST

subject_test <- read.table("subject_test.txt") #READ IN EACH TABLE (SUBJECT, X_Test, Y_Test) AS IT'S OWN VARIABLE
x_test <- read.table("x_test.txt")
y_test <- read.table("y_test.txt")
testFrame <- cbind(subject_test, y_test, x_test)  #COMBINE EACH VARIABLE COLUMN WISE TO SAME DATA FRAME, NAME TESTFRAME


setwd("C:/Users/Lauren/Documents/Data/tidy/UCI HAR Dataset/train") #LOCATE TRAIN DATASET
subject_train <- read.table("subject_train.txt")
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")
trainFrame <- cbind(subject_train, y_train, x_train) #READ EACH TABLE AS OWN VARIABLE AND COMBINE COLUMN WISE FOR TRAIN DATA FRAME AS FOR TEST DATA

HARframe <- rbind(testFrame, trainFrame)   #COMBINE TRAIN AND TEST DATA SETS TO COMPLETE STEP 2 (MERGE TRAINING AND TEST SETS TO CREATE ONE DATA SET) 

colnames(HARframe)[1] <- "Subject"   #NAME FIRST COLUMN SUBJECT, PART OF STEP 4
colnames(HARframe)[2] <- "Activity" #NAME SECOND COLUMN ACTIVITY, PART OF STEP 4

setwd("C:/Users/Lauren/Documents/Data/tidy/UCI HAR Dataset")  #SET WD TO FILE THAT CONTAINS DATA LABELS - NAMED FEATURES
features <- read.table("features.txt", stringsAsFactors = FALSE) #LOCATE AND READ IN COLUMN LABELS FROM FEATURES.TXT
features <- features[,2]  #EXTRACT ONLY THE NAMES OF VARIABLES
colnames(HARframe)[3:563] <- features  #ASSIGN THESE NAMES TO COLUMN NAMES
dataLabels <- colnames(HARframe)[1:563]   


#STEP 2:Extracts only the measurements on the mean and standard deviation for each measurement
Mean <- dataLabels[grepl("mean", dataLabels)] #FIND ALL COLUMNS WITH WORD MEAN IN THEM
Std <- dataLabels[grepl("std", dataLabels)] #FIND ALL COLUMNS WITH THE VARIABLE STD IN THEM

meanFrame <- HARframe[,Mean] #SUBSET BY MEAN VARIABLES
stdFrame <- HARframe[,Std] #SUBSET BY STD VARIABLES
labelFrame <- HARframe[,1:2] #SUBSET BY SUBJECT AND ACTIVITY COLUMNS
meanSTD <- cbind(labelFrame, meanFrame, stdFrame) #CREATE DATA FRAME OF ONLY STD AND MEAN VARIABLES WITH SUBJECT AND ACTIVITY LABELS RESTORED

#STEP 3 COMPLETE: Extracts only the measurements on the mean and standard deviation for each measurement.

meanSTD$Activity <- as.character(meanSTD$Activity)
meanSTD$Activity[meanSTD$Activity == "1"] <- "Walking"
meanSTD$Activity[meanSTD$Activity == "2"] <- "WalkingUpstairs"
meanSTD$Activity[meanSTD$Activity == "3"] <- "WalkingDownstairs"
meanSTD$Activity[meanSTD$Activity == "4"] <- "Sitting"
meanSTD$Activity[meanSTD$Activity == "5"] <- "Standing"
meanSTD$Activity[meanSTD$Activity == "6"] <- "Laying"
meanSTD$Activity <- as.factor(meanSTD$Activity)
meanSTD$Subject <- as.factor(meanSTD$Subject)

#CONVERT ACTIVITY COLUMN TO CHARACTER AND ASSIGN DESCRIPTIONS, CONVERT BACK INTO FACTOR.
#CONVERT SUBJECT COLUMN TO FACTOR
#COMPLETE STEP 4:Uses descriptive activity names to name the activities in the data set

#STEP 5: From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

library(reshape2)        #LOAD RESHAPE2 PACKAGE
meanSTD$Subject_Activity = paste(meanSTD$Subject, meanSTD$Activity, sep = "_")     #CREATE NEW COLUMN THAT COMBINES ACTIVITY AND SUBJECT VARIABLES
Variables = as.character(names(meanSTD[, 3:81]))                 #CREATE CHARACTER VECTOR OF VARIABLE NAMES
melt_frame = melt(meanSTD, id.vars= "Subject_Activity", measure.vars=Variables)  #MELT DATA FRAME BY NEW COLUMN Subject_Activity
untidy_final_data = dcast(melt_frame, Subject_Activity ~ variable, mean)  #CALCULATE MEAN OF EACH VARIABLE FOR EACH COMBINATION OF SUBJECT AND ACTIVITY
library(tidyr)				#LOAD TIDYR PACKAGE TO CLEAN UP FINAL TABLE
variableVector <- names(untidy_final_data[,2:80])			#CREATE CHARACTER VECTOR OF VARIABLE NAMES
tidierData <- gather(untidy_final_data, Subject_Activity)	#GATHER AND SEPARATE FRAME BY SUBJECT AND ACTIVITY
tidyData <- separate(data = tidierData, col = Subject_Activity, into = c("Subject", "Activity"))
names(tidyData) <- c("Subject", "Activity", "Variable", "Mean")  #CLEAN UP COLUMN NAMES OF FINAL DATASET
write.table(tidyData, file = "~/Data/tidy/tidyData.txt", row.name = FALSE)  #SAVE DATASET TO TXT FILE
