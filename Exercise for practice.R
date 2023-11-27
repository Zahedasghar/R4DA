# 1. Data Manipulation with dplyr:
library(dplyr)
#   - Load the mtcars dataset from the datasets package. 
data(mtcars)
# - Use dplyr functions to filter the dataset to include only cars with mpg greater than 20. 
mtcars %>% filter(mpg > 20)
# - Use arrange() to sort the dataset by descending order of horsepower. 
mtcars %>% arrange(desc(hp))
# - Use select() to keep only the columns "mpg", "cyl", and "gear". 
mtcars %>% select(mpg, cyl, gear)
# - Use mutate() to create a new column called "km_per_liter" which is the mpg converted to kilometers per liter.
mtcars %>% mutate(km_per_liter = mpg * 0.425144)
# - Use group_by() and summarize() to calculate the average horsepower for each number of cylinders.
mtcars %>% group_by(cyl) %>% summarize(avg_hp = mean(hp))
# 
# 2. Data Visualization with ggplot2:
#   - Load the mpg dataset from the ggplot2 package.
data(mpg)
# - Create a scatter plot using ggplot() and geom_point() to visualize the relationship between highway mpg and engine displacement (displ).
ggplot(mpg, aes(x = displ, y = hwy)) + geom_point()
# - Color the points based on the number of cylinders (cyl).
ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) + geom_point()
# - Add a smooth line using geom_smooth() to visualize the trend. 
ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) + geom_point() + geom_smooth()
# - Add labels to the x and y axes and give the plot a title. 
ggplot(mpg, aes(x = displ, y = hwy, color = cyl)) + geom_point() + geom_smooth() + labs(x = "Engine Displacement", y = "Highway MPG", title = "Fuel Efficiency vs. Engine Size")
# 
# 3. Data Cleaning with tidyr:
#   - Create a data frame with missing values using data.frame() or tibble().
df <- data.frame(x = c(1, 2, NA), y = c(NA, 3, 4))

# - Use separate() to split a column into multiple columns based on a delimiter.
df %>% separate(x, into = c("a", "b"))
# - Use unite() to combine multiple columns into a single column.
# 
# 4. Data Analysis with purrr:
#   - Create a list of numbers using list() or c().
list(1, 2, 3)
# - Use map() to apply a function to each element of the list and return a new list.
map(list(1, 2, 3), sqrt)
# - Use map_dbl() to apply a function to each element of the list and return a numeric vector.
map_dbl(list(1, 2, 3), sqrt)
# - Use map_df() to apply a function to each element of the list and return a data frame.
map_df(list(1, 2, 3), sqrt)
# - Use reduce() to combine the elements of a list into a single value.
reduce(list(1, 2, 3), `+`)
# 
# These exercises cover some of the key concepts and functions in the tidyverse and will help participants get familiar with data manipulation, visualization, cleaning, and analysis using R.