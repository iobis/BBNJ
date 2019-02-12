library(dplyr)
library(jsonlite)

data <- fromJSON("https://api.obis.org/dataset?areaid=1")$results

datasetlist <- list()
for (i in 1:nrow(data)) {
  i_names <- data[i,]$institutes[[1]]$name
  c_names <- data[i,]$contacts[[1]]$organization
  all_names <- unique(na.omit(c(i_names, c_names)))
  datasetlist[[i]] <- data.frame(id = data[i,]$id, title = data[i,]$title, records = data[i,]$records, institute = if (is.null(all_names)) NA else all_names, stringsAsFactors = FALSE)
}
datasets <- bind_rows(datasetlist) %>% mutate(institute = trimws(institute))

# OE types

types <- read.table("types.txt", sep = "\t", stringsAsFactors = FALSE, header = TRUE)

oemap <- bind_rows(lapply(data$institutes, function(x) {
  return(data.frame(oceanexpert_id = x$oceanexpert_id, name = trimws(x$name), stringsAsFactors = FALSE))
})) %>% filter(!is.na(oceanexpert_id)) %>% distinct() %>% arrange(oceanexpert_id)

oemap$typeid <- NA

for (i in 1:nrow(oemap)) {
  url <- sprintf("https://www.oceanexpert.net/api/v1/institution/%s.json", oemap$oceanexpert_id[i])
  message(url)
  inst <- fromJSON(url)$institute$instTypeId
  oemap$typeid[i] <- inst
}

oemap <- oemap %>% left_join(types, by = c("typeid" = "id"))

datasets2 <- datasets %>% left_join(oemap, by = c("institute" = "name"))

write.csv(datasets2, "datasets.csv", row.names = FALSE)
