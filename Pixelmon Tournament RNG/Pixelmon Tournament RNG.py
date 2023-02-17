#Author: Alden Tilley
#https://github.com/eatAWESOME
#Date: 2/17/2023

import pandas as pd

PlayerList = []
ForceRestriction = None

PlayerList.sort()
PlayerCount = len(PlayerList)
if ForceRestriction == None:
    RestrictionType = pd.DataFrame(["Type", "Biome", "Egg Group", "Region", "Generation", "Game"], columns = ["Restriction"])
    RestrictionType = RestrictionType.sample(1)["Restriction"].item()
else:
    RestrictionType = ForceRestriction
if RestrictionType == "Type":
    df = pd.DataFrame(["Bug",
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
                       "Water"
                       ], columns = ["Restriction"])
elif RestrictionType == "Biome":
    df = pd.DataFrame(["Badlands",
                       "Badlands Plateau",
                       "Bamboo Jungle",
                       "Bamboo Jungle Hills",
                       "Basalt Deltas",
                       "Beach",
                       "Birch Forest",
                       "Birch Forest Hills",
                       "Cold Ocean",
                       "Crimson Forests",
                       "Dark Forest",
                       "Dark Forest Hills",
                       "Deep Cold Ocean",
                       "Deep Frozen Ocean",
                       "Deep Lukewarm Ocean",
                       "Deep Ocean",
                       "Deep Warm Ocean",
                       "Desert",
                       "Desert Hills",
                       "Desert Lakes",
                       "End Barrens",
                       "End Highlands",
                       "End Midlands",
                       "Eroded Badlands",
                       "Flower Forest",
                       "Forest",
                       "Frozen Ocean",
                       "Frozen River",
                       "Giant Spruce Taiga",
                       "Giant Spruce Taiga Hills",
                       "Giant Tree Taiga",
                       "Giant Tree Taiga Hills",
                       "Gravelly Mountains",
                       "Gravelly Mountains+",
                       "Ice Spikes",
                       "Jungle",
                       "Jungle Edge",
                       "Jungle Hills",
                       "Lukewarm Ocean",
                       "Modified Badlands Plateau",
                       "Modified Jungle",
                       "Modified Jungle Edge",
                       "Modified Wooded Badlands Plateau",
                       "Mountain Edge",
                       "Mountains",
                       "Mushroom Fields",
                       "Mushroom Field Shore",
                       "Nether Wastes",
                       "Ocean",
                       "Plains",
                       "River",
                       "Savanna",
                       "Savanna Plateau",
                       "Shattered Savanna",
                       "Shattered Savanna Plateau",
                       "Small End Islands",
                       "Snowy Beach",
                       "Snowy Mountains",
                       "Snowy Taiga",
                       "Snowy Taiga Hills",
                       "Snowy Taiga Mountains",
                       "Snowy Tundra",
                       "Soul Sand Valley",
                       "Stone Shore",
                       "Sunflower Plains",
                       "Swamp",
                       "Swamp Hills",
                       "Taiga",
                       "Taiga Hills",
                       "Taiga Mountains",
                       "Tall Birch Forest",
                       "Tall Birch Hills",
                       "The End",
                       "Warm Ocean",
                       "Warped Forest",
                       "Wooded Badlands Plateau",
                       "Wooded Hills",
                       "Wooded Mountains",
                       "Mount Lanakila",
                       "Ultra Deep Sea",
                       "Ultra Desert",
                       "Ultra Forest",
                       "Ultra Jungle"
                       ], columns = ["Restriction"])
elif RestrictionType == "Egg Group":
    df = pd.DataFrame(["Amorphous",
                       "Bug",
                       #"Ditto",
                       "Dragon",
                       "Fairy",
                       "Field",
                       "Flying",
                       "Grass",
                       "Human-Like",
                       "Mineral",
                       "Monster",
                       "Undiscovered",
                       "Water 1",
                       "Water 2",
                       "Water 3"
                       ], columns = ["Restriction"])
elif RestrictionType == "Region":
    df = pd.DataFrame(["Kanto",
                       "Johto",
                       "Hoenn",
                       "Sinnoh",
                       "Unova",
                       "Kalos",
                       "Alola",
                       "Galar",
                       "Hisui",
                       "Paldea"
                       ], columns = ["Restriction"])
elif RestrictionType == "Generation":
    df = pd.DataFrame([i for i in range(1, 9 + 1)], columns = ["Restriction"])
elif RestrictionType == "Game":
    df = pd.DataFrame(["Red",
                       "Blue"
                       "Yellow",
                       "Gold",
                       "Silver",
                       "Crystal",
                       "Ruby",
                       "Sapphire",
                       "FireRed",
                       "LeafGreen",
                       "Emerald",
                       "Diamond",
                       "Pearl",
                       "Platinum",
                       "HeartGold",
                       "SoulSilver",
                       "Black",
                       "White",
                       "Black 2",
                       "White 2",
                       "X",
                       "Y",
                       "Omega Ruby",
                       "Alpha Sapphire",
                       "Sun",
                       "Moon",
                       "Ultra Sun",
                       "Ultra Moon",
                       "Let's Go, Pikachu!",
                       "Let's Go, Eevee!",
                       "Sword",
                       "Shield",
                       "Brilliant Diamond",
                       "Shining Pearl",
                       "Legends: Arceus",
                       "Scarlet",
                       "Violet"
                       ], columns = ["Restriction"])
Players = pd.DataFrame(index = range(len(PlayerList)), columns = ["Player", "Restriction"])
if len(PlayerList) <= len(df):
    Players["Restriction"] = list(df.sample(PlayerCount)["Restriction"])
    Players["Player"] = PlayerList
else:
    for i in range(len(PlayerList)):
        Players.loc[i, ["Player", "Restriction"]] = PlayerList[i], df.sample(1)["Restriction"].values[0]
print(Players)
