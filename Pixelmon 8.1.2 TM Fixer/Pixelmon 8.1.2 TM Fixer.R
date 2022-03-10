shell("cls")
remove(list = ls())
suppressMessages(suppressWarnings(library(rjson)))
suppressMessages(suppressWarnings(library(jsonlite)))
shell("cls")

OldFolder <- "<Path to Old Stats Folder>"
NewFolder <- "<Path to New Stats Folder>"

OldFilenames <- as.data.frame(list.files(path = OldFolder))
NewFilenames <- as.data.frame(list.files(path = NewFolder))
names(OldFilenames)[1] <- "filenames"
names(NewFilenames)[1] <- "filenames"
Filenames <- merge(OldFilenames,NewFilenames,by="filenames")

reps <- 0
count <- length(Filenames[,1])+0

repeat{
  reps <- reps + 1
  
  NewJSON <- read_json(path = paste0(NewFolder,"/",Filenames[reps,]))
  OldJSON <- read_json(path = paste0(OldFolder,"/",Filenames[reps,]))
  NewJSON[["tmMoves"]] <- OldJSON[["tmMoves"]]
  write_json(NewJSON, path = paste0(NewFolder,"/",Filenames[reps,]), pretty = TRUE, auto_unbox = TRUE, null = "null")
  message(paste0(substr(Filenames[reps,],1,nchar(as.character(Filenames[reps,1]))-5)," Fixed"))
  
  if(count==reps){break}
}

message("")
message("TMs Fixed!")