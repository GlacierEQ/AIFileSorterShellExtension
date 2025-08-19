#Requires -RunAsAdministrator

param(
    [switch]$BuildOnly,
    [switch]$PackageOnly,
    [string]$OutputPath = ".\Release"
)

$ErrorActionPreference = "Stop"

Write-Host "============================================================" -ForegroundColor Green
Write-Host "       AI File Sorter - Deployment Script                  " -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host

# Get script directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectFile = Join-Path $scriptDir "AIFileSorterShellExtension.csproj"
$solutionFile = Join-Path $scriptDir "AIFileSorterShellExtension.sln"

# Verify project files exist
if (-not (Test-Path $projectFile)) {
    Write-Host "ERROR: Project file not found: $projectFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $solutionFile)) {
    Write-Host "ERROR: Solution file not found: $solutionFile" -ForegroundColor Red
    exit 1
}

# Create output directory
$outputDir = Join-Path $scriptDir $OutputPath
if (-not (Test-Path $outputDir)) {
    New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
    Write-Host "Created output directory: $outputDir" -ForegroundColor Green
}

if (-not $PackageOnly) {
    Write-Host "1. Building project..." -ForegroundColor Cyan
    
    # Clean previous builds
    Write-Host "   Cleaning previous builds..." -ForegroundColor Yellow
    if (Test-Path "bin") { Remove-Item -Path "bin" -Recurse -Force }
    if (Test-Path "obj") { Remove-Item -Path "obj" -Recurse -Force }
    
    # Restore NuGet packages
    Write-Host "   Restoring NuGet packages..." -ForegroundColor Yellow
    & nuget restore $solutionFile
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   [WARNING] NuGet restore failed, trying with dotnet..." -ForegroundColor Yellow
        & dotnet restore $solutionFile
    }
    
    # Build in Release mode
    Write-Host "   Building in Release mode..." -ForegroundColor Yellow
    & msbuild $projectFile /p:Configuration=Release /p:Platform="Any CPU" /p:OutputPath="$outputDir\bin\"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   [ERROR] Build failed!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "   [OK] Build completed successfully" -ForegroundColor Green
}

if (-not $BuildOnly) {
    Write-Host "2. Creating deployment package..." -ForegroundColor Cyan
    
    # Create installer directory
    $installerDir = Join-Path $outputDir "Installer"
    if (Test-Path $installerDir) {
        Remove-Item -Path $installerDir -Recurse -Force
    }
    New-Item -Path $installerDir -ItemType Directory -Force | Out-Null
    
    # Copy main DLL and dependencies
    $binDir = Join-Path $outputDir "bin"
    $mainDll = Join-Path $binDir "AIFileSorterShellExtension.dll"
    
    if (-not (Test-Path $mainDll)) {
        Write-Host "   [ERROR] Main DLL not found: $mainDll" -ForegroundColor Red
        exit 1
    }
    
    # Copy essential files
    $filesToCopy = @(
        "AIFileSorterShellExtension.dll",
        "AIFileSorterShellExtension.dll.config",
        "Newtonsoft.Json.dll",
        "SharpShell.dll",
        "System.Text.Json.dll",
        "System.Runtime.CompilerServices.Unsafe.dll",
        "System.Text.Encodings.Web.dll",
        "System.Memory.dll",
        "System.Buffers.dll"
    )
    
    foreach ($file in $filesToCopy) {
        $sourcePath = Join-Path $binDir $file
        $destPath = Join-Path $installerDir $file
        
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "   [OK] Copied: $file" -ForegroundColor Green
        } else {
            Write-Host "   [WARNING] File not found: $file" -ForegroundColor Yellow
        }
    }
    
    # Copy icon
    $iconSource = Join-Path $scriptDir "generative.png"
    if (Test-Path $iconSource) {
        Copy-Item -Path $iconSource -Destination $installerDir -Force
        Write-Host "   [OK] Copied: generative.png" -ForegroundColor Green
    }
    
    # Copy installation scripts
    $installScript = Join-Path $scriptDir "Installer\Install.ps1"
    $uninstallScript = Join-Path $scriptDir "Installer\Uninstall.ps1"
    $readmeFile = Join-Path $scriptDir "Installer\README.txt"
    
    if (Test-Path $installScript) {
        Copy-Item -Path $installScript -Destination $installerDir -Force
        Write-Host "   [OK] Copied: Install.ps1" -ForegroundColor Green
    }
    
    if (Test-Path $uninstallScript) {
        Copy-Item -Path $uninstallScript -Destination $installerDir -Force
        Write-Host "   [OK] Copied: Uninstall.ps1" -ForegroundColor Green
    }
    
    if (Test-Path $readmeFile) {
        Copy-Item -Path $readmeFile -Destination $installerDir -Force
        Write-Host "   [OK] Copied: README.txt" -ForegroundColor Green
    }
    
    # Create ZIP package
    Write-Host "3. Creating ZIP package..." -ForegroundColor Cyan
    $zipPath = Join-Path $outputDir "AIFileSorter-Installer.zip"
    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }
    
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::CreateFromDirectory($installerDir, $zipPath)
    
    Write-Host "   [OK] Created: $zipPath" -ForegroundColor Green
    
    # Create version info
    $versionInfo = @"
AI File Sorter Shell Extension
Build Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Version: 1.0.0.0
Platform: Any CPU
Configuration: Release

Files included:
$(Get-ChildItem $installerDir | ForEach-Object { "- $($_.Name)" } | Out-String)
"@
    
    $versionFile = Join-Path $outputDir "BuildInfo.txt"
    Set-Content -Path $versionFile -Value $versionInfo
    Write-Host "   [OK] Created: BuildInfo.txt" -ForegroundColor Green
}

Write-Host
Write-Host "============================================================" -ForegroundColor Green
Write-Host "Deployment completed successfully!" -ForegroundColor Green
Write-Host "Output directory: $outputDir" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Test the installer on a clean Windows machine" -ForegroundColor White
Write-Host "2. Verify the shell extension appears in Explorer context menu" -ForegroundColor White
Write-Host "3. Test file sorting functionality" -ForegroundColor White
Write-Host "4. Distribute the ZIP file to end users" -ForegroundColor White
Write-Host