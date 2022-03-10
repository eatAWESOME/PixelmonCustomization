#Author: Alden Tilley
#https://github.com/eatAWESOME
#Date: 11/8/2021

shell("cls")
remove(list = ls())
suppressMessages(suppressWarnings(library(openxlsx)))
suppressMessages(suppressWarnings(library(rjson)))
suppressMessages(suppressWarnings(library(jsonlite)))
suppressMessages(suppressWarnings(library(dplyr)))
shell("cls")

#Input Information
PixelmonFolder <- "<Path to>/pixelmon"
CustomItemsFile <- "<Path to>/Custom Items.xlsx"
CustomShopkeepersFile <- "<Path to>/Custom ShopKeepers.xlsx"



#Shop Items

CustomItems <- read.xlsx(CustomItemsFile)
CustomItems <- CustomItems[,3:8]

Reps <- 1
MaxReps <- length(CustomItems$name)
repeat{
  CustomItems[Reps,7] <- paste0(CustomItems$name[Reps],
                                if(!is.na(CustomItems$id[Reps])){CustomItems$id[Reps]})
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}
names(CustomItems)[7] <- "uniqueName"

ShopItemsFile <- paste0(PixelmonFolder, "/npcs/shopItems.json")
OriginalShopItemsFile <- paste0(PixelmonFolder, "/npcs/originalshopItems.json")
file.copy(from = ShopItemsFile, to = OriginalShopItemsFile, overwrite = FALSE)

ShopItems <- fromJSON(OriginalShopItemsFile) %>% as.data.frame
if(length(ShopItems[1,]) == 5){
  ShopItems[,6] <- NA
  names(ShopItems)[6] <- "items.itemData"
}
names(ShopItems)[names(ShopItems) == "items.name"] <- "name"
names(ShopItems)[names(ShopItems) == "items.buy"] <- "buy"
names(ShopItems)[names(ShopItems) == "items.sell"] <- "sell"
names(ShopItems)[names(ShopItems) == "items.id"] <- "id"
names(ShopItems)[names(ShopItems) == "items.nbtData"] <- "nbtData"
names(ShopItems)[names(ShopItems) == "items.itemData"] <- "itemData"
Reps <- 1
MaxReps <- length(ShopItems$name)
repeat{
  ShopItems[Reps,7] <- paste0(ShopItems$name[Reps],
                              if(!is.na(ShopItems$id[Reps])){ShopItems$id[Reps]})
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}
names(ShopItems)[7] <- "uniqueName"

NewItems <- setdiff(CustomItems$uniqueName,ShopItems$uniqueName)

CustomShopItems <- ShopItems
CustomShopItems[(length(ShopItems$name)+1):(length(ShopItems$name)+length(NewItems)),7] <- NewItems

ItemNums <- data.frame(CustomShopItems$uniqueName,
                       seq(1, length(CustomShopItems$uniqueName), by = 1))
names(ItemNums)[1] <- "uniqueName"
names(ItemNums)[2] <- "Num"

CustomItems[,8] <- ItemNums$Num[match(CustomItems$uniqueName,ItemNums$uniqueName)]
names(CustomItems)[8] <- "Num"

