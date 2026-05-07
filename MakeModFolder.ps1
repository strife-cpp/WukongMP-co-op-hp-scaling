#!powershell.exe -ExecutionPolicy Bypass -File

param (
    [string] $Configuration
)

# Check params
if (-not $Configuration)
{
    Write-Host "Usage: .\PackageMod.ps1 <Debug|Release>"
    Exit 1
}

# Source the mod file list
. ./ModFiles.ps1

# Find .sln files
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$solutionFiles = Get-ChildItem -Path $scriptDir -Filter *.sln

# Check if exactly one .sln file was found
if ($solutionFiles.Count -eq 1) {
    $solutionPath = $solutionFiles[0].FullName
} else {
    Write-Host "Error: Expected exactly one .sln file in $scriptDir, found $($solutionFiles.Count)."
    Exit 1
}

# Build solution
Write-Output "Building solution $solutionPath in configuration $Configuration..."
$buildOutput = dotnet build $solutionPath -c $Configuration -v minimal /t:Rebuild | Tee-Object -FilePath 'build.log'

# Prepare temporary output directory
$outputRoot = Join-Path $scriptDir 'Output'
if (-not (Test-Path $outputRoot))
{
    New-Item -ItemType Directory -Path $outputRoot -Force | Out-Null
} else {
    Get-ChildItem $outputRoot -Recurse | Remove-Item -Force -Recurse
}

# Extract solution name from path
$solutionName = [System.IO.Path]::GetFileNameWithoutExtension($solutionPath)

$destRoot = Join-Path $outputRoot $solutionName
New-Item -ItemType Directory -Path $destRoot -Force | Out-Null

# Copy each file from the build output that is in $modFiles to the output directory, preserving subdirectory structure
$buildDir = Join-Path $scriptDir "$solutionName/bin/$Configuration/netstandard2.0"

$allFiles = $modFiles
if ($Configuration -eq "Debug")
{
    $allFiles += $debugModFiles
}

foreach ($file in $allFiles)
{
    $sourceFile = Join-Path -Path $buildDir -ChildPath $file
    $destFile = Join-Path -Path $destRoot -ChildPath $file

    if (Test-Path -Path $sourceFile)
    {
        # Ensure destination directory exists
        $destDir = Split-Path -Parent $destFile
        if (-not (Test-Path -Path $destDir))
        {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }

        Copy-Item -Path $sourceFile -Destination $destFile -Force
        Write-Output "Copied $file to output directory."
    }
    else
    {
        Write-Warning "Warning: Source file not found: $sourceFile"
    }
}

# Open explorer to the output directory
if ($PSVersionTable.PSEdition -eq 'Core')
{
    Start-Process "explorer.exe" -ArgumentList $outputRoot
}
else
{
    Invoke-Item $outputRoot
}
