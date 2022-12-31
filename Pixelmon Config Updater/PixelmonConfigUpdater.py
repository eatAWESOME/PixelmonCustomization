#Author: Alden Tilley
#https://github.com/eatAWESOME
#Date: 9/14/2022

import glob
import winsound
import threading
import pandas as pd
import tkinter as tk
from tkinter import filedialog
  
def UpdateConfig(OldFolder, NewFolder):
    try:
        Status["text"] = "Importing Old Configs"
        OldFiles = glob.glob(OldFolder + "/*.yml")
        Old = pd.DataFrame()
        for OldFile in OldFiles:
            Old = pd.concat([Old, pd.read_table(OldFile, header = None)])
        Old.reset_index(drop = True, inplace = True)
        Old.rename(columns = {0 : "Full"}, inplace = True)
        for i in range(len(Old)):
            if all([": " in Old.loc[i, "Full"], "block-id" not in Old.loc[i, "Full"], "color" not in Old.loc[i, "Full"], "pattern" not in Old.loc[i, "Full"]]):
                Old.loc[i, "Setting"], Old.loc[i, "Value"] = Old.loc[i, "Full"].split(": ")
        
        Status["text"] = "Updating New Configs"
        NewFiles = glob.glob(NewFolder + "/*.yml")
        for NewFile in NewFiles:
            New = pd.read_table(NewFile, header = None)
            New.rename(columns = {0 : "Full"}, inplace = True)
            for i in range(len(New)):
                if all([": " in New.loc[i, "Full"], "block-id" not in New.loc[i, "Full"], "color" not in New.loc[i, "Full"], "pattern" not in New.loc[i, "Full"]]):
                    if New.loc[i, "Full"].split(": ")[0] in Old["Setting"].values:
                        New.loc[i, "Full"] = (New.loc[i, "Full"].split(": ")[0] + ": " + Old.loc[Old["Setting"] == New.loc[i, "Full"].split(": ")[0], "Value"].values)[0]
            New.to_csv(NewFile, header = False, index = False)
        
        Status["text"] = "Finished!"
        StartButton["state"] = tk.NORMAL
        winsound.Beep(200, 1000)
    except:
        Status["text"] = "Error"
        StartButton["state"] = tk.NORMAL
        winsound.Beep(200, 1000)

def Start():
    StartButton["state"] = tk.DISABLED
    global thread
    thread = threading.Thread(target = UpdateConfig, args = [OldFolderVar.get(), NewFolderVar.get()])
    thread.start()

def OldFolderBrowser():
    InitialDirectory = "C:/"
    root.filename = filedialog.askdirectory(initialdir = InitialDirectory, title = "Browse")
    OldFolderVar.delete(0, tk.END)
    OldFolderVar.insert(0, root.filename)
    
def NewFolderBrowser():
    InitialDirectory = "C:/"
    root.filename = filedialog.askdirectory(initialdir = InitialDirectory, title = "Browse")
    NewFolderVar.delete(0, tk.END)
    NewFolderVar.insert(0, root.filename)

root = tk.Tk()
root.title("Pixelmon Config Update")

root.columnconfigure(index = 0, weight = 1)
root.columnconfigure(index = 1, weight = 2)
root.columnconfigure(index = 2, weight = 4)
root.columnconfigure(index = 3, weight = 2)
root.columnconfigure(index = 4, weight = 1)

Spacer1 = tk.Label(root, text = " ").grid(row = 0, column = 0)
Spacer1 = tk.Label(root, text = " ").grid(row = 0, column = 4)

Title = tk.Label(root, text = "Pixelmon Config Update").grid(row = 0, column = 0, columnspan = 5)

OldFolderText = tk.Label(root, text = "Old Config Folder:").grid(row = 11, column = 1)
OldFolderVar = tk.Entry(root, width = 70)
OldFolderVar.grid(row = 11, column = 2)
OldFolderButton = tk.Button(root, text = "Browse", command = OldFolderBrowser).grid(row = 11, column = 3)

NewFolderText = tk.Label(root, text = "New Config Folder:").grid(row = 12, column = 1)
NewFolderVar = tk.Entry(root, width = 70)
NewFolderVar.grid(row = 12, column = 2)
NewFolderButton = tk.Button(root, text = "Browse", command = NewFolderBrowser).grid(row = 12, column = 3)

Status = tk.Label(root, text = "Ready")
Status.grid(row = 20, column = 0, columnspan = 5)

StartButton = tk.Button(root, text = "Start", command = Start)
StartButton.grid(row = 31, column = 0, columnspan = 5)

root.mainloop()