Reps <- 1
MaxReps <- max(ItemNums$Num)
repeat{
  if(Reps %in% CustomItems$Num){
    if(!is.na(CustomItems$name[CustomItems$Num == Reps])){
      CustomShopItems$name[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$name[CustomItems$Num == Reps]
    }
    if(!is.na(CustomItems$itemData[CustomItems$Num == Reps])){
      CustomShopItems$itemData[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$itemData[CustomItems$Num == Reps]
    }
    if(!is.na(CustomItems$buy[CustomItems$Num == Reps])){
      CustomShopItems$buy[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$buy[CustomItems$Num == Reps]
    }
    if(!is.na(CustomItems$sell[CustomItems$Num == Reps])){
      CustomShopItems$sell[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$sell[CustomItems$Num == Reps]
    }
    if(!is.na(CustomItems$id[CustomItems$Num == Reps])){
      CustomShopItems$id[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$id[CustomItems$Num == Reps]
    }
    if(!is.na(CustomItems$nbtData[CustomItems$Num == Reps])){
      CustomShopItems$nbtData[CustomShopItems$uniqueName == CustomItems$uniqueName[CustomItems$Num == Reps]] <- CustomItems$nbtData[CustomItems$Num == Reps]
    }
  }
  
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}

items <- data.frame("id" = CustomShopItems$id,
                    "name" = CustomShopItems$name,
                    "itemData" = CustomShopItems$itemData,
                    "nbtData" = CustomShopItems$nbtData,
                    "buy" = CustomShopItems$buy,
                    "sell" = CustomShopItems$sell)
items$buy[!is.na(items$buy)] <- format(CustomShopItems$buy[!is.na(CustomShopItems$buy)], scientific = FALSE, trim = TRUE)
items$sell[!is.na(items$sell)] <- format(CustomShopItems$sell[!is.na(CustomShopItems$sell)], scientific = FALSE, trim = TRUE)

CustomShopItemsOutput <- data.frame("JSON Text" = 0)
CustomShopItemsOutput[1,] <- "{"
CustomShopItemsOutput[2,] <- "  \"items\": ["
Reps <- 1
MaxReps <- length(items$name)
repeat{
  CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- "    {"
  if(!is.na(items$id[Reps])){
    CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"id\": \"", items$id[Reps], "\",")
  }
  CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"name\": \"", items$name[Reps], "\"",if(!is.na(items$sell[Reps])){
    ","
  } else {
    if(!is.na(items$buy[Reps])){
      ","
    } else {
      if(!is.na(items$nbtData[Reps])){
        ","
      } else {
        if(!is.na(items$itemData[Reps])){
          ","
        }
      }
    }
  })
  if(!is.na(items$itemData[Reps])){
    CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"itemData\": ", items$itemData[Reps], if(!is.na(items$sell[Reps])){
      ","
    } else {
      if(!is.na(items$buy[Reps])){
        ","
      } else {
        if(!is.na(items$nbtData[Reps])){
          ","
        }
      }
    })
  }
  if(!is.na(items$nbtData[Reps])){
    CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"nbtData\": \"", items$nbtData[Reps], "\"", if(!is.na(items$sell[Reps])){
      ","
    } else {
      if(!is.na(items$buy[Reps])){
        ","
      }
    })
  }
  if(!is.na(items$buy[Reps])){
    CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"buy\": ", items$buy[Reps], if(!is.na(items$sell[Reps])){
      ","
    })
  }
  if(!is.na(items$sell[Reps])){
    CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- paste0("      \"sell\": ", items$sell[Reps])
  }
  CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- "    },"
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}
CustomShopItemsOutput[length(CustomShopItemsOutput[,1]),1] <- "    }"
CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- "  ]"
CustomShopItemsOutput[length(CustomShopItemsOutput[,1])+1,1] <- "}"

write.xlsx(CustomShopItems,file = paste0(substr(ShopItemsFile,1,nchar(ShopItemsFile)-5),".xlsx"))
write.table(CustomShopItemsOutput, file = ShopItemsFile, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE, quote = FALSE)
message("Shop Items Edited")



#Move Type Identification

MoveFolder <- paste0(PixelmonFolder, "/moves")

MoveFilenames <- as.data.frame(list.files(path = MoveFolder))
names(MoveFilenames)[1] <- "filenames"

Reps <- 1
MaxReps <- length(MoveFilenames[,1])
Moves <- data.frame("Move" = NA,
                    "Type" = NA)
repeat{
  MoveJSON <- read.csv(file = paste0(MoveFolder,"/",MoveFilenames[Reps,]), row.names = c())
  Moves[Reps,1] <- substr(MoveFilenames[Reps,], 1, nchar(as.character(MoveFilenames[Reps,1]))-5)
  Moves[Reps,2] <- substr(MoveJSON[3,1], 15, nchar(MoveJSON[3,1]))
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}
remove(MoveJSON)

