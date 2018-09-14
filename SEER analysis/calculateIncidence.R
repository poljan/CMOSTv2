require(dplyr)

rm(list = ls()) #clear the variables

whichPeriod <- 0 #0 = 1988 to 200; 1 = 2004+ 

if (whichPeriod == 1) {
  load("patientsDatabase2004+.Rdata")
} else {
  load("patientsDatabase88-00.Rdata")
}
load("popsae.RData") #loading information about population

sex = agedx = yrdx = py = cases = reg = NULL

D = cancInterst %>% select(reg, sex, agedx, year = yrdx) %>% 
  mutate(age = agedx + 0.5) %>% select(-agedx)
m = D %>% group_by(sex, age, year) %>% summarise(n = n()) #calculate total number of cases

#I need to remove cases above 99.5 years old, because I don't have population data for that
m <- m[m$age <= 99.5, ]

#take population data
p = popsae %>% group_by(sex, age, year) %>% summarise(py = sum(py))
if (whichPeriod == 1) {
  #take only data after 2004
  p <- p[p$year >= 2004,]
} else {
  p <- p[p$year >= 1988 & p$year <= 2000,]
}

W <- merge(m,p, by = c("age","year","sex"), all = T)
W$n[is.na(W$n)] <- 0

NoEvents <- aggregate(W$n, by=list(age=W$age, sex = W$sex), FUN=sum)
colnames(NoEvents) <- c("age","sex","n")
TotPop <- aggregate(W$py, by=list(age=W$age, sex = W$sex), FUN=sum)
colnames(TotPop) <- c("age","sex","py")

A <- merge(NoEvents, TotPop, by =c("age","sex"))

A$IncidencePer100000 <- A$n/(A$py)*10^5
A$age <- A$age - 0.5

#incidence per age group and sex
IncidenceAgeGroupAndSex <- aggregate(A$IncidencePer100000, by = list(sex = A$sex, age = cut(A$age, breaks=c(0,4,seq(9,85,5),1000))), mean )

#incidence only by age group
IncidenceAgeGroup <- aggregate(A$IncidencePer100000, by = list(age = cut(A$age, breaks=c(0,4,seq(9,85,5),1000))), mean )

#collapsing to final table
IncidenceAgeGroup$male <- IncidenceAgeGroupAndSex[IncidenceAgeGroupAndSex$sex == "male",3]
IncidenceAgeGroup$female <- IncidenceAgeGroupAndSex[IncidenceAgeGroupAndSex$sex == "female",3]
colnames(IncidenceAgeGroup) <- c("Age group","Overall","Male","Female")

require(xlsx)
write.xlsx(IncidenceAgeGroup,"incidence.xlsx",sheet = "Incidence")