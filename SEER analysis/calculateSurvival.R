rm(list = ls())

library(survival)
library(xlsx)

load("patientsDatabase.Rdata")

#I need to filter the data accrodingly
cancInterst <- cancInterst[cancInterst$seqnum <= 1,] #only first primary
#cancInterst <- cancInterst[cancInterst$srvtimemonflag <= 1,]

#alive == 1, dead == 4
indx <- cancInterst$statrec == 1 & cancInterst$surv == 0
cancInterst <- cancInterst[!indx,]

attach(cancInterst)
cancInterst$statrec[statrec == 1] <- 0 #alive (censored)
cancInterst$statrec[statrec == 4] <- 1 #dead


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

write.xlsx(save.df,"OverallSurvivalBySex.xlsx",sheet = "OverallSurvivalBySex")

#defining age groups and stages
cancInterst$ageGroupMDanderson <- cut(cancInterst$agedx, breaks=c(0,50,59,69,79,100))

#for stage at diagnosis distribution I need to take only cases with valid code
attach(cancInterst)
cancInterst <- cancInterst[!is.na(cancInterst$dajccstg),] 
cancInterst$stageCode <- NA
cancInterst$stageCode[dajccstg >= 10 & dajccstg <= 22] <- "I"
cancInterst$stageCode[dajccstg >= 30 & dajccstg <= 43] <- "II"
cancInterst$stageCode[dajccstg >= 50 & dajccstg <= 63] <- "III"
cancInterst$stageCode[dajccstg >= 70 & dajccstg <= 74] <- "IV"
cancInterst <- cancInterst[!is.na(cancInterst$stageCode),]
detach(cancInterst)

SurvObj <- with(cancInterst, Surv(surv, statrec))
KM <- survfit(SurvObj ~ sex + stageCode + ageGroupMDanderson, data = cancInterst, conf.type = "log-log")
overall <- summary(KM, times = seq(0,120,12))
save.df <- as.data.frame(overall[c("strata", "time", "n.risk", "n.event", "surv", "std.err", "lower", "upper")])

write.xlsx(save.df,"OverallSurvivalBySexAgeStage.xlsx",sheet = "OverallSurvivalBySexAgeStage",append = TRUE)

           