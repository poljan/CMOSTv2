#filter data and export to excel
rm(list = ls())

whichPeriod <- 0 #0 = 1988 to 200; 1 = 2004+ 

if (whichPeriod == 1) {
  IDs <- read.csv("exportIDs2004+.txt") #read IDs of the patients to be saved (exported using SEER stat)
} else {
  IDs <- read.csv("exportIDs88-00.txt") #read IDs of the patients to be saved (exported using SEER stat)
}
colnames(IDs) <- "ID"

load("cancDef.RData") #loading all colorect cancer cases imported from SEER ASCII files
cancInterst <- canc

#take only matching IDs
indx <- cancInterst$casenum %in% IDs$ID


cancInterst <- cancInterst[indx,]

#exporting to excel
require(openxlsx)
if (whichPeriod == 1) {
  cancInterst <- cancInterst[cancInterst$yrdx >= 2004,] #we need that, because ther could be multiple records for the same ID
  write.xlsx(cancInterst,"patientsDatabase2004+.xlsx")

  #save filtered database as Rdata
  save(cancInterst, file = "patientsDatabase2004+.Rdata")
} else {
  cancInterst <- cancInterst[cancInterst$yrdx >= 1988 & cancInterst$yrdx <= 2000,] #we need that, because ther could be multiple records for the same ID
  write.xlsx(cancInterst,"patientsDatabase88-00.xlsx")
  
  #save filtered database as Rdata
  save(cancInterst, file = "patientsDatabase88-00.Rdata") 
}