#TM Type Pairing

TMs <- data.frame("uniqueName" = NA,
                  "TM" = NA,
                  "Move" = NA,
                  "Type" = NA)
Reps <- 1
Count <- 0
HMCount <- 0
MaxReps <- length(CustomShopItems$uniqueName)
HMMoves <- data.frame("Move" = c("Cut", "Fly", "Surf", "Strength", "Defog", "Rock Smash", "Waterfall", "Rock Climb", "Whirlpool", "Dive"),
                      "uniqueName" = c("pixelmon:hm1", "pixelmon:hm2", "pixelmon:hm3", "pixelmon:hm4", "pixelmon:hm5", "pixelmon:hm6", "pixelmon:hm7", "pixelmon:hm8", "pixelmon:hm9", "pixelmon:hm10"))
repeat{
  if(!is.na(CustomShopItems$nbtData[Reps])){
    if(substr(CustomShopItems$nbtData[Reps], 2, 3) == "tm"){
      Count <- Count + 1
      TMs[Count,1] <- CustomShopItems$uniqueName[Reps]
      TMs[Count,2] <- substr(CustomShopItems$nbtData[Reps], 5, nchar(CustomShopItems$nbtData[Reps]) - 2)
      TMs[Count,3] <- substr(CustomShopItems$id[Reps], 8, nchar(CustomShopItems$id[Reps]))
    }
  }
  if(substr(CustomShopItems$uniqueName[Reps], 10, 11) == "hm"){
    Count <- Count + 1
    HMCount <- HMCount + 1
    TMs[Count,1] <- CustomShopItems$uniqueName[Reps]
    TMs[Count,3] <- as.character(HMMoves$Move[HMMoves$uniqueName == CustomShopItems$uniqueName[Reps]])
  }
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}
TMs$Type <- Moves$Type[match(tolower(TMs$Move), tolower(Moves$Move))]

#Types

TypeList <- as.data.frame(unique(Moves$Type[Moves$Type != "Mystery"]))
names(TypeList)[1] <- "Type"
TypeList <- as.data.frame(sort(TypeList$Type, order(TypeList$Type), decreasing = FALSE))
names(TypeList)[1] <- "Type"

#ItemIdentifier
ItemIdentifier <- data.frame("uniqueName" <- CustomShopItems$uniqueName,
                             "ItemIdentifier" <- NA)
names(ItemIdentifier)[1] <- "uniqueName"
names(ItemIdentifier)[2] <- "ItemIdentifier"
Reps <- 1
MaxReps <- length(CustomShopItems$uniqueName)
repeat{
  if(is.na(CustomShopItems$id[Reps])){
    ItemIdentifier$ItemIdentifier[Reps] <- CustomShopItems$name[Reps]
  } else {
    ItemIdentifier$ItemIdentifier[Reps] <- CustomShopItems$id[Reps]
  }
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}

#ShopKeepers

ShopKeepersFolder <- paste0(PixelmonFolder, "/npcs/shopKeepers/")
OriginalShopKeepersFolder <- paste0(PixelmonFolder, "/npcs/originalshopKeepers")
if(!dir.exists(OriginalShopKeepersFolder)){
  OriginalShopKeeperList <- data.frame("names" = list.files(path = ShopKeepersFolder))
  dir.create(OriginalShopKeepersFolder)
  Reps <- 1
  MaxReps <- length(OriginalShopKeeperList$names)
  repeat{
    file.copy(from = paste0(ShopKeepersFolder, OriginalShopKeeperList$names[Reps]), to = paste0(OriginalShopKeepersFolder, "/", OriginalShopKeeperList$names[Reps]) , overwrite = FALSE)  
    if(Reps == MaxReps){break} else {Reps <- Reps +1}
  }
}

#TM Type ShopKeepers
TMShopKeeperNames <- data.frame("names" = seq(1, length(TypeList$Type), by = 1),
                                "type" = TypeList$Type)
