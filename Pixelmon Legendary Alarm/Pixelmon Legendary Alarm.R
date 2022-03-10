shell("cls")
remove(list = ls())
suppressMessages(suppressWarnings(library(utils)))
suppressMessages(suppressWarnings(library(tidyverse)))
suppressMessages(suppressWarnings(library(beepr))) #Can be removed if using Pokemon Theme Song
shell("cls")

repeat{
  
  message(paste0("Search Start: ", format(Sys.time(), "%H:%M:%S")))
  
repeat{

  
  serverlog <- read.delim(file = "<Path to Server>/logs/latest.log", header = FALSE)
    latest <- tail(serverlog,10)
    row.names(latest) <- c()
    
  logtest <- FALSE
    if(grepl("has spawned in a", latest[1,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[2,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[3,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[4,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[5,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[6,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[7,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[8,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[9,], fixed = TRUE)){logtest <- TRUE}
    if(grepl("has spawned in a", latest[10,], fixed = TRUE)){logtest <- TRUE}
  
  if(logtest){break}
  
  Sys.sleep(1)
  
  remove(list = ls())
}

message(paste0("Legendary Spawned at ", format(Sys.time(), "%H:%M:%S")))
beep() #Recommended to replace this with shell.exec("<Path to Pokemon Theme Song>")

Restart <- readline(prompt = "Restart? (Y/N) ")
message("")
if(Restart == "N"){break}
}