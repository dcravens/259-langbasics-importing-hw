#PSYC 259 Homework 1 - Data Import
#For full credit, provide answers for at least 4/8 questions

#List names of students collaborating with (no more than 2): N/A

#GENERAL INFO 
#data_A contains 12 files of data. 
#Each file (6192_3.txt) notes the participant (6192) and block number (3)
#The header contains metadata about the session
#The remaining rows contain 4 columns, one for each of 20 trials:
#trial_number, speed_actual, speed_response, correct
#Speed actual was whether the figure on the screen was actually moving faster/slower
#Speed response was what the participant report
#Correct is whether their response matched the actual speed

### QUESTION 1 ------ 

# Load the readr package

# ANSWER
library(readr) #for read_txt

### QUESTION 2 ----- 

# Read in the data for 6191_1.txt and store it to a variable called ds1
# Ignore the header information, and just import the 20 trials
# Be sure to look at the format of the file to determine what read_* function to use
# And what arguments might be needed

# ds1 should look like this:

# # A tibble: 20 × 4
#  trial_num    speed_actual speed_response correct
#   <dbl>       <chr>        <chr>          <lgl>  
#     1          fas          slower         FALSE  
#     2          fas          faster         TRUE   
#     3          fas          faster         TRUE   
#     4          fas          slower         FALSE  
#     5          fas          faster         TRUE   
#     6          slo          slower         TRUE
# etc..

# ANSWER
fname <- "data_A/6191_1.txt" #Setting up variable to use with "read_" options

# A list of column names are provided to use:
col_names  <-  c("trial_num","speed_actual","speed_response","correct")


ds1 <- read_delim(file = fname, col_names = col_names, skip = 7)
print (ds1) #Read in data while skipping first 7 rows

### QUESTION 3 ----- 

# For some reason, the trial numbers for this experiment should start at 100
# Create a new column in ds1 that takes trial_num and adds 100
# Then write the new data to a CSV file in the "data_cleaned" folder

# ANSWER
ds1$trial_num <- (ds1$trial_num + 100)
print (ds1) #Adding 100 to each trial number 

dir.create("data_cleaned/data_A", recursive = TRUE, showWarnings = FALSE) #Creating "data_cleaned" folder

write_csv(ds1, file = "data_cleaned/data_A/6191_1.csv") #Writing the combined data to disk (aka cleaned data file)

### QUESTION 4 ----- 

# Use list.files() to get a list of the full file names of everything in "data_A"
# Store it to a variable

# ANSWER
file_list <- list.files("data_A", full.names = TRUE)
print (file_list) #Storing full file names in "data_A" into a variable

### QUESTION 5 ----- 

# Read all of the files in data_A into a single tibble called ds

# ANSWER
full_file_names <- list.files('data_A', full.names = TRUE)
ds <- read_csv(full_file_names, col_names = col_names, skip = 7)
print(ds) #Reading all files into a single tibble called ds

### QUESTION 6 -----

# Try creating the "add 100" to the trial number variable again
# There's an error! Take a look at 6191_5.txt to see why.
# Use the col_types argument to force trial number to be an integer "i"
# You might need to check ?read_tsv to see what options to use for the columns
# trial_num should be integer, speed_actual and speed_response should be character, and correct should be logical
# After fixing it, create the column to add 100 to the trial numbers 
# (It should work now, but you'll see a warning because of the erroneous data point)

# ANSWER
full_file_names <- list.files('data_A', full.names = TRUE)
ds <- read_csv(full_file_names, col_names = col_names, col_types = cols(
  trial_num = col_integer(), skip = 7))
print(ds) #Reading all files into a single tibble called ds while specifying "trial_num" is treated as an integer

ds$trial_num <- (ds$trial_num + 100)
print(ds) #Adding 100 to each trial number 

### QUESTION 7 -----

# Now that the column type problem is fixed, take a look at ds
# We're missing some important information (which participant/block each set of trials comes from)
# Read the help file for read_tsv to use the "id" argument to capture that information in the file
# Re-import the data so that filename becomes a column

# ANSWER
file_list <- list.files("data_A", full.names = TRUE, pattern = "\\.txt$") #Reading all files

combined_data <- purrr::map_dfr(
  file_list,
  ~ read_tsv(.x, col_types = cols(trial_num = col_integer()), id = "filename")
) #Importing and capturing filename as a column using the id argument

print(combined_data) #Print table

### QUESTION 8 -----

# Your PI emailed you an Excel file with the list of participant info 
# Install the readxl package, load it, and use it to read in the .xlsx data in data_B
# There are two sheets of data -- import each one into a new tibble

# ANSWER
install.packages("readxl")
library(readxl) #Installing package

data_B <- read_excel("data_B/participant_info.xlsx")
print(data_B) #Importing data

sheet1 <- read_excel("data_B/participant_info.xlsx", sheet = 1)
print(sheet1) #Importing data of sheet 1

sheet2 <- read_excel("data_B/participant_info.xlsx", sheet = 2)
print(sheet2) #Importing data of sheet 2
