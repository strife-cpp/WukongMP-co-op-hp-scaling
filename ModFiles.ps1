#!powershell.exe -ExecutionPolicy Bypass -File

# Edit these lists to specify files that should be included in the mod folder.

# Copied from build folder (bin/Configuration/netstandard2.0)
$buildFiles = @(
    "WukongMp.Coop.dll",
    "manifest.json"
)

# Copied from the "Content" folder to mod folder root
$contentFiles = @(
    "ArchiveSaveFile.1.sav"
)

# Copied from build folder to mod folder root (only in Debug builds)
$debugBuildFiles = @(
    "WukongMp.Coop.pdb"
)
