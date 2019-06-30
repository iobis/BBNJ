library(dplyr)
library(jsonlite)

data <- fromJSON("https://api.obis.org/dataset?areaid=1")$results

resultlist <- list()

for (i in 1:nrow(data)) {
  contacts <- data$contacts[[i]]
  contacts$dataset_id <- data$id[i]
  contacts$dataset_url <- data$url[i]
  contacts$dataset_title <- data$title[i]
  contacts$dataset_records <- data$records[i]
  resultlist[[i]] <- contacts
}

contacts <- bind_rows(resultlist)

oelist <- list()
for (oeid in unique(contacts$organization_oceanexpert_id)) {
  if (!is.na(oeid)) {
    url <- sprintf("https://www.oceanexpert.net/api/v1/institution/%s.json", oeid)
    message(url)
    type <- fromJSON(url)$institute$instTypeId
    oelist[[oeid]] <- type
  }
}

contacts$organization_oceanexpert_typeid <- NA
for (i in 1:nrow(contacts)) {
  oeid <- contacts$organization_oceanexpert_id[i]
  oetype <- oelist[[oeid]]
  if (!is.null(oetype)) {
    contacts$organization_oceanexpert_typeid[i] <- oetype
  }
}

types <- data.frame(
  typeid = c(1, 2, 3, 4, 5, 6, 7),
  typename = c("Academic", "Research", "Government", "NGO", "Private non-profit", "Private commercial", "International / Intergovernmental")
)

contacts <- contacts %>%
  left_join(types, by = c("organization_oceanexpert_typeid" = "typeid")) %>%
  select(dataset_id, dataset_title, dataset_url, dataset_records, organization, organization_oceanexpert_id, organization_oceanexpert_typeid, organization_oceanexpert_typename = typename, type_display, givenname, surname)

write.csv(contacts, file= "contacts.csv", row.names = FALSE, na = "")

### to be matched

tomatch <- contacts %>% filter(is.na(organization_oceanexpert_id) & !is.na(organization)) %>% distinct(dataset_id, organization)

write.csv(tomatch, file= "tomatch.csv", row.names = FALSE, na = "")


