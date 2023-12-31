

library(tidyverse)

#' Here's the dataframe that we'll analyze in this exercise:

scores <-   tibble(
  name = c("munir", "raeesa", "rafiq", "maria", "pervaiz", "jamila", "bobby", "saima", "alina"),
  school = c("south", "south", "south", "south", "north", "north", "north", "south", "south"),
  teacher = c("jamil", "jamil", "jamil", "jamil",  "sami", "sami", "sami", "fareeha", "fareeha"),
  sex = c("male", "female", "male", "female", "male", "female", "male", "female", "female"),
  math_score = c(4, 3, 2, 4, 3, 4, 5, 4, 5),
  reading_score = c(1, 5, 2, 4, 5, 4, 1, 5, 4)
)

#' 
#' Let's first take a look at it:
#' 

scores

#' Before we get started, I want to make sure you understand the difference between doing something and assigning
#'  it to a new name and just doing it without naming it. For example, make sure you understand the following:


#<-    OR  =

x= 1+2
x


scores |> group_by(sex) |> count()


# get the first 3 rows
scores %>% 
  slice(1:3)

# get the first 3 rows, and assign it to a new name "scores_small"
scores_small <- scores |>
  slice(1:3)

# see what's in "scores_small"
scores_small
#' In this exercise we'll typically just print the results and not save them, but it's an option if you want it! 
#' Now we can get to the exercise. Most sections will begin with an example for you to look at. When questions require a 
#' written answer, there will be an "Answer" line for you to complete.

##### Arrange

## Example
#' 
#' **Question:** Sort the data by math_score from high to low. Who had the best math score?   
#' 

scores |>
  arrange(desc(math_score))

#' 
#' **Answer:** Bobby and alina both tied for the highest math score
#' 
#' ## Q1
#' 
#' **Question:** Sort the data by name from first to last in the alphabet.
#' 

scores |>
  arrange(name)

#' 
#' ## Q2
#' 
#' **Question:** Sort the data by sex so females show up first. Which sex appears 
#' to have better reading scores?   
#' 

scores |>
  arrange(sex)

#' 
#' **Answer:** Females seem to have better reading scores -- they all got either 4 or 5.
#' 
#' ## Q3
#' 
#' **Question:** Sort the data by school, then teacher, then sex, then math_score, and 
#' finally by reading_score. 
#' 

scores |>
  arrange(school, teacher, sex, math_score, reading_score)

#' 
#' # Select
#' 
#' ## Example
#' 
#' **Question:** Select only the name, math_score, and reading_score columns.
#' 

scores |>
  select(name, math_score, reading_score)

#' 
#' ## Q1 
#' 
#' **Question:** Select all of the columns except the sex column.  
#' 

scores |>
  select(-sex)

#' 
#' ## Q2 
#' 
#' **Question:** Select all of the columns except the math_score and reading_score columns.
#' 

scores |>
  select(-math_score, -reading_score)

#' 
#' ## Q3 
#' 
#' **Question:** Keep all of the columns but rearrange them so sex is the first column.
#' 

scores |>
  select(sex, everything())

#' 
#' # Filter
#' 
#' ## Example
#' 
#' **Question:** Filter to students who are male and went to south.
#' 

# Option 1
scores |>
  filter(sex == "male" & school == "south")

# Option 2
scores |>
  filter(sex == "male", school == "south")

#' 
#' ## Q1
#' 
#' **Question:** Filter to students who did well in math (you decide what "well" means).
#' 

scores |>
  filter(math_score >= 4)

#' 
#' ## Q2
#' 
#' **Question:** Use filter to figure out how many students had a math score of 4 or more 
#' and a reading score of 3 or more. 
#' 

scores |>
  filter(math_score >= 4, reading_score >= 3)

#' 
#' **Answer** There are 4 such students.
#' 
#' ## Q3
#' 
#' **Question:** Explain the errors in each of the following code blocks, then fix it to
#'  make it right! 
#' 

# code block 1
scores |>
  filter(school == south)

# code block 2
scores |>
  filter(school = "south")

# fix it! 
scores |>
  filter(school == "south")

#' 
#' **Answer:** Code block 1 doesn't use quotation marks so R thinks it is looking for an object 
#' not a word. Code block 2 uses only one equals sign "=" when we need two equals signs "==" for comparison.
#' 
#' ## Q4
#' 
#' **Question:** You are creating a remediation program. Filter to students who got a 3 or worse in 
#' either math or reading.
#' 

scores |>
  filter(math_score <= 3 | reading_score <= 3)

