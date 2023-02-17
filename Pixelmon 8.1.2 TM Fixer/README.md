# PixelmonCustomization
## Pixelmon 8.1.2 TM Fixer
This script corrects an "issue" with Pixelmon 8.1.2 where pokemon can't learn from TMs due to the introduction of TRs. This isn't relevant for later versions of Pixelmon.
The script requires stats folders from Pixelmon 7.3.1 and Pixelmon 8.1.2. Generate and rename/move the folder in Pixelmon 7.3.1, then generate the folder in Pixelmon 8.1.2

### To generate a Pixelmon stats folder:
* Modify the following values in the pixelmon config ("./config/pixelmon.HOCON"), then run pixelmon:
  * useExternalJSONFilesStats=true	#This must remain enabled for the changes to take effect.

### To use the script the first time, you will need to:
* Modify "Pixelmon 8.1.2 TM Fixer.R" Line 7 to have the path to the Pixelmon 7.3.1 stats folder
* Modify "Pixelmon 8.1.2 TM Fixer.R" Line 8 to have the path to the Pixelmon 8.1.2 stats folder

