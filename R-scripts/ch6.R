---
  title: "Empirical Project 6: Working in R code"
---
  
  # Empirical Project 6 Working in R
  
  These code downloads have been constructed as supplements to the full Doing Economics projects (https://core-econ.org/doing-economics/). You'll need to download the data before running the code that follows. 

## Getting started in R  
  
For this project you will need the following packages:  
  
- `tidyverse`, to help with data manipulation  
- `ggthemes`, to change the look of charts easily.  
  
We will also use the `ggplot2` package to produce graphs, but that does come as part of the `tidyverse` package.  
  
If you need to install either of these packages, run the following code:  
  
```{r}  
install.packages(c("tidyverse","ggthemes"))
```
  
You can import the libraries now, or when they are used in the R walk-throughs below.  

```{r}  
library(tidyverse)  
library(ggthemes)  
```

## Part 6.1 Looking for patterns in the survey data

### R walk-through 6.1 Importing data into R and creating tables and charts

Before uploading an Excel or csv file into R, first open the file in a spreadsheet software (like Excel) to understand how the file is structured. From looking at the file we learn that:

* the variable names are in the first row (no need to use the `skip` option) 
* missing values are represented by empty cells (hence we will use the option `na.strings = ""`) 
* the last variable is in Column S, with short variable descriptions in Column U: it is easier to import everything first and remove the unnecessary data afterwards.

We will call our imported data `man_data`. 

```{r}
# Set working directory
setwd("YOURFILEPATH")

man_data <- read.csv("AMP_graph_manufacturing.csv",
  na.strings = "")
str(man_data)
```

You can see that Column U was imported as two variables, `X` (which only contains ‘NAs’) and `storage..display.....value` (which contains variable information). We will store the variable information in a new vector (`man_varinfo`) and remove both variables from the `man_data` dataset.

```{r}
# Keep the variable information
man_varinfo <- unlist(man_data$
  storage..display.....value[1:23])

# Delete last two variables
man_data <- man_data[, !(names(man_data) %in% 
  c("X", "storage..display.....value"))] 
```

Let's look at the variable information.

```{r}
man_varinfo
```

A few of the variables that have been imported as numbers are actually categorical (‘factor’) variables ( `mne_f` , `mne_d`, and `competition2004`). The reason R thought they were numerical variables was because each category was represented by a number (instead of text). We use the `factor` function to tell R how to treat these variables, and the `labels` option to define what each number in those variables represents. 

```{r}
# Indicates what to call 0 and 1 entries
man_data$mne_f <- factor(man_data$mne_f, 
                         labels = c("no MNE_f", "MNE_f"))
man_data$mne_d <- factor(man_data$mne_d, 
                         labels = c("no MNE_d", "MNE_d"))

# Indicates what to call 1, 2, and 3 entries
man_data$competition2004 <- factor(
  man_data$competition2004, 
  labels = c("No competitors", "A few competitors",
             "Many competitors")) 
```

When you create new labels, check that the labels have been attached to the correct entries (the labels should be ordered from the lowest to highest entry). 

To create the tables, we use piping operators (`%>%`) from the `tidyverse` package, which allow us to run a series of commands on the same data all at once. For more information on how piping works, refer to a short introduction on using piping operators (https://tinyco.re/5531433).[^1] First, we will group data by country (`group_by`), then calculate the required summary statistics for each of these groups (`summarize`), then order the countries according to their overall score (highest to lowest) (`arrange`). When summarising the data, in addition to the mean values for the different categories and the overall score, we add a variable recording how many observations we have for each country (`obs`). 

[^1]: University of Manchester’s Econometric Computing Learning Resource (ECLR). 2018. ‘R AnalysisTidy’. Updated 9 January 2018.

```{r}
library(tidyverse)
table_mean <- man_data %>% 
  group_by(country) %>% 
  summarize(obs = length(management), 
            m_overall = mean(management), 
            m_monitor = mean(monitor), 
            m_target = mean(target), 
            m_incentives = mean(people)) %>% 
  arrange(desc(m_overall))

table_mean
```

You can see that `m_monitor` for the UK is recorded as `NA`, because there is a `NA` entry for the monitor variable. The `mean` function, by default, will not produce a mean value if any observations are missing. Doing so allows you to investigate if there is a data issue. Here, this missing observation isn’t really an issue for our analysis⁠—in the code above, we simply add the option `na.rm = TRUE` in the `mean` function to calculate the mean, ignoring the missing observation(s). 

```{r}
table_mean <- man_data %>% 
  group_by(country) %>% 
  summarize(obs = length(management), 
            m_overall = mean(management), 
            m_monitor = mean(monitor, na.rm = TRUE), 
            m_target = mean(target), 
            m_incentives = mean(people)) %>% 
  arrange(desc(m_overall))

table_mean
```

Let's make the table showing the ranks. We use the `mutate` function, which adds variables calculated from existing variables.

```{r}
table_rank <- table_mean %>% 
  mutate(r_overall = rank(desc(m_overall)), 
    r_monitor = rank(desc(m_monitor)), 
    r_target = rank(desc(m_target)), 
    r_incentives = rank(desc(m_incentives)))

# Select the country variable (Column 1) and the columns 
# with rank information (7 to 10)                        
table_rank[c(1, 7:10)]
```

Now we use the `ggplot` set of functions (part of the `tidyverse` package uploaded earlier) to create a bar chart using the `m_overall` value in `table_mean`. To present countries in order of their management score, we specified `x = reorder(country, m_overall, mean)` (using `x = country` would have ordered the countries alphabetically, which is R’s default option). To switch the horizontal and vertical axis (as in Figure 6.1), we used the `coord_flip` option.

```{r}
ggplot(table_mean, 
  aes(x = reorder(country, m_overall, mean), 
    y = m_overall)) +
  geom_bar(stat = "identity", position = "identity") + 
  xlab("") +
  ylab("Average management practice score") +
  coord_flip() +
  theme_bw()
```

If you want to switch the order of the bars, use `rev(table_mean$m_overall)` and `rev(table_mean$country)` to reverse the order of the values. 

[End of walk-through]


### R walk-through 6.2 Obtaining frequency counts and plotting overlapping histograms

To get frequency counts, use the `cut` function. This function will count the number of observations that fall within the intervals specified in the `breaks` option (here we specified intervals of 0.2). We store this information in the vector `temp_counts` and use the `table` function to display the table of frequencies.
  
```{r}  
temp_counts <- cut(man_data$management
  [man_data$country == "Chile"], breaks=seq(0, 5, 0.2))  

table(temp_counts)  
```  
  
To create the required chart, we will use `geom_histogram`, part of the `ggplot` set of functions. 

Let's first collect one pair of countries, Chile and the US. If you wanted to produce a histogram for the overall (`management`) rating, use the following code.

```{r}
g1 <- ggplot(subset(man_data, country == "Chile"),
             aes(management)) +
  geom_histogram(breaks = seq(0, 5, 0.2)) +
  xlab("Management score") +
  ylab("Frequency Count") 

print(g1)
```

*Tip:* Using `ggplot`, it is straightforward to add a second country to the chart. The way to learn is usually to search the Internet (here we searched for ‘r ggplot multiple histograms’).

To plot two countries on the same chart, we added the following options:
  
  * `..density..` gives a chart with a total area of 1, which ensures the histograms are plotted using the same scale (the result is a graph with an area of 1). For proportions, we need to scale by multiplying by the bin width (0.2 in this case).
* `fill = country` plots one histogram for each country
* `breaks = seq(0, 5, 0.2)` sets the breakpoints (intervals) at 0.2, starting from 0 and ending at 5
* `alpha = .5` makes the bars semi-transparent (so we can see both histograms at once)
* `position = "identity"` overlays the two histograms
* `scale_fill_discrete(name = "Country")` gives a legend title.

```{r}
g1 <- ggplot(subset(man_data, country %in% 
                      c("Chile", "United States")),
             aes(x = management, y = 0.2 * ..density..,
                 fill = country)) +
  geom_histogram(breaks = seq(0, 5, 0.2), alpha = .5,
                 position = "identity") +
  xlab("Management score") +
  ylab("Density") + 
  ggtitle("Histogram for management score") + 
  scale_fill_discrete(name = "Country") +
  theme_bw()

print(g1)
```

[End of walk-through]


### R walk-through 6.3 Creating box and whisker plots

We use exactly the same structure as for the overlapping histograms, this time plotting countries on the horizontal axis (`x = country`) and management scores on the vertical axis (`y = management`). A useful feature of `ggplot` is that using more or less the same structure, you can create a variety of graphs. In this example, we include a few more countries, as this can be done without overcrowding the figure. To change the look of our chart, we use the option `theme_solarized()`.

```{r}
library(ggthemes)

g2 <- ggplot(subset(man_data, country %in% 
                      c("Chile", "United States", "Brazil", "Germany", "UK")),
             aes(x = country, y = management)) +
  geom_boxplot() + 
  ylab("Management score") +
  ggtitle("Box and whisker plots for management score") + 
  theme_solarized()

print(g2)
```

[End of walk-through]


## Part 6.2 Do management practices differ between countries?

### R walk-through 6.4 Calculating confidence intervals and adding them to a chart

As in R walk-through 6.1, we use piping operators (`%>%`) from the `tidyverse` package. First, we take `man_data` and extract the countries we need (`filter`). Then, we group the data by country (`group_by`), calculate the required summary measures (`summarize`), and arrange the data according to the values of `mean_m` (`rev` sorts from highest to lowest). We save the final result in `table_stats`.

```{r}
table_stats <- man_data %>% 
  filter(country %in% c("Chile", "United States",
                        "Brazil", "Germany", "UK")) %>% 
  group_by(country) %>% 
  summarize(obs = length(management), 
            mean_m = mean(management), 
            sd_m = sd(management, na.rm = TRUE)) %>%
  arrange(rev(mean_m))

table_stats
```

To get the confidence intervals, we use the `t.test` function, which calculates them automatically (along with a lot of other information). The confidence interval is stored as `conf.int[1:2]`.

```{r}
# tUS contains a lot of information; $conf.int[1:2] is the 
# confidence interval.
tUS <- t.test(subset(man_data,
                     country == "United States", select = management))

tUS$conf.int[1:2]
```

```{r}
table_stats <- man_data %>% 
  filter(country %in% c("Chile", "United States",
                        "Brazil", "Germany", "UK")) %>% 
  group_by(country) %>% 
  summarize(obs = length(management), 
            mean_m = mean(management), 
            sd_m = sd(management, na.rm = TRUE), 
            m_err = 1.96 * sqrt(sd_m^2 / (obs - 1))) %>% 
  arrange(rev(mean_m))

table_stats
```

Now we can use this information to make a bar chart:
  
  ```{r}
ggplot(table_stats, aes(y = mean_m, x = country)) + 
  geom_bar(position = position_dodge(), 
           # Use black outlines and add thinner bar outlines
           stat = "identity", colour = "black", size = .3) +
  ylab("Mean management score") + xlab("") + 
  geom_errorbar(aes(ymin = mean_m - m_err, 
                    ymax = mean_m + m_err),
                # Thinner lines for confidence intervals
                size = .6, width = .5, position = position_dodge(.9)) +
  coord_cartesian(ylim = c(2, 4)) +
  theme_bw() +
  theme(axis.text.x = element_text(size = rel(1.5)),
        axis.text.y = element_text(size = rel(1.3))) 
```

[End of walk-through]

## Part 6.3 What factors affect the quality of management?

### R walk-through 6.5 Calculating and adding conditional summary statistics and confidence intervals to a chart

We will use many techniques encountered previously, but first we have to create a new variable that indicates whether a firm is larger or smaller (`size`). A firm with `lemp_firm` > 5.8 is considered larger. We use the `factor` function to do this.

```{r}
man_data$size <- factor(man_data$lemp_firm > 5.8,
                        labels = c("small", "large"))
```

We choose Canada, Brazil, and the United States. Again, we use the piping technique to make the table. In the `group_by` command, we group the variables by `size` and `ownership` (as we did in R walk-through 6.1).

```{r}
table_stats2 <- man_data %>% 
  filter(country %in% c("Canada",
                        "United States", "Brazil")) %>% 
  group_by(country, ownership, size) %>% 
  summarize(obs = length(management), 
            mean_m = mean(management, na.rm = TRUE), 
            sd_m = sd(management, na.rm = TRUE))

table_stats2
```

Now we use the variable `size` as a column variable, so that we can see the summary statistics in two blocks of columns (separately for larger and smaller firms). This is not a standard or straightforward procedure, but an Internet search (for ‘tidyverse spread multiple columns’) gives the following solution.

```{r}
table_stats2_mc <- table_stats2 %>% 
  gather(variable, value, -(country:size)) %>% 
  unite(temp, size, variable) %>% 
  spread(temp, value)

print(table_stats2_mc)
```

To understand the logic of this command, go through it step by step: first apply `gather` (which compiles the values of multiple columns (`country` and `size` in this case) into a single column), then `unite` (which pastes multiple columns into one), and then `spread` (takes two columns and spreads them into multiple columns). 

[End of walk-through]

