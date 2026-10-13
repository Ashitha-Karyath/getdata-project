# run_analysis.R
# Getting and Cleaning Data - course project
# Produces tidy_data.txt from the UCI HAR Dataset (Samsung Galaxy S accelerometer data)

library(dplyr)

# ---- 0. Download and unzip the data --------------------------------------
zip_url  <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip_file <- "UCI_HAR_Dataset.zip"
data_dir <- "UCI HAR Dataset"

if (!file.exists(data_dir)) {
  if (!file.exists(zip_file)) {
    download.file(zip_url, destfile = zip_file, mode = "wb")
  }
  unzip(zip_file)
}

# ---- 1. Read the shared lookup tables ------------------------------------
features <- read.table(file.path(data_dir, "features.txt"),
                       col.names = c("index", "feature"),
                       stringsAsFactors = FALSE)
activity_labels <- read.table(file.path(data_dir, "activity_labels.txt"),
                              col.names = c("activity_id", "activity"),
                              stringsAsFactors = FALSE)

# Helper to read one split (train or test) and attach subject and activity
read_split <- function(split) {
  x <- read.table(file.path(data_dir, split, paste0("X_", split, ".txt")),
                  col.names = features$feature, check.names = FALSE)
  y <- read.table(file.path(data_dir, split, paste0("y_", split, ".txt")),
                  col.names = "activity_id")
  s <- read.table(file.path(data_dir, split, paste0("subject_", split, ".txt")),
                  col.names = "subject")
  cbind(subject = s$subject, activity_id = y$activity_id, x)
}

# ---- Step 1: merge training and test sets --------------------------------
train  <- read_split("train")
test   <- read_split("test")
merged <- rbind(train, test)

# ---- Step 2: keep only mean() and std() measurements ---------------------
# (meanFreq() and the angle(...Mean) variables are not mean/std of a measurement)
keep <- grepl("-(mean|std)\\(\\)", features$feature)
selected <- cbind(merged[, c("subject", "activity_id")],
                  merged[, 2 + which(keep)])

# ---- Step 3: descriptive activity names ----------------------------------
selected <- merge(selected, activity_labels, by = "activity_id")
selected$activity <- tolower(gsub("_", " ", selected$activity))
selected$activity_id <- NULL

# ---- Step 4: descriptive variable names ----------------------------------
clean_names <- names(selected)
clean_names <- gsub("^t", "time", clean_names)
clean_names <- gsub("^f", "frequency", clean_names)
clean_names <- gsub("Acc", "Accelerometer", clean_names)
clean_names <- gsub("Gyro", "Gyroscope", clean_names)
clean_names <- gsub("Mag", "Magnitude", clean_names)
clean_names <- gsub("BodyBody", "Body", clean_names)
clean_names <- gsub("-mean\\(\\)", "Mean", clean_names)
clean_names <- gsub("-std\\(\\)", "Std", clean_names)
clean_names <- gsub("-", "", clean_names)
names(selected) <- clean_names

# put identifiers first
selected <- selected[, c("subject", "activity",
                         setdiff(names(selected), c("subject", "activity")))]

# ---- Step 5: independent tidy data set of averages -----------------------
tidy <- selected %>%
  group_by(subject, activity) %>%
  summarise(across(everything(), mean), .groups = "drop") %>%
  arrange(subject, activity)

write.table(tidy, "tidy_data.txt", row.names = FALSE)
