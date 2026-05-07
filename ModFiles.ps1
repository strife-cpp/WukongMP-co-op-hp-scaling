#!powershell.exe -ExecutionPolicy Bypass -File

# Edit this list to add/remove files that should be included in the mod zip. 
$modFiles = @(
    "ExampleMod.dll",
    "manifest.json"
)

$debugModFiles = @(
    "ExampleMod.pdb"
)
