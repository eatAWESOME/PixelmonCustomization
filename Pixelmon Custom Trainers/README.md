# PixelmonCustomization
## Pixelmon Custom Trainers
This script is designed to make editing the teams of trainers in Pixelmon easier by making edits through .xlsx files, then having those output to a poképaste.

This script was first created for Pixelmon 9.1.5. Compatability with older versions of pixelmon has not been tested, but anything that follows the poképaste format should be compatible.

### Required Packages:
* pandas

### Formatting the .xlsx file:
* Each Trainer is a sheet.
  * "Blank" and "Trainer Info" are ignored as sheet names
* The first column is the index, the remaining columns are for each pokemon, with the species being the header
* Required index values: Gender, Level, Ability, Held Item, Move 1, Move 2, Move 3, Move 4, IVs, EVs, Nature, Shiny, Growth, Happiness, Poke Ball
* Values follow the naming conventions used in the poképaste format (e.g. Sitrus Berry instead of pixelmon:sitrus_berry)
* See "Custom Trainers.xlsx" for examples

### Using the script:
* Run the script to start the GUI
* Enter the required variables
  * Trainer Excel: the .xlsx file to be used (following the formatting above)
* Press the run button