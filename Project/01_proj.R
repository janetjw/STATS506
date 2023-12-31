setwd("~/Dropbox (University of Michigan)/STATS506/Project")

library(haven); library(stringr);library(base); library(data.table); library(dplyr); library(tidyselect); library(quantmod); library(tidyverse); library(tidyr)


## reading in data and converting to long format

hrs <- read_dta("randhrs1992_2018_reduced_edited_stat.dta")

longcols <- grep("wave", names(hrs))
longcols.name <- colnames(hrs[,longcols])
longcols.namenew <- 
  longcols.name %>% str_replace("wave", "")
longcols.namenew <- 
  longcols.namenew %>% str_replace("_", "")
longcols.namenew <- 
  longcols.namenew %>% str_replace_all("[:digit:]", "")
longcols.namenew <- unique(longcols.namenew)
longcols.namenew

hrs <- zap_labels(hrs)
hrs.long <-
  hrs %>%
  pivot_longer(
    cols = contains("wave"),
    names_to = c("wave", ".value"),
    names_pattern = "(\\w+\\d+)_(\\w+)"
  ) 
rm(hrs)
length(unique(hrs.long$rahhidpn))

# Deleting rows with N/A for basic variable -- age at beginning of interview. Keeping people ages 50+
hrs.long <- hrs.long[!is.na(hrs.long$ragey_b),]

#creating year variable and age before deleting people under 50
hrs.long$year <- hrs.long$wave
hrs.long$year <- recode_factor(hrs.long$year, wave1 = 1992, wave2 = 1994, wave3 = 1996, wave4 = 1998,
                               wave5 = 2000, wave6 = 2002, wave7 = 2004, wave8 = 2006,
                               wave9 = 2008, wave10 = 2010, wave11 = 2012, wave12 = 2014,
                               wave13 = 2016, wave14 = 2018)
hrs.long$year <- as.numeric(levels(hrs.long$year))[hrs.long$year]
hrs.long <- hrs.long %>%
  relocate(year)
#creating age variable that's more realistic -- not reported age
hrs.long$age <- hrs.long$year - hrs.long$rabyear
hrs.long <- hrs.long[which(hrs.long$age >= 50), ]
#deleting data from before 2000
hrs.long <- hrs.long[which(hrs.long$year >= 2000), ]
#using terminal year weights
hrs.long <- hrs.long %>% group_by(rahhidpn) %>%
  arrange(year) %>%
  mutate(personweight = first(weight2000))

#creating race, education, parent's ed
hrs.long$raracem <- as.character(hrs.long$raracem)
hrs.long$raracem[hrs.long$raracem=='3'] <- '4'
hrs.long$raracem[hrs.long$rahispan==1] <- '3'
hrs.long$raracem <- as.factor(hrs.long$raracem)
hrs.long$rlbrf <- as.factor(hrs.long$rlbrf)
length(unique(hrs.long$rahhidpn))
hrs.long <- hrs.long[-which(hrs.long$raracem == 4), ]
hrs.long$raracem <- droplevels(hrs.long$raracem)
length(unique(hrs.long$rahhidpn))
#EDUCATION VARIABLE: 4 levels 
hrs.long$myeduc <- NA
hrs.long$myeduc[hrs.long$raeduc == 1] <- 1
hrs.long$myeduc[hrs.long$raeduc == 2 | hrs.long$raeduc == 3] <- 2
hrs.long$myeduc[hrs.long$raeduc == 4] <- 3
hrs.long$myeduc[hrs.long$raeduc == 5] <- 4
hrs.long$myeduc <- as.factor(hrs.long$myeduc)

#creating parents education variable 
hrs.long$peduc <- ifelse(hrs.long$rafeduc >= hrs.long$rameduc | is.na(hrs.long$rameduc) == T, hrs.long$rafeduc, hrs.long$rameduc)
hrs.long$peduc <- ifelse(hrs.long$rameduc >= hrs.long$rafeduc | is.na(hrs.long$rafeduc) == T, hrs.long$rameduc, hrs.long$peduc)

hrs.long$peduc[which(is.na(hrs.long$peduc) == T)] <- 0

