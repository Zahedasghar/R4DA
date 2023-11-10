
## # Install the packages that we need
## install.packages("tidyverse")
## install.packages("AustralianPoliticians")

# Load the packages that we need to use this time
library(tidyverse)
library(AustralianPoliticians)


# Make a table of the counts of genders of the prime ministers
get_auspol("all") |> # Imports data from GitHub
  as_tibble() |>
  filter(wasPrimeMinister == 1) |>
  count(gender)

get_auspol("all") |> # Imports data from GitHub
  head()


australian_politicians <-
  get_auspol("all")

head(australian_politicians)

australian_politicians |>
  select(firstName)

australian_politicians$firstName |>
  head()

australian_politicians |>
  select(firstName) |>
  pull() |>
  head()

australian_politicians |>
  select(-firstName)

australian_politicians |>
  select(starts_with("birth"))

australian_politicians <-
  australian_politicians |>
  select(
    uniqueID,
    surname,
    firstName,
    gender,
    birthDate,
    birthYear,
    deathDate,
    member,
    senator,
    wasPrimeMinister
  )

australian_politicians

australian_politicians |>
  filter(wasPrimeMinister == 1)

australian_politicians |>
  filter(wasPrimeMinister == 1 & firstName == "Joseph")

australian_politicians |>
  filter(wasPrimeMinister == 1, firstName == "Joseph")

australian_politicians |>
  filter(firstName == "Myles" | firstName == "Ruth")

australian_politicians |>
  filter(firstName == "Ruth" | firstName == "Myles") |>
  select(firstName, surname)

australian_politicians |>
  filter(row_number() == 853)

australian_politicians |>
  slice(853)

australian_politicians |>
  slice(-1)

australian_politicians |>
  slice(1:3)

australian_politicians |>
  slice(1:2, 1:n())

australian_politicians |>
  arrange(birthYear)

australian_politicians |>
  arrange(desc(birthYear))

australian_politicians |>
  arrange(-birthYear)

australian_politicians |>
  arrange(firstName, birthYear)

australian_politicians |>
  arrange(birthYear) |>
  arrange(firstName)

australian_politicians |>
  arrange(birthYear, firstName)

australian_politicians |>
  arrange(across(c(firstName, birthYear)))

australian_politicians |>
  arrange(across(starts_with("birth")))

australian_politicians <-
  australian_politicians |>
  mutate(was_both = if_else(member == 1 & senator == 1, 1, 0))

australian_politicians |>
  select(member, senator, was_both)

library(lubridate)

australian_politicians <-
  australian_politicians |>
  mutate(age = 2022 - year(birthDate))

australian_politicians |>
  select(uniqueID, age)

australian_politicians |>
  select(uniqueID, age) |>
  mutate(log_age = log(age))

australian_politicians |>
  select(uniqueID, age) |>
  mutate(lead_age = lead(age))

australian_politicians |>
  select(uniqueID, age) |>
  mutate(lag_age = lag(age))

australian_politicians |>
  select(uniqueID, age) |>
  drop_na(age) |>
  mutate(cumulative_age = cumsum(age))

australian_politicians |>
  mutate(across(c(firstName, surname), str_count)) |>
  select(uniqueID, firstName, surname)

library(lubridate)

australian_politicians |>
  mutate(
    year_of_birth = year(birthDate),
    decade_of_birth =
      case_when(
        year_of_birth <= 1929 ~ "pre-1930",
        year_of_birth <= 1939 ~ "1930s",
        year_of_birth <= 1949 ~ "1940s",
        year_of_birth <= 1959 ~ "1950s",
        year_of_birth <= 1969 ~ "1960s",
        year_of_birth <= 1979 ~ "1970s",
        year_of_birth <= 1989 ~ "1980s",
        year_of_birth <= 1999 ~ "1990s",
        TRUE ~ "Unknown or error"
      )
  ) |>
  select(uniqueID, year_of_birth, decade_of_birth)

australian_politicians |>
  summarise(
    youngest = min(age, na.rm = TRUE),
    oldest = max(age, na.rm = TRUE),
    average = mean(age, na.rm = TRUE)
  )

australian_politicians |>
  summarize(
    youngest = min(age, na.rm = TRUE),
    oldest = max(age, na.rm = TRUE),
    average = mean(age, na.rm = TRUE)
  )

australian_politicians |>
  summarise(
    youngest = min(age, na.rm = TRUE),
    oldest = max(age, na.rm = TRUE),
    average = mean(age, na.rm = TRUE),
    .by = gender
  )

