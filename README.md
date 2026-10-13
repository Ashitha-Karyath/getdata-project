# Getting and Cleaning Data - Course Project

This repo contains my solution to the course project. The raw data come from the
UCI Human Activity Recognition Using Smartphones dataset (Samsung Galaxy S
accelerometer and gyroscope signals from 30 volunteers performing 6 activities).

## Files

| File | Purpose |
|------|---------|
| `run_analysis.R` | The only script. Downloads, cleans and summarises the data. |
| `CodeBook.md` | Describes the variables, the data and every transformation applied. |
| `tidy_data.txt` | Output of the script: the tidy data set from step 5. |

## How to run

1. Install the `dplyr` package: `install.packages("dplyr")`.
2. Set the working directory to this repo and run `source("run_analysis.R")`.
3. The script downloads and unzips the data into `UCI HAR Dataset/` if it isn't
   already there, then writes `tidy_data.txt`.
4. Read the result back with `read.table("tidy_data.txt", header = TRUE)`.

## How the script works

1. **Merge.** Reads `X_`, `y_` and `subject_` files for the `train` and `test`
   splits, labels the 561 feature columns from `features.txt`, combines the
   pieces for each split, then stacks the two splits (10,299 rows).
2. **Extract.** Keeps only the columns whose names contain `-mean()` or `-std()`
   (66 measurements). `meanFreq()` and `angle()` variables are excluded.
3. **Activity names.** Replaces the numeric activity ids with the names from
   `activity_labels.txt`.
4. **Variable names.** Expands abbreviations (`t` to `time`, `f` to `frequency`,
   `Acc` to `Accelerometer`, `Gyro` to `Gyroscope`, `Mag` to `Magnitude`), fixes
   the `BodyBody` typo and removes punctuation.
5. **Tidy set.** Groups by subject and activity and averages every measurement,
   giving 180 rows (30 subjects x 6 activities) and 68 columns.

The raw Inertial Signals folders are not used, since they contain no mean or
standard deviation columns.
