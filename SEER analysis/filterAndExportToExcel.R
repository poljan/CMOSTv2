#filter data and export to excel
rm(list = ls())

IDs <- read.csv("exportIDs.txt") #read IDs of the patients to be saved (exported using SEER stat)
colnames(IDs) <- "ID"

load("cancDef.RData") #loading all colorect cancer cases imported from SEER ASCII files

#take only cases after 2004
cancInterst <- canc[canc$yrdx >= 2004,]

#take only matching IDs
indx <- cancInterst$casenum %in% IDs$ID

cancInterst <- cancInterst[indx,]

#exporting to excel
require(openxlsx)
write.xlsx(cancInterst,"patientsDatabase.xlsx")

#save filtered database as Rdata
save(cancInterst, file = "patientsDatabase.Rdata")
