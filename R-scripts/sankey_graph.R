library(tidyverse)
library(networkD3)

data <- tibble::tribble(
  ~Name, ~Annual.Amount,  ~Category,
  "Net Revenue Receipts",         4900L,   "Income",
  "External Resources",        533L,   "Income",
  "Estimated Capital Receipts",        533L,   "Income",
  "Estimated Provincial Surplues",        800L,   "Income",
  "Privatization Proceeds", 96L, "Income",
  "Running of civil government",        550L, "Expenses",
  "Federal PSDP and net lending",         808L, "Expenses",
  "Interest payments",	3950L, "Expenses",
  "Provision for disaster/pay and payments", 200L, "Expenses",
  "Grants and transfers to Provinces",	1240L, "Expenses",
  "Defence Affairs and service",	1520L, "Expenses",

)


# Net Revenue Receipts	2,463,351
# External Resources	751,511
# Net Capital Receipts	606,303
# Estimated Provincial Surplues	297,173
# Privatization Proceeds	50,000
# 
# Current Exp. On Revenue Account	3,482,239
# Federal PSDP	700,000
# Dev. Expenditure outside PSDP	164,400
# Dev Loan & Grants to Provinces	104,639
# Bank Borrowing	282,940
# 











Nodes = tibble(
  Name = c(data$Name, "Budget") %>% unique()
) %>% as.data.frame()

df = data %>% filter(Category=="Income") %>%
  select(-Category) %>%
  rename(Source = Name) %>%
  mutate(Target = "Budget") %>%
  bind_rows(
    data %>%
      filter(Category=="Expenses") %>%
      select(-Category) %>%
      rename(Target = Name) %>%
      mutate(Source = "Budget")
  ) %>% mutate(
    IDSource = match(Source, Nodes$Name)-1,
    IDTarget = match(Target, Nodes$Name)-1
  ) %>% as.data.frame()
na.om
df |> glimpse()
sankeyNetwork(Links = df, Nodes = Nodes,
              Source = "IDSource", Target = "IDTarget",
              Value = "Annual.Amount", NodeID = "Name",
              sinksRight=FALSE, fontSize = 16)


library(webshot)
#webshot::install_phantomjs()
sankeyNetwork(Links = df, Nodes = Nodes,
              Source = "IDSource", Target = "IDTarget",
              Value = "Annual.Amount", NodeID = "Name",
              sinksRight=FALSE, fontSize = 16) %>%
  saveNetwork("sn.html")

webshot("sn.html", "sankeyNetwork.png")



library(ggsankey)

d <- data.frame(Question  = c('How many pizzas'
                              ,'How many pizzas'
                              ,'How many pizzas')
                , Answer    = c('1 Pizza','2 Pizzas','3 Pizzas')
                , Responses = c(200,300,400))
df1 <- d %>%
  make_long(Question,Answer,Responses)



pl <- ggplot(df1, aes(x = x
                     , next_x = next_x
                     , node = node
                     , next_node = next_node
                     , fill = factor(node)
                     , label = node)
)
pl <- pl +geom_sankey(flow.alpha = 0.5
                      , node.color = "black"
                      ,show.legend = FALSE)
pl <- pl +geom_sankey_label(size = 3, color = "black", fill= "white", hjust = -0.5)
pl <- pl +  theme_bw()
pl <- pl + theme(legend.position = "none")
pl <- pl +  theme(axis.title = element_blank()
                  , axis.text.y = element_blank()
                  , axis.ticks = element_blank()  
                  , panel.grid = element_blank())
pl <- pl + scale_fill_viridis_d(option = "inferno")
pl <- pl + labs(title = "Sankey diagram using ggplot")
pl <- pl + labs(subtitle = "Showing the responses to a multiple choice question")
pl <- pl + labs(caption = "@techanswers88")
pl <- pl + labs(fill = 'Nodes')
pl

