# Code Book

## Source data

UCI HAR Dataset: accelerometer and gyroscope signals recorded from a Samsung
Galaxy S smartphone worn on the waist by 30 volunteers (aged 19-48) performing
six activities. Full description:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The raw signals were sampled at 50 Hz, filtered, and split into 2.56 s windows.
Features in the original data are normalised and bounded within [-1, 1], so they
have no units.

## Transformations (performed by `run_analysis.R`)

1. Training (7,352 rows) and test (2,947 rows) sets were merged into one data set of
   10,299 rows, with subject and activity columns attached.
2. Only measurements whose original names contain `mean()` or `std()` were kept
   (33 means and 33 standard deviations = 66 measurements).
3. Activity ids 1-6 were replaced with descriptive names.
4. Variable names were made descriptive (see the naming rules below).
5. The data were grouped by subject and activity and each measurement was
   averaged, producing the tidy data set `tidy_data.txt`
   (180 rows x 68 columns, one row per subject-activity pair).

## Identifier variables

| Variable | Description | Values |
|----------|-------------|--------|
| `subject` | Volunteer id | Integer 1 to 30 |
| `activity` | Activity performed | `laying`, `sitting`, `standing`, `walking`, `walking downstairs`, `walking upstairs` |

## Measurement variables (66)

Every value is the **average, per subject and activity, of the original
normalised feature**. Values are unitless and lie in [-1, 1].

### Naming rules

`<domain><Signal><Sensor>[Jerk][Magnitude]<Statistic>[Axis]`

- **domain**: `time` = time-domain signal; `frequency` = frequency-domain signal (FFT).
- **Signal**: `Body` = body motion; `Gravity` = gravity component (time domain only).
- **Sensor**: `Accelerometer` (from the accelerometer) or `Gyroscope` (from the gyroscope).
- **Jerk**: jerk signal derived from the body linear acceleration or angular velocity.
- **Magnitude**: Euclidean magnitude of the three axes.
- **Statistic**: `Mean` = mean value; `Std` = standard deviation.
- **Axis**: `X`, `Y` or `Z`, the axis of the signal (absent for magnitude variables).

### Variables

Time domain:

- `timeBodyAccelerometerMeanX`, `...MeanY`, `...MeanZ`, `timeBodyAccelerometerStdX`, `...StdY`, `...StdZ`
- `timeGravityAccelerometerMeanX/Y/Z`, `timeGravityAccelerometerStdX/Y/Z`
- `timeBodyAccelerometerJerkMeanX/Y/Z`, `timeBodyAccelerometerJerkStdX/Y/Z`
- `timeBodyGyroscopeMeanX/Y/Z`, `timeBodyGyroscopeStdX/Y/Z`
- `timeBodyGyroscopeJerkMeanX/Y/Z`, `timeBodyGyroscopeJerkStdX/Y/Z`
- `timeBodyAccelerometerMagnitudeMean`, `timeBodyAccelerometerMagnitudeStd`
- `timeGravityAccelerometerMagnitudeMean`, `timeGravityAccelerometerMagnitudeStd`
- `timeBodyAccelerometerJerkMagnitudeMean`, `timeBodyAccelerometerJerkMagnitudeStd`
- `timeBodyGyroscopeMagnitudeMean`, `timeBodyGyroscopeMagnitudeStd`
- `timeBodyGyroscopeJerkMagnitudeMean`, `timeBodyGyroscopeJerkMagnitudeStd`

Frequency domain:

- `frequencyBodyAccelerometerMeanX/Y/Z`, `frequencyBodyAccelerometerStdX/Y/Z`
- `frequencyBodyAccelerometerJerkMeanX/Y/Z`, `frequencyBodyAccelerometerJerkStdX/Y/Z`
- `frequencyBodyGyroscopeMeanX/Y/Z`, `frequencyBodyGyroscopeStdX/Y/Z`
- `frequencyBodyAccelerometerMagnitudeMean`, `frequencyBodyAccelerometerMagnitudeStd`
- `frequencyBodyAccelerometerJerkMagnitudeMean`, `frequencyBodyAccelerometerJerkMagnitudeStd`
- `frequencyBodyGyroscopeMagnitudeMean`, `frequencyBodyGyroscopeMagnitudeStd`
- `frequencyBodyGyroscopeJerkMagnitudeMean`, `frequencyBodyGyroscopeJerkMagnitudeStd`

## Excluded on purpose

`meanFreq()` variables and the `angle(...)` variables were not kept, because they
are not the mean or standard deviation of a measured signal.
