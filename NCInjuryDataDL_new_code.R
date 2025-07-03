# required packages: tidyverse

  # if not already installed:
#install.packages("tidyverse")

library(tidyverse)

#####

# read in data file
raw_data <- read_csv("C:\\Users\\hamil\\OneDrive\\Desktop\\WFUThesis\\data\\NCInjuryDataDL.csv")

#####

# rename header so that there's underscores instead of spaces; names are otherwise the same
  # all lowercase
  # spaces replaced w underscores
colnames(raw_data) <- c(
  "ind_date_anchor", #year
  "ind_date_span", # entire column says 'year'
  "ind_id", # contains visit codes
  "ind_obs_note", # extra notes for visits
  "ind_place", # county
  "ind_place_type", # entire column just says "county"
  "ind_rate_word", # map info that says "LOWER" or etc
  "ind_selectname", # i.e. "Death: Overdose Death"
  "is_projected_word", # percentages?
  "ind_rate_pct_change", 
  "ind_denom", # population in that county for that year?
  "ind_num", 
  "ind_rate" # ind rate ind denom
)

#####

# small tweaks to the data for readability
  # rename raw_data as data
data_long <- raw_data %>%
  select( # remove extra rows that do not give additional information (5)
    -ind_date_span, # entire column says "year"
    -ind_place_type, # entire column says "county"
    -ind_rate_word, # says map classifiers like "LOWER" or "MIDDLE"
    -is_projected_word, # projected percentages of something?
    -ind_rate_pct_change, 
    
    # keeping ind_id seems to prevent the rows from properly aggregating?
    -ind_id
  ) %>%
  mutate( # change entries in years to include only the year/last 4 digits
    ind_date_anchor = str_sub(ind_date_anchor, -4)
  )

# if we want to skip doing any tweaks at all:
#data_long <- raw_data

# data is currently in long form

#####

# pivot_wider(): go from long -> wide
data_wide <- data_long %>%
  pivot_wider(
    names_from = ind_selectname, 
    values_from = c(ind_num, ind_denom, ind_rate)
    )

# export the new .csv file back
write.csv(data_wide, file = "NCInjuryDataDL_new.csv", row.names = FALSE)

#####

# [can delete] list of all ind_id 'codes': (7)
# "DEATH_ANY_MED_DRUG"
# "DEATH_ILLICITOPIOID_PCT"
# "CSRS_BUPE_PATIENTS" 
# "CSRS_OPIOID_PATIENTS"
# "DMH_OUD_TREATMENT"  
# "DSS_SU_FOSTERCASE" 
# "ED_SYND_MEDDRUG_OD"  

# [can delete] list of all ind_selectname codes: (7)
# Death: Overdose Death
# Death: Illicit Opioid Overdose
# CSRS: Patients Receiving Buprenorphine
# CSRS: Patients Receiving Opioids
# DMH: Treatment Services
# DSS: Foster Care due to Parental SU
# ED Visits: Overdose ED Visit