australian_politicians |>
  mutate(days_lived = deathDate - birthDate) |>
  drop_na(days_lived) |>
  summarise(
    min_days = min(days_lived),
    mean_days = mean(days_lived) |> round(),
    max_days = max(days_lived),
    .by = gender
  )

australian_politicians |>
  mutate(days_lived = deathDate - birthDate) |>
  drop_na(days_lived) |>
  summarise(
    min_days = min(days_lived),
    mean_days = mean(days_lived) |> round(),
    max_days = max(days_lived),
    .by = c(gender, member)
  )

australian_politicians |>
  count(gender)

australian_politicians |>
  count(gender) |>
  mutate(proportion = n / (sum(n)))

australian_politicians |>
  summarise(n = n(),
            .by = gender)

australian_politicians |>
  add_count(gender) |>
  select(uniqueID, gender, n)

a_number <- 8
class(a_number)

a_letter <- "a"
class(a_letter)

a_number <- 8
a_number
class(a_number)

a_number <- as.character(a_number)
a_number
class(a_number)

a_number <- as.factor(a_number)
a_number
class(a_number)

age_groups <- factor(
  c("18-29", "30-44", "45-60", "60+")
)
age_groups
class(age_groups)
levels(age_groups)

looks_like_a_date_but_is_not <- "2022-01-01"
looks_like_a_date_but_is_not
class(looks_like_a_date_but_is_not)
is_a_date <- as.Date(looks_like_a_date_but_is_not)
is_a_date
class(is_a_date)
is_a_date + 3

## install.packages("AER")

library(AER)
data("ResumeNames", package = "AER")

ResumeNames |>
  head()
class(ResumeNames)
colnames(ResumeNames)

class(ResumeNames$name)
class(ResumeNames$jobs)

class(ResumeNames$name)
class(ResumeNames$gender)
class(ResumeNames$ethnicity)

ResumeNames <- ResumeNames |>
  mutate(across(c(name, gender, ethnicity), as.character)) |>
  head()

class(ResumeNames$name)
class(ResumeNames$gender)
class(ResumeNames$ethnicity)

set.seed(853)

number_of_observations <- 5

simulated_data <-
  data.frame(
    person = c(1:number_of_observations),
    std_normal_observations = rnorm(
      n = number_of_observations,
      mean = 0,
      sd = 1
    )
  )

simulated_data

simulated_data <-
  simulated_data |>
  cbind() |>
  data.frame(
    uniform_observations =
      runif(n = number_of_observations, min = 0, max = 10),
    poisson_observations =
      rpois(n = number_of_observations, lambda = 100),
    binomial_observations =
      rbinom(n = number_of_observations, size = 2, prob = 0.5)
  )

simulated_data

simulated_data <-
  data.frame(
    favorite_color = sample(
      x = c("blue", "white"),
      size = number_of_observations,
      replace = TRUE
    )
  ) |>
  cbind(simulated_data)

simulated_data

print_names <- function(some_names) {
  print(some_names)
}

print_names(c("rohan", "monica"))

print_names <- function(some_names = c("edward", "hugo")) {
  print(some_names)
}

print_names()

simulated_data
apply(X = simulated_data, MARGIN = 2, FUN = unique)

## library(tidyverse)
## 
## oecd_gdp <-
##   read_csv("https://stats.oecd.org/sdmx-json/data/DP_LIVE/.QGDP.../OECD?contentType=csv&detail=code&separator=comma&csv-lang=en")
## 
## write_csv(oecd_gdp, "inputs/data/oecd_gdp.csv")

library(tidyverse)

oecd_gdp <-
  read_csv(
    "inputs/data/oecd_gdp.csv",
    show_col_types = FALSE
  )

head(oecd_gdp)

oecd_gdp_2021_q3 <-
  oecd_gdp |>
  filter(
    TIME == "2021-Q3",
    SUBJECT == "TOT",
    LOCATION %in% c(
      "AUS",
      "CAN",
      "CHL",
      "DEU",
      "GBR",
      "IDN",
      "ESP",
      "NZL",
      "USA",
      "ZAF"
    ),
    MEASURE == "PC_CHGPY"
  ) |>
  mutate(
    european = if_else(
      LOCATION %in% c("DEU", "GBR", "ESP"),
      "European",
      "Not european"
    ),
    hemisphere = if_else(
      LOCATION %in% c("CAN", "DEU", "GBR", "ESP", "USA"),
      "Northern Hemisphere",
      "Southern Hemisphere"
    ),
  )

oecd_gdp_2021_q3 |>
  ggplot(mapping = aes(x = LOCATION, y = Value))

oecd_gdp_2021_q3 |>
  ggplot(mapping = aes(x = LOCATION, y = Value)) +
  geom_bar(stat = "identity")

