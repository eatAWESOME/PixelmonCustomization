# PixelmonCustomization
## Pixelmon Custom NPC Shops
This script is designed to make editing Pixelmon .json files relating to shopkeepers easier by making edits through .xlsx files.
The script will create custom shops with custom items, including allowing for custom items to be sold (to any shopkeeper).
The script will also create a shopkeeper for each type that sells all TMs/HMs/TRs for that type.
The script creates a copy of the original files with names beginning with original (e.g. "originalshopItems.json") for backup purposes (if using 8.X.X).

This script is compatible with previous versions of pixelmon that require modifying external JSON files and with new versions (9.X.X), where changes are made via datapacks.
Compatability with old versions of pixelmon has not been tested, but anything that follows the external JSON format used in 8.X.X should be compatible.
Be sure to enter the correct version information before running the script to ensure the correct files are located and modified.

### To use the script the first time, you will need to:
* If using Pixelmon version 8.X.X (with external JSON files), modify the following values in the pixelmon config ("./config/pixelmon.HOCON"), then run pixelmon:
  * useExternalJSONFilesNPCs=true	#This must remain enabled to use custom shopkeepers and items
  * useExternalJSONFilesMoves=true	#This can be disabled after the .json files are generated.
* If using Pixelmon version 9.X.X (no external JSON files):
  * Rename the Pixelmon mod .jar file to end in .zip (change file type)
  * Extract Pixelmon .zip to a folder
  * Modify "Pixelmon Custom NPC Shop.R" Line 18 to have the path to the "./world/datapacks" folder
* Modify "Pixelmon Custom NPC Shop.R" Line 14 to have the version selection ("8" for version 8.X.X or "9" for version 9.X.X)
* Modify "Pixelmon Custom NPC Shop.R" Line 15 to have the path to the Pixelmon folder (For version 9.X.X, this is the "./data/pixelmon" folder)
* Modify "Pixelmon Custom NPC Shop.R" Line 16 to have the path to the Custom Items.xlsx
* Modify "Pixelmon Custom NPC Shop.R" Line 17 to have the path to the Custom Shopkeepers.xlsx

### Using the script:	
* Add items that need to be customized to the "Custom Items.xlsx" file. See https://pixelmonmod.com/wiki/NPC_JSONs#shopItems.json for more details.
  * Item Class - Not required, but useful for sorting
  * Item Name - Not required, but helpful for identification
  * name - Minecraft item id (e.g. minecraft:diamond)
  * itemData - itemData value of item (e.g. 13 for Green Wool when minecraft:wool is input as name). Only required when relevant and not zero
  * buy - Price to buy
  * sell - Price to sell
  * id - Unique id for Pixelmon .json files (e.g. Galar: Thunderbolt). Only required when multiple items exist with the same item id
  * nbtData - nbtData for custom items (e.g. {display:{Name:\"Shiny Token\"},ench:[{id:51,lvl:1}]})
* Add items for shops in the "Custom Shopkeepers.xlsx" file.
  * Row 1: Shop Name
  * Rows 2+:
    * If id is not required: Minecraft item id (e.g. minecraft:diamond) 
    * If id is required: the format is Minecraft item id + id (e.g. minecraft:diamondshinytoken)
* Run script