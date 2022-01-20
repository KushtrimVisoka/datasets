if (!require(librarian)) {
  install.packages("librarian")
  require(librarian)
}

librarian::shelf(pdftools, tidyverse, readr, readxl, stringi, openxlsx)

load("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Mayor Elections/2021/runoff/output/results_by_candidate_may_r2_2021.RData")

NewMuni <-
  read_excel("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Mayor Elections/2013/regular/input/New Municipal ID 2017.xlsx")

MayorLocElec21R2 <- MayorLocElec21R2 %>%
  mutate(Votes = as.numeric(Votes)) %>%
  merge(NewMuni) %>%
  rename(Longitude = School_X,
         Latitude = School_Y) %>%
  mutate(`PSID` = paste(
    `New Municipal ID`,
    `Polling Center`,
    substr(`Polling Station`, 7, 9),
    sep = "-"
  )) %>%
  mutate(`PCID` = paste(`New Municipal ID`, `Polling Center`, sep = "-"))

ByPSValid <- MayorLocElec21R2 %>%
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



# Generate data by candidate

# BY PS
data <- MayorLocElec21R2 %>% 
  select(id = `Municipal ID`, Municipality = NewMunicipality, `Polling Center`, `Polling Station`, Candidate, Party_ID = PartyID,
         Party, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/candidate/ps.RData")

# BY PC

data <- MayorLocElec21R2 %>% 
  group_by(id = `Municipal ID`, Municipality = NewMunicipality, `Polling Center`, Candidate, Party_ID = PartyID,
           Party,) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/candidate/pc.RData")

# BY Municipality.x

data <- MayorLocElec21R2 %>% 
  group_by(id = `Municipal ID`, Municipality = NewMunicipality, Candidate, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/candidate/Municipality.x.RData")

# BY NATIONAL

data <- MayorLocElec21R2 %>% 
  group_by(Candidate, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/candidate/national.RData")


# Generate data by party

# BY PS

data <- MayorLocElec21R2 %>% 
  select(id = `Municipal ID`, Municipality, `Polling Center`, `Polling Station`, Party_ID = PartyID,
         Party, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/party/ps.RData")

# BY PC

data <- MayorLocElec21R2 %>% 
  group_by(id = `Municipal ID`, Municipality, `Polling Center`, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/party/pc.RData")

# BY Municipality.x

data <- MayorLocElec21R2 %>% 
  group_by(id = `Municipal ID`, Municipality, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/party/Municipality.x.RData")

# BY NATIONAL

data <- MayorLocElec21R2 %>% 
  group_by(Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor2/2021/party/national.RData")