oecd_gdp_2021_q3 |>
  ggplot(mapping = aes(x = LOCATION, y = Value, fill = european)) +
  geom_bar(stat = "identity")

oecd_gdp_2021_q3 |>
  ggplot(mapping = aes(x = LOCATION, y = Value, fill = european)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Quarterly change in GDP for ten OECD countries in 2021Q3",
    x = "Countries",
    y = "Change (%)",
    fill = "Is European?"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1")

oecd_gdp_2021_q3 |>
  ggplot(mapping = aes(x = LOCATION, y = Value, fill = european)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Quarterly change in GDP for ten OECD countries in 2021Q3",
    x = "Countries",
    y = "Change (%)",
    fill = "Is European?"
  ) +
  theme_classic() +
  scale_fill_brewer(palette = "Set1") +
  facet_wrap(
    ~hemisphere,
    scales = "free_x"
  )

tibble(
  person = c(
    "Rohan",
    "Rohan",
    "Monica",
    "Monica",
    "Edward",
    "Edward",
    "Hugo",
    "Hugo"
  ),
  variable = c("Age", "Hair", "Age", "Hair", "Age", "Hair", "Age", "Hair"),
  value = c("35", "Black", "35", "Blonde", "3", "Brown", "1", "Blonde")
) |>
  knitr::kable(
    col.names = c("Person", "Variable", "Value"),
    digits = 1
  )

tibble(
  person = c("Rohan", "Monica", "Edward", "Hugo"),
  age = c(35, 35, 3, 1),
  hair = c("Black", "Blonde", "Brown", "Blonde")
) |>
  knitr::kable(
    col.names = c("Person", "Age", "Hair"),
    digits = 1
  )

people_as_dataframe <-
  data.frame(
    names = c("rohan", "monica"),
    website = c("rohanalexander.com", "monicaalexander.com"),
    fav_color = c("blue", "white")
  )
class(people_as_dataframe)
people_as_dataframe

people_as_tibble <-
  tibble(
    names = c("rohan", "monica"),
    website = c("rohanalexander.com", "monicaalexander.com"),
    fav_color = c("blue", "white")
  )
people_as_tibble
class(people_as_tibble)

main_dataset <-
  tibble(
    names = c("rohan", "monica", "edward", "hugo"),
    status = c("adult", "adult", "child", "infant")
  )
main_dataset

supplementary_dataset <-
  tibble(
    names = c("rohan", "monica", "edward", "hugo"),
    favorite_food = c("pasta", "salmon", "pizza", "milk")
  )
supplementary_dataset

main_dataset <-
  main_dataset |>
  left_join(supplementary_dataset, by = "names")

main_dataset

anscombe

anscombe_long <-
  anscombe |>
  pivot_longer(
    everything(),
    names_to = c(".value", "set"),
    names_pattern = "(.)(.)"
  )

anscombe_long

pivot_example_data <-
  tibble(
    year = c(2019, 2020, 2021),
    mark = c("first", "second", "first"),
    lauren = c("second", "first", "second")
  )

pivot_example_data

data_pivoted_longer <-
  pivot_example_data |>
  pivot_longer(
    cols = c("mark", "lauren"),
    names_to = "person",
    values_to = "position"
  )

head(data_pivoted_longer)

data_pivoted_wider <-
  data_pivoted_longer |>
  pivot_wider(
    names_from = "person",
    values_from = "position"
  )

head(data_pivoted_wider)

dataset_of_strings <-
  tibble(
    names = c(
      "rohan alexander",
      "monica alexander",
      "edward alexander",
      "hugo alexander"
    )
  )

dataset_of_strings |>
  mutate(
    is_rohan = str_detect(names, "rohan"),
    make_howlett = str_replace(names, "alexander", "howlett"),
    remove_rohan = str_remove(names, "rohan")
  )

dataset_of_strings |>
  mutate(
    length_is = str_length(string = names),
    name_and_length = str_c(names, length_is, sep = " - ")
  )

dataset_of_strings |>
  separate(
    col = names,
    into = c("first", "last"),
    sep = " ",
    remove = FALSE
  )

set.seed(853)

days_data <-
  tibble(
    days =
      c(
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday"
      ),
    some_value = c(sample.int(100, 7))
  )

days_data <-
  days_data |>
  mutate(
    days_as_factor = factor(days),
    days_as_factor = fct_relevel(
      days,
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday"
    )
  )

days_data |>
  ggplot(aes(x = days, y = some_value)) +
  geom_point()

days_data |>
  ggplot(aes(x = days_as_factor, y = some_value)) +
  geom_point()
