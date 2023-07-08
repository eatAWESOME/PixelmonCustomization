#Author: Alden Tilley
#https://github.com/eatAWESOME
#Date: 6/28/2023

import os
import winsound
import threading
import numpy as np
import pandas as pd
import tkinter as tk
from tkinter import filedialog

def UpdateConfig(TrainerExcelFile):
    try:
        TrainerNames = pd.ExcelFile(TrainerExcelFile).sheet_names
        if len(TrainerNames) > 0 and not os.path.exists(os.path.dirname(TrainerExcelFile) + "/Trainer Pokepastes"):
            os.makedirs(os.path.dirname(TrainerExcelFile) + "/Trainer Pokepastes")
        for TrainerName in TrainerNames:
            if TrainerName not in ["Blank", "Trainer Info"]:
                TrainerDF = pd.read_excel(TrainerExcelFile, sheet_name = TrainerName, index_col = 0)
                Trainer = []
                for Pokemon in TrainerDF.columns:
                    if len(Trainer) > 0:
                        Trainer += [""]
                    PokemonName = Pokemon.split(".")[0]
                    if type(TrainerDF.loc["Gender", Pokemon]) == str:
                        PokemonName += " (" + TrainerDF.loc["Gender", Pokemon] + ")"
                    if type(TrainerDF.loc["Held Item", Pokemon]) == str:
                        PokemonName += " @ " + TrainerDF.loc["Held Item", Pokemon]
                    Trainer += [PokemonName,
                                "Ability: " + TrainerDF.loc["Ability", Pokemon],
                                "Level: " + str(TrainerDF.loc["Level", Pokemon])]
                    if TrainerDF.loc["Shiny", Pokemon] == "Y" or TrainerDF.loc["Shiny", Pokemon] == "Yes" or TrainerDF.loc["Shiny", Pokemon] == "YES":
                        Trainer += ["Shiny: Yes"]
                    else:
                        Trainer += ["Shiny: NO"]
                    try:
                        Trainer += ["Happiness: " + str(int(TrainerDF.loc["Happiness", Pokemon]))]
                    except:
                        Trainer += ["Happiness: 70"]
                    if type(TrainerDF.loc["EVs", Pokemon]) == str:
                        Trainer += ["EVs: " + TrainerDF.loc["EVs", Pokemon].split(",")[0] + " HP / " + TrainerDF.loc["EVs", Pokemon].split(",")[1] + " Atk / " + TrainerDF.loc["EVs", Pokemon].split(",")[2] + " Def / " + TrainerDF.loc["EVs", Pokemon].split(",")[3] + " SpA / " + TrainerDF.loc["EVs", Pokemon].split(",")[4] + " SpD / " + TrainerDF.loc["EVs", Pokemon].split(",")[5] + " Spe"]
                    Trainer += [TrainerDF.loc["Nature", Pokemon] + " Nature"]
                    if type(TrainerDF.loc["IVs", Pokemon]) == str:
                        Trainer += ["IVs: " + TrainerDF.loc["IVs", Pokemon].split(",")[0] + " HP / " + TrainerDF.loc["IVs", Pokemon].split(",")[1] + " Atk / " + TrainerDF.loc["IVs", Pokemon].split(",")[2] + " Def / " + TrainerDF.loc["IVs", Pokemon].split(",")[3] + " SpA / " + TrainerDF.loc["IVs", Pokemon].split(",")[4] + " SpD / " + TrainerDF.loc["IVs", Pokemon].split(",")[5] + " Spe"]
                    else:
                        Trainer += ["IVs: 15 HP / 15 Atk / 15 Def / 15 SpA / 15 SpD / 15 Spe"]
                    if type(TrainerDF.loc["Poke Ball", Pokemon]) == str:
                        Trainer += ["Poke Ball: " + TrainerDF.loc["Poke Ball", Pokemon]]
                    else:
                        Trainer += ["Poke Ball: poke_ball"]
                    if type(TrainerDF.loc["Growth", Pokemon]) == str:
                        Trainer += ["Growth: " + TrainerDF.loc["Growth", Pokemon]]
                    else:
                        Trainer += ["Growth: Ordinary"]
                    for Move in ["Move 1", "Move 2", "Move 3", "Move 4"]:
                        if type(TrainerDF.loc[Move, Pokemon]) == str:
                            Trainer += ["- " + TrainerDF.loc[Move, Pokemon]]
                
                #Output
                np.savetxt(os.path.dirname(TrainerExcelFile) + "/Trainer Pokepastes/" + TrainerName + ".txt", pd.DataFrame(Trainer).values, fmt = "%s")
            
        
        Status["text"] = "Finished!"
        StartButton["state"] = tk.NORMAL
        winsound.Beep(200, 1000)
    except Exception as e:
        Status["text"] = "Error: " + repr(e)
        StartButton["state"] = tk.NORMAL
        winsound.Beep(200, 1000)

def Start():
    StartButton["state"] = tk.DISABLED
    global thread
    thread = threading.Thread(target = UpdateConfig, args = [TrainerExcelVar.get(),])
    thread.start()

def TrainerExcelBrowser():
    if TrainerExcelVar.get() != "" and os.path.exists(TrainerExcelVar.get()):
        InitialDirectory = os.path.dirname(TrainerExcelVar.get())
    else:
        InitialDirectory = "C:/"
    root.filename = filedialog.askopenfilename(initialdir = InitialDirectory, title = "Browse")
    TrainerExcelVar.delete(0, tk.END)
    TrainerExcelVar.insert(0, root.filename)

root = tk.Tk()
root.title("Pixelmon Custom Trainers")

root.columnconfigure(index = 0, weight = 1)
root.columnconfigure(index = 1, weight = 2)
root.columnconfigure(index = 2, weight = 4)
root.columnconfigure(index = 3, weight = 2)
root.columnconfigure(index = 4, weight = 1)

Spacer1 = tk.Label(root, text = " ").grid(row = 0, column = 0)
Spacer1 = tk.Label(root, text = " ").grid(row = 0, column = 4)

Title = tk.Label(root, text = "Pixelmon Custom Trainers").grid(row = 0, column = 0, columnspan = 5)

TrainerExcelText = tk.Label(root, text = "Trainer Excel:").grid(row = 11, column = 1)
TrainerExcelVar = tk.Entry(root, width = 70)
TrainerExcelVar.grid(row = 11, column = 2)
if os.path.exists("Custom Trainers.xlsx"):
    TrainerExcelVar.insert(0, os.getcwd() + "\\Custom Trainers.xlsx")
TrainerExcelButton = tk.Button(root, text = "Browse", command = TrainerExcelBrowser).grid(row = 11, column = 3)

Status = tk.Label(root, text = "Ready")
Status.grid(row = 20, column = 0, columnspan = 5)

StartButton = tk.Button(root, text = "Start", command = Start)
StartButton.grid(row = 31, column = 0, columnspan = 5)

root.mainloop()