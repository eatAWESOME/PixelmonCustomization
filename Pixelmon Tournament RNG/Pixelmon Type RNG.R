#Author: Alden Tilley
#Date: 11/20/2021

PlayerCount <- 10

RNGData <- data.frame("Type" = c("Bug",
                                 "Dark",
                                 "Dragon",
                                 "Electric",
                                 "Fairy",
                                 "Fighting",
                                 "Fire",
                                 "Flying",
                                 "Ghost",
                                 "Grass",
                                 "Ground",
                                 "Ice",
                                 "Normal",
                                 "Poison",
                                 "Psychic",
                                 "Rock",
                                 "Steel",
                                 "Water"),
                      "ID" = NA)
RNGData[,2] <- seq(1, length(RNGData$Type), by = 1)
Players <- data.frame("Player" = seq(1, PlayerCount, by = 1),
                      "Type" = NA,
                      "TypeID" = sample(RNGData$ID, PlayerCount))
Players$Type <- RNGData$Type[match(Players$TypeID, RNGData$ID)]