hrs.long$mypeduc[hrs.long$peduc < 12] <- 1
hrs.long$mypeduc[hrs.long$peduc == 12] <- 2
hrs.long$mypeduc[hrs.long$peduc > 12 & hrs.long$peduc < 16 ] <- 3
hrs.long$mypeduc[hrs.long$peduc >= 16] <- 4

table(hrs.long$mypeduc)

hrs.long$ragender <- as.factor(hrs.long$ragender )
hrs.long$raracem <- as.factor(hrs.long$raracem )
hrs.long$rahhidpn <- as.factor(hrs.long$rahhidpn )

#removing people with missing covariates
hrs.long <- (hrs.long[!is.na(hrs.long$rshlt),])
hrs.long$rshlt <- as.factor(hrs.long$rshlt)
hrs.long <- hrs.long[!is.na(hrs.long$raracem),]
hrs.long <- hrs.long[!is.na(hrs.long$ragender),]
hrs.long <- hrs.long[!is.na(hrs.long$myeduc),]

#creating cognition score 
hrs.long$cogscore <- hrs.long$rimrc + hrs.long$rdlrc + hrs.long$rser7 + hrs.long$rbwc20 
sum(is.na(hrs.long$cogscore))

#creating binary cognitive impairment variable, self rated health variable, smoking variable
hrs.long$cogimp <- ifelse(hrs.long$cogscore < 12, 1, 0)
hrs.long$poorhealth <- ifelse((hrs.long$rshlt == 1 | hrs.long$rshlt == 2 | hrs.long$rshlt == 3), 0, 1)
# hrs.long$rsmokev is the binary smoking variable 

#deleting those without cognitive impairment measures (per same-sex couple paper), 8% of cases
sum(is.na(hrs.long$cogimp))/nrow(hrs.long)
hrs.long <- hrs.long[which(is.na(hrs.long$cogimp) == F), ]
hrs.long <- hrs.long[which(is.na(hrs.long$rsmokev) == F), ]
hrs.long <- hrs.long[which(is.na(hrs.long$poorhealth) == F), ]

hrs.long$rlbrfsimp[as.numeric(hrs.long$rlbrf) < 4] <- "in labor force"
hrs.long$rlbrfsimp[hrs.long$rlbrf == 4 | hrs.long$rlbrf == 5] <- "retired"
hrs.long$rlbrfsimp[hrs.long$rlbrf == 6 | hrs.long$rlbrf == 7] <- "disabled/other"
hrs.long$rlbrfsimp <- as.factor(hrs.long$rlbrfsimp)

table(hrs.long$rlbrfsimp)

#sum(is.na(hrs.long$personweight) == T)

#occupation
hrs.long$rjlocc
hrs.long$rmainocc[hrs.long$rjlocc == 1] <- "Managerial and professional specialty"
hrs.long$rmainocc[hrs.long$rjlocc == 2] <- "Professional specialty, technical support"
hrs.long$rmainocc[hrs.long$rjlocc == 3] <- "Sales"
hrs.long$rmainocc[hrs.long$rjlocc == 4] <- "Administrative/clerical support"
hrs.long$rmainocc[hrs.long$rjlocc >= 5 & hrs.long$rjlocc <= 9] <- "Service"
hrs.long$rmainocc[hrs.long$rjlocc >= 10 & hrs.long$rjlocc <= 13] <- "Farming/forestry/fishing, mechanics/repair, construction, precision production"
hrs.long$rmainocc[hrs.long$rjlocc >= 14 & hrs.long$rjlocc <= 16] <- "Operators"
hrs.long$rmainocc[hrs.long$rjlocc == 17 | is.na(hrs.long$rjlocc) == T] <- "Other/unknown"
hrs.long$rmainocc <- as.factor(hrs.long$rmainocc)

table(hrs.long$rmainocc, useNA = "always")

#summary measures seem to be done, now to figure out descrete time hazard models 
#removing people with cognitive impairment at baseline --
hrs.long <- hrs.long %>% 
  group_by(rahhidpn) %>%
  mutate(baseline = first(cogimp)) %>% ungroup()
hrs.long <- hrs.long[which(hrs.long$baseline == 0), ]; hrs.long$baseline <- NULL


write_dta(as.data.frame(hrs.long), "clean_hrs.dta")
