library(ggplot2)
library(dplyr)

datasets <- read.csv("datasets.csv")
datasets$n_eez <- datasets$n_all - datasets$n_abnj

ggplot(datasets) +
  geom_bar(aes(x = reorder(dataset_id, n_eez), y = -n_eez), stat = "identity", fill = "#cc3300", width = 1) +
  geom_bar(aes(x = reorder(dataset_id, n_eez), y = n_abnj), stat = "identity", fill = "#0099ff", width = 1) +
  coord_flip() +
  theme(
    axis.title.y = element_blank(),
    axis.title.x = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank()
  )

ggsave("datasets.png", width = 10, height = 10)
