library(tidyverse)
library(readr)
cd <- read_csv("data/cobb_douglas.csv")

cd |> glimpse()

cd
library(janitor)
cd |> clean_names() -> cd
colnames(cd)
lookup <- c(
  qelec = "quantity_of_electiricy",
  qfwc = "quantity_of_firewood_cock_coal",
  qgas = "quantity_of_natural_gas",
  qK = "quantity_of_capital",
  qL = "quantity_of_labor",
  qpet = "quantity_of_petroleum_products",
  qQ = "quantity_of_output",
  pelec = "price_of_electiricy",
  pfwc = "price_of_firewood_cock_coal" ,
  pgas = "price_of_natural_gas",
  pK = "price_of_capital" ,
  pL = "price_of_labor",
  ppet = "price_of_petroleum_products" ,
  pQ = "price_of_output"
)
rename(cd, all_of(lookup)) -> cd

## Or use
#rename(cd, #....), paste all inside lookup here

colnames(cd)

## Construct Energy price index by adding all prices (electricity, petroleum product)
## firewood, gas 

cd <- cd |> mutate(pindex=(pelec+pfwc+pgas+ppet)/4)

cd |> glimpse()

## Construct quantity index which is price multiplied by quantity of each category 
## divided by sum of quantities of all categories

cd <- cd |> mutate(qindex=((pelec*qelec+pgas*qgas+ppet*qpet+pfwc*qfwc)/(qelec+qfwc+qgas+qpet)))

cd |> glimpse()                   

## Calculate cost which is price of all three factors (L, K, E) multiplied by their quantities

cd <- cd |> mutate(cost=(qL*pL+qK*pK+pindex*qindex))


cd_mod <- lm(log(qQ) ~ log(qL) + log(qK) + log(qindex), data = cd)
library(fixest)
library(car)
library(broom)
library(help=broom)
tidy(cd_mod)
linearHypothesis(cd_mod, (log(qL)+log(qK)+log(qindex))=1)


# Load the car package
library(car)

# Define the hypothesis matrix
H <- matrix(c(1, 1, 1,-1), nrow = 1)

# Test the hypothesis
linearHypothesis(cd_mod, H)

## CD cost function

cd_cost <- lm(log(cost/pindex) ~ log(qL/pindex) + log(qK/pindex) + log(qQ), data = cd)

tidy(cd_cost)
linearHypothesis(cd_cost,H)


cd_cost <- lm(log(cost/pindex) ~ log(qL/pindex) + log(qK/pindex) + log(qQ), data = cd)


