rm(list = ls())

library(shiny)
require(LaF)
library(SEERaBomb)

mainFolder <- 'SEER_1973_2014_CUSTOM_TEXTDATA'
subfolders <- c('yr1973_2014.seer9','yr1992_2014.sj_la_rg_ak','yr2000_2014.ca_ky_lo_nj_ga','yr2005.lo_2nd_half')


NsubFolders <- length(subfolders)

fldsSAS <- getFields(seerHome = paste(getwd(),mainFolder,sep="/"))
fldsPick <- pickFields(fldsSAS, picks = fldsSAS$names)

source("mkSEERmodified.R")

mkSEERmodified(fldsPick,seerHome=paste(getwd(),mainFolder,sep="/"),outDir="mrgd",outFile="cancDef",
       indices = list(c("sex","race"), c("histo3","seqnum"),  "ICD9"),
       writePops=TRUE,writeRData=TRUE,writeDB=FALSE)