# Load necessary libraries
library(tidyr)
library(dplyr)
library(lubridate)
library(janitor)


# Specify the directory containing the CSV files
data_dir <- "C:/Users/33775/Documents/Data Analyst/Other/bellabeat data/archive/mturkfitbit_export_4.12.16-5.12.16/Fitabase Data 4.12.16-5.12.16/"

# Get a list of all CSV files in the directory
csv_files <- list.files(data_dir, pattern = "*.csv", full.names = TRUE)

# Loop through each file, read the CSV, and assign it to a variable
for (csv_file in csv_files) {
  # Extract the file name without the extension
  file_name <- tools::file_path_sans_ext(basename(csv_file))
  
  # Create a variable name based on the file name
  var_name <- make.names(file_name)
  
  # Read the CSV file
  data <- read.csv(csv_file)
  
  # Assign the data frame to a variable with the name derived from the file name
  assign(var_name, data)
}

# Verify that the variables have been created
ls()

#Exploring and summarizing data
n_distinct(dailyActivity_merged$Id)
n_distinct(hourlyIntensities_merged$Id)
n_distinct(sleepDay_merged$Id)
n_distinct(weightLogInfo_merged$Id)

#remove duplicates and NA

dailyActivity_merged <- dailyActivity_merged %>%
  distinct() %>%
  drop_na()


hourlyIntensities_merged <- hourlyIntensities_merged %>%
  distinct() %>%
  drop_na()

sleepDay_merged <- sleepDay_merged %>%
  distinct() %>%
  drop_na()

weightLogInfo_merged <- weightLogInfo_merged %>%
  distinct() %>%
  drop_na(Id, BMI, WeightKg)

# Display summary and view data
summary(dailyActivity_merged)
View(dailyActivity_merged)

# Filter and mutate the data in place
dailyActivity_merged <- dailyActivity_merged %>% 
  filter(TotalSteps != 0 & Calories != 0) %>%
  mutate(ActivityDate = as.Date(ActivityDate, "%m/%d/%Y"))

# Display summary of the modified data
summary(dailyActivity_merged)


# Separate the Time column into Date and Time columns
hourlyIntensities_merged <- hourlyIntensities_merged %>%
  separate(ActivityHour, into = c("Date", "Time"), sep = " ")

sleepDay_merged <- sleepDay_merged %>%
  separate(SleepDay, into = c("Date", "Time"), sep = " ")

# Convert Date and Time columns to appropriate formats using lubridate
hourlyIntensities_merged <- hourlyIntensities_merged %>%
  mutate(Date = mdy(Date),
         Time = hms(Time))

sleepDay_merged <- sleepDay_merged %>%
  mutate(Date = mdy(Date),
         Time = hms(Time))

# Display summary of the modified heartrate_seconds data
# summary(heartrate_seconds_merged)
# Info <- weightLogInfo_merged %>%
#   group_by(Id) %>%
#   summarize(mean(BMI))

#Clean and rename columns

dailyActivity_merged = clean_names(dailyActivity_merged)
hourlyCalories_merged = clean_names(hourlyCalories_merged)
hourlyIntensities_merged = clean_names(hourlyIntensities_merged)
sleepDay_merged = clean_names(sleepDay_merged)
weightLogInfo_merged = clean_names(weightLogInfo_merged)
dailyActivity_merged <-dailyActivity_merged %>%
  rename(date = activity_date)


# Merging Datasets

daily_activity_sleep_merged <- merge(dailyActivity_merged, sleepDay_merged, by=c ("id", "date"))
glimpse(daily_activity_sleep_merged)

#Analyse

# Specify the Output directory 
Output_dir <- "C:/Users/33775/Documents/Data Analyst/Other/OutPut Bellabeat/"

# Define the output file path
output_file_path <- file.path(Output_dir, paste0("daily_activity_sleep_merged_8_6_2024_v1", ".csv"))

# Write the data frame to a CSV file
write.csv(daily_activity_sleep_merged, file = output_file_path, row.names = FALSE)

# Define the output file path
output_file_path <- file.path(Output_dir, paste0("weightLogInfo_merged_8_6_2024_v1", ".csv"))

# Write the data frame to a CSV file
write.csv(weightLogInfo_merged, file = output_file_path, row.names = FALSE)

# Define the output file path
output_file_path <- file.path(Output_dir, paste0("hourlyIntensities_merged_8_6_2024_v1", ".csv"))

# Write the data frame to a CSV file
write.csv(hourlyIntensities_merged, file = output_file_path, row.names = FALSE)



# Read the image
img_magick <- image_read("../input/logo-bellabeat/logo.png")

# Reduce the size by half (by 2)
img_resized <- image_resize(img_magick, geometry = "50%")

# Display the resized image
print(img_resized)