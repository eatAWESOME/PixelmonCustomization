#Author: Alden Tilley
#https://github.com/eatAWESOME
#Date: 1/3/2023

import os
import glob
import pandas as pd

PixelmonPath = None #Path to ./data/pixelmon
DatapacksPath = None #Path to ./world/datapacks

if not os.path.exists(DatapacksPath + "/LidFixer/pixelmon/recipes/pokeball/lid"):
    os.makedirs(DatapacksPath + "/LidFixer/pixelmon/recipes/pokeball/lid")
    
lids = glob.glob(PixelmonPath + "/recipes/pokeball/lid/*.json")
for lidpath in lids:
    lidtype = os.path.basename(lidpath).replace("_lid.json", "")
    df = pd.read_table(lidpath, header = None)
    df.drop(index = range(max(df.index) - 1, max(df.index) + 1), inplace = True)
    df.loc[max(df.index) - 1, 0] = df.loc[max(df.index) - 1, 0].replace(lidtype, "poke_ball")
    df.loc[max(df.index), 0] += ","
    df.loc[max(df.index) + 1, 0] = "    \"nbt\": {"
    df.loc[max(df.index) + 1, 0] = "      \"PokeBallID\": \"" + lidtype + "\""
    df.loc[max(df.index) + 1, 0] = "    }"
    df.loc[max(df.index) + 1, 0] = "  }"
    df.loc[max(df.index) + 1, 0] = "}"
    df.to_csv(lidpath.replace(PixelmonPath.replace("/pixelmon", ""), DatapacksPath + "/LidFixer"), index = False, header = False, quoting = 3, sep = "\\", escapechar = "\\")
    
pack = pd.DataFrame(index = range(6), columns = [0])
pack.loc[0, 0] = "{"
pack.loc[1, 0] = "  \"pack\": {"
pack.loc[2, 0] = "    \"pack_format\": 6,"
pack.loc[3, 0] = "    \"description\": \"Pixelmon 9.1.0 Lid Fixer\""
pack.loc[4, 0] = "  }"
pack.loc[5, 0] = "}"
pack.to_csv(DatapacksPath + "/LidFixer/pack.mcmeta", index = False, header = False, quoting = 3, sep = "\\", escapechar = "\\")
