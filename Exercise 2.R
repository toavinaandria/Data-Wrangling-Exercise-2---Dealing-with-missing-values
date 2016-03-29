# Load libraries
library(dplyr)
library(tidyr)

# Load data in table and remove blank row
raw_data <- tbl_df(read.csv("titanic_original.csv"))
raw_data <- head(raw_data, -1)

# Replace missing ports with Southampton, S
# Note that the Springboard data mentions one value missing, when there are actually two
altered_data <- raw_data %>% mutate(embarked = replace(embarked, embarked=="", "S"))

# Replace missing age values with the mean age 
mean_age <- mean(altered_data$age, na.rm = TRUE)
altered_data <- altered_data %>% mutate(age = replace(age, is.na(age), mean_age))

# Note - We could have used median data, but the mean and median of the raw data are very similar
# We could also have grouped the data by gender and calculated mean and median if there was a correlation
# However, doing this through the code altered_data  %>% group_by(sex) %>% summarise(mean(age)) shows that there is a
# small difference, but not significant. Short of getting more data on missing values (is there a correlation between
# missing age and other factors?), this is a good approximation

# Replace missing values of the boat with NA
altered_data <- altered_data %>% mutate(boat = replace(boat, boat=="", NA))

# Create dummy column to check whether there is a cabin number or not
final_data <- altered_data %>% mutate(has_cabin_number = ifelse(cabin != "",1,0))

## Note that there is a clustering of cabins alphabetically - hunch is that perhaps a roll call was done alphabetically
## for the first lifeboats, increasing the odds of surviving for people with lucky names

# Write final csv file
write.csv(final_data, file = "titanic.clean.csv")