#' 
#' ## Q5
#' 
#' **Question:** Filter to students who got a reading score of 2, 3, or 4.
#' 

# option 1
scores |>
  filter(reading_score %in% c(2, 3, 4))

# option 2 (if you know that 1 and 5 are the only other 2 options)
scores |>
  filter(reading_score != 1, reading_score != 5)

#' 
#' ## Challenge
#' 
#' **Question:** Filter to students who have a name that starts with an "m". Hint: type "?substr" 
#' in the console and then scroll to the bottom of the help file to see useful examples.
#' 
?substr
scores |>
  filter(substr(name, 1, 1) == "m")

#' 
#' # Filter with groups
#' 
#' ## Example
#' 
#' **Question:** Filter to teachers whose best math student got a score of 5.
#' 

scores |>
  group_by(teacher) |>
  filter(max(math_score) == 5)

#' 
#' ## Q1
#' 
#' **Question:** Filter to the sex with a mean math score of 4.   
#' 

scores |>
  group_by(sex) |>
  filter(mean(math_score) == 4)

#' 
#' ## Q2
#' 
#' **Question:** Explain why the following code removes students who have fareeha as their teacher.  
#' 

scores |>
  group_by(teacher) |>
  filter(n() >= 3)

#' 
#' **Answer:** The "n()" stands for the number of rows. This returns the teachers with 3 or more rows 
#' in the data frame. This excludes fareeha because there are only 2 students who have fareeha as their teacher.
#' 
#' # Mutate
#' 
#' ## Example
#' 
#' **Question:** Both the math and reading scores were actually out of 50 -- replace both variables to be 10 times
#'  their original values.
#' 

scores |>
  mutate(math_score =  math_score * 10,
         reading_score = reading_score * 10)

#' 
#' ## Q1
#' 
#' **Question:** Create a new column called "math_reading_avg" which is the average of a students math and 
#' reading scores.
#' 

scores |>
  mutate(math_reading_avg = (math_score + reading_score) / 2)

#' 
#' ## Q2 
#' 
#' **Question:** Create a new column "high_math_achiever" that is an indicator of if a student got a 4 or better
#'  on their math_score.
#' 

scores |>
  mutate(high_math_achiever = math_score >= 4)

#' 
#' ## Q3 
#' 
#' **Question:** Create a new column "reading_score_centered" that is a students reading score with the mean
#'  of all students' reading scores subtracted from it.
#' 

scores |>
  mutate(reading_score_centered = reading_score - mean(reading_score))

#' 
#' ## Q4 
#' 
#' **Question:** Create a new column "science_score". You can make up what the actual scores are!
#' 

scores |>
  mutate(science_score = c(1, 2, 3, 4, 5, 4, 3, 2, 1))

#' 
#' # Mutate with groups
#' 
#' ## Q1
#' 
#' **Question:** munir and saima both got a 4 for their math score. Explain why why munir has a higher 
#' "math_score_centered_by_sex" score.
#' 

scores |>
  group_by(sex) |>
  mutate(math_score_centered_by_sex = math_score - mean(math_score))

#' 
#' **Answer:** We are subtracting the mean math score for that person's sex off of their score. 
#' munir has a higher "math_score_centered_by_sex" because males did worse on average on math and so a small number is subtracted off of his score of 4.
#' 
#' ## Q2
#' 
#' **Question:** Create a "reading_score_centered_by_teacher" column. What can you learn from it?
#' 

scores |>
  group_by(teacher) |>
  mutate(reading_score_centered_by_teacher = reading_score - mean(reading_score))

#' 
#' **Answer:** We can learn lots of things! For example, relative to other students in their class, 
#' bobby did worst on reading and raeesa did the best.
#' 
#' ## Q3
#' 
#' **Question:** Make a "number_of_students_in_class" column that is number of students in a student's class. 
#' For example, it should be 4 for munir and 3 for pervaiz.
#' 

scores |>
  group_by(teacher) |>
  mutate(number_of_students_in_class = n())

#' 
#' # Summarize
#' 
#' ## Example
#' 
#' **Question:** Use the summarize command to find the mean math score for all students.
#' 

scores |>
  summarize(math_score_mean = mean(math_score))

#' 
#' ## Q1
#' 
#' **Question:** Use the summarize command to find the mean reading score for all students.
#' 

scores |>
  summarize(reading_score_mean = mean(reading_score))

#' 
#' ## Q2
#' 
#' **Question:** Use the summarize command to find the median for both math scores and reading scores.
#' 

