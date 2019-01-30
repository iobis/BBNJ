library(ggplot2)
library(dplyr)

datasets <- read.csv("datasets.csv")
datasets$n_eez <- datasets$n_all - datasets$n_abnj

ggplot(datasets) +
  geom_bar(aes(x = n_eez, y = n_eez), stat = "identity") +
  coord_flip() +
  theme(
    axis.title.x=element_blank(),
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank()
  )