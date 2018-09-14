#in this script we simpy import the results from SEER stat

rm(list = ls())

M <- read.table("exportMortality.txt")

colnames(M) <- c("Age recode with <1 year olds", "Sex","Age-Adjusted Rate","Count","Population")

#removing unknown
M <- M[M$`Age recode with <1 year olds` != 19,]
#variables disctionary
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 0] <- "00 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 1] <-"01-04 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 2] <-"05-09 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 3] <-"10-14 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 4] <-"15-19 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 5] <-"20-24 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 6] <-"25-29 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 7] <-"30-34 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 8] <-"35-39 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 9] <-"40-44 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 10] <-"45-49 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 11] <-"50-54 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 12] <-"55-59 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 13] <-"60-64 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 14] <-"65-69 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 15] <-"70-74 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 16] <-"75-79 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 17] <-"80-84 years"
M$`Age recode with <1 year olds`[M$`Age recode with <1 year olds` == 18] <-"85+ years"


M$Sex[M$Sex == 0] <- "Male and female"
M$Sex[M$Sex == 1] <- "Male"
M$Sex[M$Sex == 2] <- "Female"

M$`Age-Adjusted Rate` <- as.numeric(as.character(M$`Age-Adjusted Rate`))

#refomratting for the ouput
out <- M[M$Sex == "Male and female", c(1,3)]
out$Male <- M[M$Sex == "Male", 3]
out$Female <- M[M$Sex == "Female", 3]
colnames(out) <- c("Age group", "Male and female", "Male", "Female")


require(xlsx)
write.xlsx(out,"Mortality.xlsx",sheet = "Mortality")
