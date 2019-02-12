library(ggplot2)
library(dplyr)
library(gridExtra)

datasets <- read.csv("datasets.csv")
datasets$n_eez <- datasets$n_all - datasets$n_abnj

# statistics

datasets %>% summarize(
  eez = sum(n_eez > 0),
  abnj = sum(n_abnj > 0),
  both = sum(n_abnj > 0 & n_eez > 0),
  total = n()
)

# plot

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

# plot 2

datasets2 <- datasets %>% arrange(-n_eez) %>% mutate(n_eez = na_if(n_eez, 0), n_abnj = na_if(n_abnj, 0))

p1 <- ggplot(datasets2) +
  geom_point(aes(x = seq(1:nrow(datasets2)), y = n_eez), colour = "#33ccff") +
  coord_flip() +
  scale_x_continuous(trans = "reverse") +
  scale_y_continuous(trans = "reverse") +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank()
  ) + ggtitle("EEZ") + ylab("records") + geom_hline(yintercept = 100000, linetype="dotted")
p2 <- ggplot(datasets2) +
  geom_point(aes(x = seq(1:nrow(datasets2)), y = n_abnj), colour = "#0099cc") +
  coord_flip() +
  scale_x_continuous(trans = "reverse") +
  theme(
    axis.text.y = element_blank(),
    axis.title.y = element_blank(),
    axis.ticks.y = element_blank()
  ) + ggtitle("ABNJ") + ylab("records") + geom_hline(yintercept = 100000, linetype="dotted")
grid.arrange(p1, p2, nrow = 1)

