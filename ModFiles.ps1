#!powershell.exe -ExecutionPolicy Bypass -File

# Edit these lists to specify files that should be included in the mod folder.

# Copied from build folder (bin/Configuration/netstandard2.0)
$buildFiles = @(
    "WukongMp.Coop.dll"
)

# Copied from the "Content" folder to mod folder root
$contentFiles = @(
    "manifest.json",
    "ArchiveSaveFile.1.sav" # Prologue save files for starting a new game
)

# Copied from build folder to mod folder root (only in Debug builds)
$debugBuildFiles = @(
    "WukongMp.Coop.pdb"
)
