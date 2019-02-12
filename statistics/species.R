library(ggplot2)
library(dplyr)
library(gridExtra)

species <- read.csv("species.csv")
species$n_eez <- species$n_all - species$n_abnj

# statistics

species %>% summarize(
  eez = sum(n_eez > 0),
  abnj = sum(n_abnj > 0),
  both = sum(n_abnj > 0 & n_eez > 0),
  total = n()
)