scores |>
  summarize(
    math_score_median = median(math_score),
    reading_score_median = median(reading_score)
  )

#' 
#' ## Q3
#' 
#' **Question:** Look closely at the following code. Why is it throwing an error? How can Rstudio help you see this error?
#' 

scores |>
  summarize(math_score_max = max(math_score),
            reading_score_min = min(reading_score))

#' 
#' **Answer:** We need another ")" at the end of the code. The first ")" is for the min function but we also need a ")"
#'  to end the summarize function. Rstudio helps because if you go to the right of a paranthese, it highlights the
#'   corresponding closing paranthese. 
#' 
#' # Summarize with groups
#' 
#' ## Example
#' 
#' **Question:** Find the minimum math score for each school.
#' 

scores |>
  group_by(school) |>
  summarize(min_math_score = min(math_score))

#' 
#' ## Q1 
#' 
#' **Question:** Find the maximum math score for each teacher.
#' 

scores |>
  group_by(teacher) |>
  summarize(max_math_score = max(math_score))

#' 
#' ## Q2
#' 
#' **Question:** If we grouped by sex, and then summarized with the minimum reading score, how many rows would the
#'  resulting data frame have?
#' 
#' **Answer:** There would be one for each group. Because there are two sexs in the data frame, there would be two rows. See:
#' 

scores |>
  group_by(sex) |>
  summarize(min(reading_score)) # side note: notice what happens when we don't provide a variable name

#' 
#' ## Q3
#' 
#' **Question:** Remember that mutate always keeps the same number of rows but summarize usually reduces the number of rows. 
#' Why doesn't the following use of summarize reduce the number of rows?
#' 

scores |>
  group_by(name) |>
  summarize(math_score_mean = mean(math_score))

#' 
#' **Answer:** Summarize with groups makes one row for each group. In this case, we're grouping by name 
#' and everyone  has a different name! 
#' 
#' ## Q4 
#' 
#' **Question:** Create a data frame with the mean and median reading score by sex, as well as the number of students 
#' of that sex.
#' 

scores |>
  group_by(sex) |>
  summarize(
    mean_reading_score = mean(reading_score),
    median_reading_score = median(reading_score),
    count = n()
  )

#' 
#' # Combining verbs
#' 
#' ## Example
#' 
#' **Question:** Select just the name and math_score columns. Then create a new column "math_score_ec" that
#'  is a students math score plus 5 extra credit points. Finally, arrange the data frame by math_score_ec from low to high.
#' 

scores |>
  select(name, math_score) |>
  mutate(math_score_ec = math_score + 5) |>
  arrange(math_score_ec)

#' 
#' ## Q1 
#' 
#' **Question:** Select every column except the teacher column. Create a new variable called 
#' "mean_score" that is the mean of a student's math and reading score. Finally, arrange the data 
#' frame by mean_score from low to high.
#' 

scores |>
  select(-teacher) |>
  mutate(mean_score = (math_score + reading_score) / 2) |>
  arrange(desc(mean_score))

#' 
#' ## Q2 
#' 
#' **Question:** Remove any students with sami as a teacher, then find the mean math_score by sex.
#' 

scores |>
  filter(teacher != "sami") |>
  group_by(sex) |>
  summarize(mean_math_score = mean(math_score))

#' 
#' ## Q3
#' 
#' **Question:** Find the min, max, and median reading_score for female students at south school.
#' 

scores |>
  filter(sex == "female", school == "south") |>
  summarize(min_reading_score = min(reading_score),
            max_reading_score = max(reading_score),
            median_reading_score = median(reading_score))

#' 
#' ## Q4
#' 
#' **Question:** Inspect each of the following code blocks. They both do about the same thing. 
#' Which one do you think is preferred from a computer efficiency standpoint?
#' 

# code block 1
scores |>
  group_by(school, teacher) |>
  summarize(max_math_score = max(math_score)) |>
  filter(school == "south")

# code block 2
scores |>
  filter(school == "south") |>
  group_by(teacher) |>
  summarize(max_math_score = max(math_score))

#' 
#' **Answer:** They both get the max math score by teacher for teachers at south school. 
#' The first block calculates the max_math_score for both north and south and then filters 
#' out north after that calculation. The second block filters out north right away. 
#' This is preferred because it prevents the computer from making unnecessary calculations.
#' 
#' ## Challenge
#' 
#' Play around with these tools. Write a question or two that you think best exposes a 
#' misunderstanding you had or drills down on an important thing to remember. I'd love to 
#' add these questions in the future! Feel free to email what you came up with to 
