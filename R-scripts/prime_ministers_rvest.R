library(tidyverse)
library(rvest)
library(xml2)

link <- "https://en.wikipedia.org/wiki/List_of_prime_ministers_of_Pakistan"
# Read the webpage using the read_html() function

page <- read_html(link)

drivers_F1 <- html_element(page, "table.sortable") %>%
  html_table()

drivers_F1 |> View()
# Print the extracted data
print(data)

table <- html_table(html_nodes(webpage, "table")[[1]])




# Install the rvest package if you haven't already
#install.packages("rvest")

# Load the rvest package
library(rvest)

# Specify the URL of the webpage
url <- "https://www.investorslounge.com/stock-market/historical-prices"

# Read the webpage
webpage <- read_html(url)

# Find the table using CSS selector
table <- html_nodes(webpage, "table#historicalTable")

# Check if the table was found
if (length(table) > 0) {
  # Extract the table
  table <- html_table(table[[1]])
  # Print the table
  print(table)
} else {
  cat("No table found on the webpage.")
}

table
