#filter data and export to excel
rm(list = ls())

IDs <- read.csv("exportIDs.txt") #read IDs of the patients to be saved (exported using SEER stat)

load("cancDef.RData") #loading all colorect cancer cases imported from SEER ASCII files

#take only matching IDs
indx <- canc$casenum %in% IDs$X03660379

cancInterst <- canc[indx,]

#exporting to excel
require(openxlsx)
write.xlsx(cancInterst,"patientsDatabase.xlsx")

#save filtered database as Rdata
save(cancInterst, file = "patientsDatabase.Rdata")
