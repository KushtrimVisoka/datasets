if (!require(librarian)) {
  install.packages("librarian")
  require(librarian)
}

librarian::shelf(pdftools, tidyverse, readr, readxl, stringi, openxlsx)

load("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Local Assembly Elections/2021/output/results_by_cand_loc_2021.RData")
load("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Local Assembly Elections/2021/output/results_by_party_loc_2021.RData")

NewMuni <-
  read_excel("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Local Assembly Elections/2017/input/New Municipal ID 2017.xlsx")

CandLocElec21 <- CandLocElec21 %>%
  merge(NewMuni) %>%
  mutate(Votes = as.numeric(Votes)) %>%
  rename(Longitude = School_X, Latitude = School_Y) %>%
  rename(id = UNIQID) %>%
  mutate(PSID = paste(
    `New Municipal ID`,
    `Polling Center`,
    substr(`Polling Station`, 7, 9),
    sep = "-"
  )) %>%
  mutate(PCID = paste(`New Municipal ID`, `Polling Center`, sep = "-"))

PartyLocElec2021 <- PartyLocElec2021 %>%
  merge(NewMuni) %>%
  mutate(Votes = as.numeric(Votes)) %>%
  rename(Longitude = School_X, Latitude = School_Y) %>%
  mutate(PSID = paste(
    `New Municipal ID`,
    `Polling Center`,
    substr(`Polling Station`, 7, 9),
    sep = "-"
  )) %>%
  mutate(PCID = paste(`New Municipal ID`, `Polling Center`, sep = "-"))

ByPSValid <- PartyLocElec2021 %>%
  group_by(`Polling Station`, `New Municipal ID`, `Municipal ID`) %>%
  summarise(`Valid Ballots` = sum(Votes)) %>%
  mutate(`PSID` = paste(
    `New Municipal ID`,
    substr(`Polling Station`, 0, 5),
    substr(`Polling Station`, 7, 9),
    sep = "-"
  )) %>%
  mutate(
    `PCID` = paste(`New Municipal ID`, substr(`Polling Station`, 0, 5), sep = "-"),
    `Polling Center` = substr(`Polling Station`, 0, 5)
  )

# BY PS
data <- CandLocElec21 %>% 
  select(id = `Municipal ID`, Municipality, `Polling Center`, `Polling Station`, Candidate, Gender, Party_ID = PartyID,
         Party, Acronym, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/candidate/ps.RData")

# BY PC

data <- CandLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, `Polling Center`, Candidate, Gender, Party_ID = PartyID,
           Party, Acronym) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/candidate/pc.RData")

# BY MUNICIPALITY

data <- CandLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, Candidate, Gender, Party_ID = PartyID,
           Party, Acronym) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/candidate/municipality.RData")

# BY NATIONAL

data <- CandLocElec21 %>% 
  group_by(Candidate, Gender, Party_ID = PartyID,
           Party, Acronym) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/candidate/national.RData")


# Generate data by party

# BY PS

data <- PartyLocElec2021 %>% 
  select(id = `Municipal ID`, Municipality, `Polling Center`, `Polling Station`, Party_ID = PartyID,
         Party, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/party/ps.RData")

# BY PC

data <- PartyLocElec2021 %>% 
  group_by(id = `Municipal ID`, Municipality, `Polling Center`, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/party/pc.RData")

# BY Municipality

data <- PartyLocElec2021 %>% 
  group_by(id = `Municipal ID`, Municipality, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/party/municipality.RData")

# BY NATIONAL

data <- PartyLocElec2021 %>% 
  group_by(Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/local/2021/party/national.RData")
