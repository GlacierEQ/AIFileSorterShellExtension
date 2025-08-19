#!/bin/bash

# AI File Sorter - Linux Build Script (for cross-platform development)
# This script prepares the project structure and validates files

set -e

echo "============================================================"
echo "       AI File Sorter - Project Preparation                "
echo "============================================================"
echo

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$PROJECT_DIR/Release"

echo "1. Validating project structure..."

# Check essential files
REQUIRED_FILES=(
    "AIFileSorterShellExtension.csproj"
    "AIFileSorterShellExtension.sln"
    "AISorterShellExtension.cs"
    "AIFileSorterService.cs"
    "CursorManager.cs"
    "Extensions.cs"
    "Properties/AssemblyInfo.cs"
    "packages.config"
    "app.config"
    "AIFileSorterKey.snk"
    "generative.png"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo "   [OK] Found: $file"
    else
        echo "   [ERROR] Missing: $file"
        exit 1
    fi
done

echo "2. Checking installer files..."

INSTALLER_FILES=(
    "Installer/Install.ps1"
    "Installer/Uninstall.ps1"
    "Installer/README.txt"
    "Install-Extension.ps1"
    "Uninstall-Extension.ps1"
)

for file in "${INSTALLER_FILES[@]}"; do
    if [ -f "$PROJECT_DIR/$file" ]; then
        echo "   [OK] Found: $file"
    else
        echo "   [WARNING] Missing: $file"
    fi
done

echo "3. Creating output directory structure..."

mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/Source"
mkdir -p "$OUTPUT_DIR/Installer"
mkdir -p "$OUTPUT_DIR/Documentation"

echo "   [OK] Created output directories"

echo "4. Copying source files..."

# Copy source files
cp -r "$PROJECT_DIR"/*.cs "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/*.csproj "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/*.sln "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/packages.config "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/app.config "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/AIFileSorterKey.snk "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/Properties "$OUTPUT_DIR/Source/" 2>/dev/null || true
cp -r "$PROJECT_DIR"/generative.png "$OUTPUT_DIR/Source/" 2>/dev/null || true

echo "   [OK] Copied source files"

echo "5. Copying installer files..."

# Copy installer files
cp -r "$PROJECT_DIR"/Installer/* "$OUTPUT_DIR/Installer/" 2>/dev/null || true
cp "$PROJECT_DIR"/Install-Extension.ps1 "$OUTPUT_DIR/Installer/" 2>/dev/null || true
cp "$PROJECT_DIR"/Uninstall-Extension.ps1 "$OUTPUT_DIR/Installer/" 2>/dev/null || true

echo "   [OK] Copied installer files"

echo "6. Copying documentation..."

cp "$PROJECT_DIR"/README.md "$OUTPUT_DIR/Documentation/" 2>/dev/null || true

echo "   [OK] Copied documentation"

echo "7. Creating project summary..."

cat > "$OUTPUT_DIR/ProjectSummary.txt" << EOF
AI File Sorter Shell Extension - Project Summary
================================================

Build Date: $(date)
Project Directory: $PROJECT_DIR
Output Directory: $OUTPUT_DIR

Project Structure:
- Source/: Contains all C# source files and project files
- Installer/: Contains installation scripts and pre-built binaries
- Documentation/: Contains README and documentation files

Key Components:
- AISorterShellExtension.cs: Main shell extension class
- AIFileSorterService.cs: AI-powered file sorting service
- CursorManager.cs: Windows cursor management utilities
- Extensions.cs: Helper extension methods

Dependencies:
- .NET Framework 4.7.2
- SharpShell (Windows Shell Extension framework)
- Newtonsoft.Json (JSON processing)
- System.Text.Json (Modern JSON processing)
- OpenRouter API (AI language model access)

Installation:
1. Build the project in Visual Studio (Release mode)
2. Run Install-Extension.ps1 as Administrator
3. Or use the pre-built installer in the Installer/ directory

For Windows deployment:
- Use Deploy.ps1 script on Windows with Visual Studio/MSBuild
- Or use the pre-built binaries in the Installer/ directory

EOF

echo "   [OK] Created project summary"

echo
echo "============================================================"
echo "Project preparation completed successfully!"
echo "Output directory: $OUTPUT_DIR"
echo "============================================================"
echo
echo "Next steps for Windows deployment:"
echo "1. Transfer files to a Windows machine with Visual Studio"
echo "2. Run Deploy.ps1 to build and package the project"
echo "3. Test the installer on target Windows systems"
echo "4. Distribute the resulting ZIP package"
echo

# Create a simple file listing
echo "8. Creating file inventory..."

find "$OUTPUT_DIR" -type f | sort > "$OUTPUT_DIR/FileInventory.txt"
echo "   [OK] Created file inventory"

echo "Project is ready for Windows build and deployment!"