Reps <- 1
MaxReps <- length(TypeList$Type)
repeat{
  TMShopKeeperNames$names[Reps] <- paste0(TypeList$Type[Reps], " Move Master")
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}

Reps <- 1
MaxReps <- length(TypeList$Type)
repeat{
  TypeMoves <- data.frame("uniqueName" = TMs$uniqueName[TMs$Type == TypeList$Type[Reps]],
                          "id" = NA)
  TypeMoves$id <- CustomShopItems$id[match(TypeMoves$uniqueName, CustomShopItems$uniqueName)]
  TypeMoves$id[is.na(TypeMoves$id)] <- as.character(TypeMoves$uniqueName[is.na(TypeMoves$id)])
  
  TypeShop <- data.frame("JSON Text" = NA)
  TypeShop[1,1] <- "{"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  \"data\": {"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    \"type\": \"PokemartMain\""
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  },"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  \"textures\": ["
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    {"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "      \"name\": \"shopman.png\""
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    }"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  ],"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  \"names\": ["
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    {"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- paste0("      \"name\": \"", TMShopKeeperNames$names[Reps], "\"")
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    }"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  ],"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  \"chat\": ["
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    {"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- paste0("      \"hello\": \"Welcome to my ", TypeList$Type[Reps], " TM Shop. I hope you find something you like!\",")
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "      \"goodbye\": \"See you next time.\""
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    }"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  ],"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  \"items\": ["
  
  SubReps <- 1
  MaxSubReps <- length(TMs$Move[TMs$Type == TypeList$Type[Reps]])
  repeat{
    TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    {"
    TypeShop[length(TypeShop$JSON.Text)+1,1] <- paste0("      \"name\": \"", TypeMoves$id[SubReps], "\",")
    TypeShop[length(TypeShop$JSON.Text)+1,1] <- "      \"variation\": false"
    if(SubReps == MaxSubReps){
      TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    }"
      break
    } else {
      TypeShop[length(TypeShop$JSON.Text)+1,1] <- "    },"
      SubReps <- SubReps + 1}
  }
  
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "  ]"
  TypeShop[length(TypeShop$JSON.Text)+1,1] <- "}"
  
  write.table(TypeShop, file = paste0(ShopKeepersFolder, tolower(TypeList$Type[Reps]), "movemaster_en_us.json"), sep = " ", dec = ".", row.names = FALSE, col.names = FALSE, quote = FALSE)
  message(paste0(TypeList$Type[Reps], " Shop Created"))
  
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}

#Custom ShopKeepers
CustomShopKeepers <- read.xlsx(CustomShopkeepersFile)
CustomShopKeeperNames <- read.xlsx(CustomShopkeepersFile, colNames = FALSE)[1,]
CustomShopKeeperList <- data.frame("names" = tolower(names(CustomShopKeepers)),
                                   "ShopName" = t(CustomShopKeeperNames[1,]))
names(CustomShopKeeperList)[2] <- "ShopName"

Reps <- 1
MaxReps <- length(CustomShopKeeperList$names)
repeat{
  CustomShop <- data.frame("uniqueName" = CustomShopKeepers[,Reps],
                           "name/id" = NA)
  CustomShop <- CustomShop[1:length(CustomShop$uniqueName[!is.na(CustomShop$uniqueName)]),]
  CustomShop$name.id <- ItemIdentifier$ItemIdentifier[match(CustomShop$uniqueName, ItemIdentifier$uniqueName)]
  
  CustomShopOutput <- data.frame("JSON Text" = NA)
  CustomShopOutput[1,1] <- "{"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  \"data\": {"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    \"type\": \"PokemartMain\""
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  },"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  \"textures\": ["
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    {"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "      \"name\": \"shopman.png\""
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    }"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  ],"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  \"names\": ["
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    {"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- paste0("      \"name\": \"", CustomShopKeeperList$ShopName[Reps], "\"")
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    }"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  ],"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  \"chat\": ["
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    {"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- paste0("      \"hello\": \"Welcome to my ", CustomShopKeeperList$ShopName[Reps], " Shop. I hope you find something you like!\",")
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "      \"goodbye\": \"See you next time.\""
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    }"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  ],"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  \"items\": ["
  
  SubReps <- 1
  MaxSubReps <- length(CustomShop$uniqueName)
  repeat{
    CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    {"
    CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- paste0("      \"name\": \"", CustomShop$name.id[SubReps], "\",")
    CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "      \"variation\": false"
    if(SubReps == MaxSubReps){
      CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    }"
      break
    } else {
      CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "    },"
      SubReps <- SubReps + 1}
  }
  
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "  ]"
  CustomShopOutput[length(CustomShopOutput$JSON.Text)+1,1] <- "}"
  
  write.table(CustomShopOutput, file = paste0(ShopKeepersFolder, CustomShopKeeperList$names[Reps], "_en_us.json"), sep = " ", dec = ".", row.names = FALSE, col.names = FALSE, quote = FALSE)
  message(paste0(CustomShopKeeperList$names[Reps], " Shop Created"))
  
  if(Reps == MaxReps){break} else {Reps <- Reps + 1}
}

