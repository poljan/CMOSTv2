mkSEERmodified <- function (df, seerHome = "~/data/SEER", outDir = "mrgd", outFile = "cancDef", 
          indices = list(c("sex", "race"), c("histo3", "seqnum"), "ICD9"), 
          writePops = TRUE, writeRData = TRUE, writeDB = FALSE) 
{
  db = reg = race = sex = age = agerec = year = py = agedx = age19 = age86 = NULL
  mkPopsae = function(popsa) {
    rates = SEERaBomb::nvsr01[86:100, ]
    props = cumprod(1 - rates[, c("pm", "pf")])
    tots = cumsum(props)["100", ]
    for (i in 1:dim(props)[2]) props[, i] = props[, i]/tots[, 
                                                            i]
    elders = popsa %>% filter(age86 == 90) %>% group_by(db, 
                                                        reg, race, sex, year)
    grow = function(x) {
      if (x$sex == "male") 
        y = data.frame(x, age = 85.5:99.5, PY = x$py * 
                         props$pm)
      else y = data.frame(x, age = 85.5:99.5, PY = x$py * 
                            props$pf)
      y
    }
    elders = elders %>% do_(~grow(.)) %>% select(-age86, 
                                                 -py)
    nms = names(elders)
    names(elders)[which(nms == "PY")] <- c("py")
    nelders = popsa %>% filter(age86 < 90)
    nms = names(nelders)
    names(nelders)[which(nms == "age86")] <- c("age")
    elders = elders[, names(nelders)]
    bind_rows(nelders, elders)
  }
  seerHome = path.expand(seerHome)
  outD = file.path(seerHome, outDir)
  outF = file.path(seerHome, outDir, paste0(outFile, ".RData"))
  outDB = file.path(seerHome, outDir, paste0(outFile, ".db"))
  dir.create(outD, showWarnings = FALSE)
  if (writePops | writeDB) {
    cat("Making population file data.tables\n")
    dirs = list.dirs(file.path(seerHome, "populations"))
    dirs = dirs[grep("yr", dirs)]
    dirs = dirs[-grep("yr2005", dirs)]
    colTypes = c("integer", "string", rep("integer", 5), 
                 "double")
    colWidths = c(4, 7, 2, 1, 1, 1, 2, 10)
    colNames2 = c("year", "X0", "reg", "race", "origin", 
                  "sex", "age86", "py")
    ptm <- proc.time()
    popsaL = vector(mode = "list", 3)
    ii = 1
    for (i in dirs) {
      f = file.path(i, "singleages.txt")
      laf <- laf_open_fwf(f, column_types = colTypes, column_widths = colWidths, 
                          column_names = colNames2)
      popsaL[[ii]] = tbl_df(laf[, colNames2[-c(2, 5)]])
      if (grepl("plus", i)) {
        popsaL[[ii]] = popsaL[[ii]] %>% filter(reg %in% 
                                                 c(29, 31, 35, 37))
        cat("Removing SEER 9 person years from:\n", i, 
            "\nbefore pooling into one file.\n")
      }
      ii = ii + 1
    }
    popsa = bind_rows(popsaL)
    popsa$reg = as.integer(popsa$reg + 1500)
    popsa = popsa %>% mutate(race = cut(race, labels = c("white", 
                                                         "black", "other"), breaks = c(1, 2, 3, 100), right = F)) %>% 
      mutate(db = cut(reg, labels = c("73", "92", "00"), 
                      breaks = c(1500, 1528, 1540, 1550), right = F)) %>% 
      mutate(reg = mapRegs(reg)) %>% mutate(age86 = age86 + 
                                              0.5) %>% mutate(sex = factor(sex, labels = c("male", 
                                                                                           "female"))) %>% group_by(db, reg, race, sex, age86, 
                                                                                                                    year) %>% summarise(py = sum(py))
    popsa = as.data.frame(popsa)
    popsa[popsa$age86 == 85.5, "age86"] = 90
    popsae = mkPopsae(popsa)
    delT = proc.time() - ptm
    cat("The population files of SEER were processed in ", 
        delT[3], " seconds.\n", sep = "")
  }
  if (writeRData | writeDB) {
    dirs = list.dirs(file.path(seerHome, "incidence"))
    dirs = dirs[grep("yr", dirs)]
    dirs = dirs[-grep("yr2005", dirs)]
    y = df[which(df$names != " "), "names"]
    cat("Cancer Data:\nThe following fields will be written:\n")
    print(y)
    cancers = c("colrect");#c("breast", "digothr", "malegen", "femgen", 
              #  "other", "respir", "colrect", "lymyleuk", "urinary")
    files = paste0(cancers, ".txt")
    DFL = vector(mode = "list", length(dirs) * length(files))
    ptm <- proc.time()
    ii = 1
    for (i in dirs) for (j in files) {
      f = file.path(i, toupper(j))
      print(f)
      laf <- laf_open_fwf(f, column_types = df$type, column_widths = df$width)
      DFL[[ii]] = tbl_df(laf[, which(df$names != " ")])
      ii = ii + 1
    }
    print("using bind_rows() to make DF canc")
    canc = bind_rows(DFL)
    colnames(canc) <- y
    canc = canc %>% filter(agedx < 200) %>% mutate(race = cut(race, 
                                                              labels = c("white", "black", "other"), breaks = c(1, 
                                                                                                                2, 3, 100), right = F)) %>% mutate(db = cut(reg, 
                                                                                                                                                            labels = c("73", "92", "00"), breaks = c(1500, 1528, 
                                                                                                                                                                                                     1540, 1550), right = F)) %>% mutate(reg = mapRegs(reg)) %>% 
      mutate(age86 = as.numeric(as.character(cut(agedx, 
                                                 c(0:85, 150), right = F, labels = c(0.5:85, 90))))) %>% 
      mutate(sex = factor(sex, labels = c("male", "female")))
    canc = mapCancs(canc)
    canc = mapTrts(canc)
    delT = proc.time() - ptm
    cat("Cancer files were processed in ", delT[3], " seconds.\n")
  }
  if (writeDB) {
    print("Deleting old version of this SQLite database file.")
    unlink(outDB)
    print("Creating new SQLite database file.")
    ptm <- proc.time()
    my_db <- src_sqlite(outDB, create = T)
    copy_to(my_db, canc, temporary = FALSE, indexes = indices, 
            overwrite = TRUE)
    copy_to(my_db, popsa, temporary = FALSE, overwrite = TRUE)
    copy_to(my_db, popsae, temporary = FALSE, overwrite = TRUE)
    delT = proc.time() - ptm
    cat("\ndata.tables were written to ", outDB, " in ", 
        delT[3], " seconds.\n")
    cat("tables in this SQLite file are:\n")
  }
  if (writeRData) {
    print("save()-ing DF canc to disk")
    canc = tbl_df(canc)
    save(canc, file = outF)
    cat("Cancer data has been written to: ", outF, "\n")
  }
  if (writePops) {
    popsa = tbl_df(popsa)
    popsae = tbl_df(popsae)
    save(popsa, file = file.path(outD, "popsa.RData"))
    save(popsae, file = file.path(outD, "popsae.RData"))
  }
  s = dir(outD, full.names = T)
  d = file.info(s)[, c("size", "mtime")]
  d$size = paste0(round(d$size/1e+06), " M")
  print(d)
}