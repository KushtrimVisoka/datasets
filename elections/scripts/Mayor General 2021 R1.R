if (!require(librarian)) {
  install.packages("librarian")
  require(librarian)
}

librarian::shelf(pdftools, tidyverse, readr, readxl, stringi, openxlsx)

load("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Mayor Elections/2021/regular/output/results_by_candidate_may_r1_2021.RData")

NewMuni <-
  read_excel("/Volumes/Kushtrim's HDD/Kosovo Elections Portal/Mayor Elections/2013/regular/input/New Municipal ID.xlsx")

MayorLocElec21 <- MayorLocElec21 %>%
  merge(NewMuni) %>%
  mutate(`PSID` = paste(
    `New Municipal ID`,
    `Polling Center`,
    substr(`Polling Station`, 7, 9),
    sep = "-"
  )) %>%
  mutate(`PCID` = paste(`New Municipal ID`, `Polling Center`, sep = "-"))

ByPSValid <- MayorLocElec21 %>%
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
data <- MayorLocElec21 %>% 
  select(id = `Municipal ID`, Municipality, `Polling Center`, `Polling Station`, Candidate, Party_ID = PartyID,
         Party, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/candidate/ps.RData")


# BY PC

data <- MayorLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, `Polling Center`, Candidate, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/candidate/pc.RData")

# BY MUNICIPALITY

data <- MayorLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, Candidate, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/candidate/municipality.RData")

# BY NATIONAL

data <- MayorLocElec21 %>% 
  group_by(Candidate, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(Votes))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/candidate/national.RData")


# Generate data by party

# BY PS

data <- MayorLocElec21 %>% 
  select(id = `Municipal ID`, Municipality, `Polling Center`, `Polling Station`, Party_ID = PartyID,
         Party, Votes)

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/party/ps.RData")

# BY PC

data <- MayorLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, `Polling Center`, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/party/pc.RData")

# BY Municipality

data <- MayorLocElec21 %>% 
  group_by(id = `Municipal ID`, Municipality, Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/party/municipality.RData")

# BY NATIONAL

data <- MayorLocElec21 %>% 
  group_by(Party_ID = PartyID,
           Party) %>% 
  summarise(Votes = sum(as.numeric(Votes)))

save(data, file = "/Users/kushtrimvisoka/Documents/GitHub/datasets/elections/mayor/2021/party/national.RData")