#NPCs

NPCsFile <- paste0(PixelmonFolder, "/npcs/npcs.json")
OriginalNPCsFile <- paste0(PixelmonFolder, "/npcs/originalnpcs.json")
if(!file.exists(OriginalNPCsFile)){
  file.copy(from = NPCsFile, to = OriginalNPCsFile, overwrite = FALSE)
}

NPCJSON <- as.data.frame(readLines(OriginalNPCsFile))
names(NPCJSON)[1] <- "JSONText"
NPCJSON$JSONText <- as.character(NPCJSON$JSONText)
NPCJSONStartRow <- data.frame("JSONText" = NPCJSON,
                              "Row" = seq(1, length(NPCJSON$JSONText), by = 1))
NPCJSONStartRow <- NPCJSONStartRow$Row[as.character(NPCJSONStartRow$JSONText) == "      \"name\": \"spawn1\""] - 2
#Custom ShopKeeper NPCs
Reps <- 1
MaxReps <- length(CustomShopKeeperList$names)
repeat{
  NPCJSON[(length(NPCJSON$JSONText)+1):(length(NPCJSON$JSONText)+3),] <- NA
  NPCJSON[(NPCJSONStartRow + 3):length(NPCJSON$JSONText),] <- NPCJSON[NPCJSONStartRow:(length(NPCJSON$JSONText) - 3),]
  
  NPCJSON$JSONText[NPCJSONStartRow] <- "    },"
  NPCJSON$JSONText[NPCJSONStartRow + 1] <- "    {"
  NPCJSON$JSONText[NPCJSONStartRow + 2] <- paste0("      \"name\": \"", as.character(CustomShopKeeperList$names[Reps]), "\"")
  
  NPCJSONStartRow <- NPCJSONStartRow + 3
  if(Reps == MaxReps){break} else {
    Reps <- Reps + 1
  }
}
#Type ShopKeeper NPCs
Reps <- 1
MaxReps <- length(TypeList$Type)
repeat{
  NPCJSON[(length(NPCJSON$JSONText)+1):(length(NPCJSON$JSONText)+3),] <- NA
  NPCJSON[(NPCJSONStartRow + 3):length(NPCJSON$JSONText),] <- NPCJSON[NPCJSONStartRow:(length(NPCJSON$JSONText) - 3),]
  
  NPCJSON$JSONText[NPCJSONStartRow] <- "    },"
  NPCJSON$JSONText[NPCJSONStartRow + 1] <- "    {"
  NPCJSON$JSONText[NPCJSONStartRow + 2] <- paste0("      \"name\": \"", as.character(tolower(TypeList$Type[Reps])), "movemaster\"")
  
  if(Reps == MaxReps){break} else {
    NPCJSONStartRow <- NPCJSONStartRow + 3
    Reps <- Reps + 1
  }
}


write.table(NPCJSON, file = NPCsFile, sep = " ", dec = ".", row.names = FALSE, col.names = FALSE, quote = FALSE)
message("NPCs edited")