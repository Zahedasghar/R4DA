
# load data and set "B" (benign) as the reference level
library(tidyverse)
cells <- read_csv("https://www.dropbox.com/s/0rbzonyrzramdgl/cells.csv?dl=1") %>%
  mutate(diagnosis = factor(diagnosis, levels = c("B", "M")))

#' 
#' The diagnosis is in the column named `diagnosis`; each other column should be used to predict the diagnosis.
#' 
#' ### Understanding and Exploring the Data
#' 
#' #### Question 1
#' 
#' What is the unit of observation in this data frame?
#' 

cells |> head()

dim(cells)

colnames(cells)

#' #### Question 2
#' 
#' Use a box plot to compare the `radius_mean` for benign vs. malignant biopsies. What is the takeaway from this plot?
#' 

cells |> 
  ggplot(aes(x=diagnosis,y=radius_mean))+ geom_boxplot()

#' 
#' Radius mean of malignant diagnosis is very high as compared to benign and this is as per ...
#' There are some outliers in both categories.
#' 
#' #### Question 3
#' 
#' Select another variable that you suspect might be a good predictor of the diagnosis. Build a plot to illustrate their association and provide an interpretation of what the plot shows.
#' 
#' 

 cells |> ggplot(aes(x=diagnosis,y=area_mean))+
  geom_boxplot()

#' 
#' 
#' #### Question 4
#' 
#' Make a plot that examines the association between two predictors, `radius_mean` and `area_mean`, and calculate the pearson correlation coefficient between these them. How would you describe the strength and shape of their association? What might cause this shape?
#' 

cells |> ggplot(aes(x=radius_mean,y=area_mean))+
  geom_point()

#' This shows very high correlation though there is evidence of nonlinearity. 
#' 

cells |> summarise(correlation=cor(radius_mean,area_mean,method = "spearman"))

#' #### Question 5
#' 
# Make a single plot that examines the association between `radius_mean` and `radius_sd` separately for each diagnosis (hint: `aes()` should have three arguments). Calculate the correlation between these two variables for each diagnosis.
#' 
#'     Give an interpretation of these results. In particular comment on
#' 
#'     - Is the relationship between `radius_mean` and `radius_sd` different for benign biopsies vs. malignant biopsies?
#' 
#'     - If so, can you give an explanation for this difference?
#' 
#' 
#' ### Diagnosing Biopsies
#' 
#' #### Question 6
#' 
#' Split the full cells data set into a roughly 80-20 train-test set split. How many observations do you have in each?
#' 
#' 
#' #### Question 7
#' 
#Using the training data, fit a simple logistic regression model that predicts
#the diagnosis using the mean of the texture index using a threshold of .5. What
#would your model predict for a biopsy with a mean texture of 15? What
#probability does it assign to that outcome?
#' 
#' 
#' #### Question 8
#' 
#' Calculate the misclassification rate first on the training data and then on
#' the testing data. Is there any evidence that this model is overfitting? How
#' can you tell one way or the other?
#' 
#' 
#' #### Question 9
#' 
#' Build a more complex model to predict the diagnosis using five predictors of
#' your choosing, then calculate the testing and training misclassification
#' rate. Is there evidence that your model is overfitting? How can you tell one
#' way or the other?
#' 
#' 
#' #### Question 10
#' 
#' If you were to deploy your method in a clinical setting to help diagnose
#' cancer, which type of classification error would be worse and why?
#' 
#' 
#' #### Question 11
#' 
#' Calculate the total number of false negatives in the test data set when using
#' your simple model with only one variable.
#' 
#' 
#' #### Question 12
#' 
#' What can you change about your classification rule to lower the number of
#' false negatives? Make this change and calculate the new number of false
#' negatives.
#' 
#' 
#' #### Question 13
#' 
#' Calculate the testing misclassification rate using your new classification
#' rule. Did it go up or down? Why?
#' 
#' 
#' #### Question 14
#' 
#' In many realms of medicine, classification algorithms can be more accurate
#' than the most well-trained medical doctors. What is gained and what is lost
#' by shifting to algorithmic diagnoses? Although a book could be written about
#' this topic, please answer in one paragraph.
