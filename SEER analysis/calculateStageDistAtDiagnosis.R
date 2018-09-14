rm(list = ls())

library(survival)
library(xlsx)

load("patientsDatabase.Rdata")

#calculating stage at diagnosis
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

#defining age grouping
cancInterst$ageGroupMDanderson <- cut(cancInterst$agedx, breaks=c(seq(14,85,5),1000))
cancStageDist <- cancInterst[,c("sex","ageGroupMDanderson","stageCode")]

stageDistribution <- cancStageDist %>% group_by(sex, ageGroupMDanderson, stageCode) %>% summarise(n = n()) #calculate total number of cases

totalEachGroup <- aggregate(stageDistribution$n, by = list(sex = stageDistribution$sex, ageGroupMDanderson = stageDistribution$ageGroupMDanderson), sum)
A <- merge(stageDistribution, totalEachGroup, by = c("sex","ageGroupMDanderson"))

#preparing for output
#nOverall <- aggregate(A$n, by = list(ageGroupMDanderson = A$ageGroupMDanderson, stageCode = A$stageCode), sum)
#nTotal <- aggregate(A$x, by = list(ageGroupMDanderson = A$ageGroupMDanderson, stageCode = A$stageCode), sum)
A$fraction <- A$n/A$x
nOverall <- A[,c(1,2,6)]
nOverallOut <- nOverall[A$stageCode == "I",c(1,2,3)]
nOverallOut$stageII <- nOverall[A$stageCode == "II",3]
nOverallOut$stageIII <- nOverall[A$stageCode == "III",3]
nOverallOut$stageIV <- nOverall[A$stageCode == "IV",3]
colnames(nOverallOut) <- c("sex","ageGroup","stageI","stageII","stageIII","stageIV")

require(xlsx)
write.xlsx(nOverallOut,"StageAtDiagnosis.xlsx",sheet = "StageAtDiagnosis")

