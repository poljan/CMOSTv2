rm(list = ls())

library(survival)
library(xlsx)

whichPeriod <- 1 #0 = 1988 to 2000; 1 = 2004+ 

if (whichPeriod == 1) {
  load("patientsDatabase2004+.Rdata")
} else {
  load("patientsDatabase88-00.Rdata")
}

#I need to filter the data accrodingly
cancInterst <- cancInterst[cancInterst$seqnum <= 1,] #only first primary
#cancInterst <- cancInterst[cancInterst$srvtimemonflag <= 1,]

#remove CODs that are undefined
cancInterst <- cancInterst[cancInterst$codpubkm != 41000 & cancInterst$codpubkm != 99999,]

#alive == 1, dead == 4
indx <- cancInterst$statrec == 1 & cancInterst$surv == 0
cancInterst <- cancInterst[!indx,]

attach(cancInterst)
cancInterst$statrec[statrec == 1] <- 0 #alive (censored)
cancInterst$statrec[statrec == 4] <- 1 #dead

#if COD (cause of death) is other than colon and rectum then introduce censoring
indx <- !(cancInterst$codpubkm %in% c(21040, 21050, 21060))
cancInterst$statrec[indx] <- 0 #alive (censored)

#limiting to 120 months
indx <- cancInterst$surv > 120
cancInterst$surv[indx] <- 120
cancInterst$statrec[indx] <- 0
cancInterst$surv <- cancInterst$surv+1 #because of the SEER surv definition
detach(cancInterst)

#calculating overall survival by sex
SurvObj <- with(cancInterst, Surv(surv, statrec))
KM <- survfit(SurvObj ~ sex, data = cancInterst, conf.type = "log-log")
overall <- summary(KM, times = seq(0,120,12))
save.df <- as.data.frame(overall[c("strata", "time", "n.risk", "n.event", "surv", "std.err", "lower", "upper")])

write.xlsx(save.df,"OverallSurvivalBySexCOD.xlsx",sheet = "OverallSurvivalBySexCOD")

#defining age groups and stages
cancInterst$ageGroupMDanderson <- cut(cancInterst$agedx, breaks=c(0,50,59,69,79,100))

#calculating stage at diagnosis
#for stage at diagnosis distribution I need to take only cases with valid code
if (whichPeriod == 1) {
  attach(cancInterst)
  cancInterst <- cancInterst[!is.na(cancInterst$dajccstg),] 
  cancInterst$stageCode <- NA
  cancInterst$stageCode[dajccstg >= 10 & dajccstg <= 22] <- "I"
  cancInterst$stageCode[dajccstg >= 30 & dajccstg <= 43] <- "II"
  cancInterst$stageCode[dajccstg >= 50 & dajccstg <= 63] <- "III"
  cancInterst$stageCode[dajccstg >= 70 & dajccstg <= 74] <- "IV"
  cancInterst <- cancInterst[!is.na(cancInterst$stageCode),]
  detach(cancInterst)
} else {
  attach(cancInterst)
  cancInterst <- cancInterst[!is.na(cancInterst$ajccstg),] 
  cancInterst$stageCode <- NA
  cancInterst$stageCode[ajccstg >= 10 & ajccstg <= 19] <- "I"
  cancInterst$stageCode[ajccstg >= 20 & ajccstg <= 29] <- "II"
  cancInterst$stageCode[ajccstg >= 30 & ajccstg <= 39] <- "III"
  cancInterst$stageCode[ajccstg >= 40 & ajccstg <= 49] <- "IV"
  cancInterst <- cancInterst[!is.na(cancInterst$stageCode),]
  detach(cancInterst)
}

SurvObj <- with(cancInterst, Surv(surv, statrec))
KM <- survfit(SurvObj ~ sex + stageCode + ageGroupMDanderson, data = cancInterst, conf.type = "log-log")
overall <- summary(KM, times = seq(0,120,12))
save.df <- as.data.frame(overall[c("strata", "time", "n.risk", "n.event", "surv", "std.err", "lower", "upper")])

write.xlsx(save.df,"OverallSurvivalBySexAgeStageCOD.xlsx",sheet = "OverallSurvivalBySexAgeStageCOD",append = TRUE)

           