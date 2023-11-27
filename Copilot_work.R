1. Data Manipulation with dplyr:
  library(dplyr)
data(mtcars)
  View(mtcars)

mtcars |> 
  - Load the mtcars dataset from the datasets package.

- Use dplyr functions to filter the dataset to include only cars with mpg greater than 20.

- Use arrange() to sort the dataset by descending order of horsepower.

- Use select() to keep only the columns "mpg", "cyl", and "gear".
- Use mutate() to create a new column called "km_per_liter" which is the mpg converted to kilometers per liter.
- Use group_by() and summarize() to calculate the average horsepower for each number of cylinders.

2. Data Visualization with ggplot2:
  - Load the mpg dataset from the ggplot2 package.
- Create a scatter plot using ggplot() and geom_point() to visualize the relationship between highway mpg and engine displacement (displ).
- Color the points based on the number of cylinders (cyl).
- Add a smooth line using geom_smooth() to visualize the trend.
- Add labels to the x and y axes and give the plot a title.

3. Data Cleaning with tidyr:
  - Create a data frame with missing values using data.frame() or tibble().
- Use gather() to convert the data from wide to long format, with one column for variable names and another for values.
- Use spread() to convert the data from long to wide format, with one column for each variable.
- Use separate() to split a column into multiple columns based on a delimiter.
- Use unite() to combine multiple columns into a single column.

4. Data Analysis with purrr:
  - Create a list of numbers using list() or c().
- Use map() to apply a function to each element of the list and return a new list.
- Use map_dbl() to apply a function to each element of the list and return a numeric vector.
- Use map_df() to apply a function to each element of the list and return a data frame.
- Use reduce() to combine the elements of a list into a single value.

These exercises cover some of the key concepts and functions in the tidyverse and will help participants get familiar with data manipulation, visualization, cleaning, and analysis using R.