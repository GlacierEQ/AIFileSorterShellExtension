# AI File Sorter - Deployment Guide

## Overview

This guide covers the complete deployment process for the AI File Sorter Shell Extension, from building the project to distributing it to end users.

## Prerequisites

### Development Environment
- Windows 10/11 (for building and testing)
- Visual Studio 2019 or later with C# support
- .NET Framework 4.7.2 SDK
- PowerShell 5.1 or later
- Administrator privileges (for installation and testing)

### Runtime Requirements (End Users)
- Windows 10/11
- .NET Framework 4.7.2 or higher
- Administrator privileges (for installation only)

## Project Structure

```
AIFileSorterShellExtension/
├── Source Files/
│   ├── AISorterShellExtension.cs      # Main shell extension
│   ├── AIFileSorterService.cs         # AI sorting service
│   ├── CursorManager.cs               # Cursor management
│   ├── Extensions.cs                  # Helper extensions
│   └── Properties/AssemblyInfo.cs     # Assembly metadata
├── Project Files/
│   ├── AIFileSorterShellExtension.csproj
│   ├── AIFileSorterShellExtension.sln
│   ├── packages.config                # NuGet dependencies
│   ├── app.config                     # Runtime configuration
│   └── AIFileSorterKey.snk           # Strong name key
├── Installation/
│   ├── Install-Extension.ps1          # Developer installation
│   ├── Uninstall-Extension.ps1        # Developer uninstallation
│   └── Installer/                     # End-user installer
│       ├── Install.ps1                # End-user installation
│       ├── Uninstall.ps1              # End-user uninstallation
│       └── Pre-built binaries/
└── Deployment/
    ├── Deploy.ps1                     # Automated build & package
    └── Build.sh                       # Cross-platform preparation
```

## Build Process

### Option 1: Automated Build (Recommended)

1. **Open PowerShell as Administrator** on Windows machine
2. **Navigate to project directory**:
   ```powershell
   cd C:\path\to\AIFileSorterShellExtension
   ```
3. **Run deployment script**:
   ```powershell
   .\Deploy.ps1
   ```

This will:
- Clean previous builds
- Restore NuGet packages
- Build in Release mode
- Create installer package
- Generate ZIP distribution

### Option 2: Manual Build

1. **Open Visual Studio**
2. **Load solution**: `AIFileSorterShellExtension.sln`
3. **Set configuration**: Release | Any CPU
4. **Restore NuGet packages**: Right-click solution → Restore NuGet Packages
5. **Build solution**: Build → Build Solution (Ctrl+Shift+B)
6. **Verify output**: Check `bin\Release\` for generated files

## Testing

### Pre-Deployment Testing

1. **Build verification**:
   ```powershell
   # Check if main DLL exists
   Test-Path "bin\Release\AIFileSorterShellExtension.dll"
   
   # Verify dependencies
   Get-ChildItem "bin\Release\" -Filter "*.dll"
   ```

2. **Installation test**:
   ```powershell
   # Install for testing
   .\Install-Extension.ps1
   
   # Test in Explorer (right-click on folder)
   # Look for "Sort Files" option
   
   # Uninstall after testing
   .\Uninstall-Extension.ps1
   ```

### Post-Deployment Testing

1. **Clean machine test**: Test installer on fresh Windows installation
2. **Context menu verification**: Ensure "Sort Files" appears in Explorer
3. **Functionality test**: Test actual file sorting with sample files
4. **Uninstall test**: Verify clean removal

## Distribution Package

The deployment creates a ZIP file containing:

```
AIFileSorter-Installer.zip
├── AIFileSorterShellExtension.dll     # Main extension
├── AIFileSorterShellExtension.dll.config
├── Newtonsoft.Json.dll                # JSON processing
├── SharpShell.dll                     # Shell extension framework
├── System.Text.Json.dll               # Modern JSON support
├── System.Runtime.CompilerServices.Unsafe.dll
├── System.Text.Encodings.Web.dll
├── System.Memory.dll
├── System.Buffers.dll
├── generative.png                     # Extension icon
├── Install.ps1                        # Installation script
├── Uninstall.ps1                      # Uninstallation script
└── README.txt                         # User instructions
```

## Installation Instructions (End Users)

### Installation
1. **Download** the ZIP file
2. **Extract** to a temporary folder
3. **Right-click** on `Install.ps1`
4. **Select** "Run with PowerShell"
5. **Allow** execution if prompted
6. **Follow** on-screen instructions

### First Use
1. **Right-click** on any folder in Explorer
2. **Select** "Settings..." from context menu
3. **Enter** OpenRouter API key
4. **Configure** web search option
5. **Test** by right-clicking and selecting "Sort Files"

### Uninstallation
1. **Navigate** to installation folder
2. **Right-click** on `Uninstall.ps1`
3. **Select** "Run with PowerShell"
4. **Follow** on-screen instructions

## Troubleshooting

### Common Build Issues

**Missing Strong Name Key**:
```powershell
# Generate new key if missing
sn -k AIFileSorterKey.snk
```

**NuGet Restore Failures**:
```powershell
# Clear NuGet cache
nuget locals all -clear
# Restore packages
nuget restore AIFileSorterShellExtension.sln
```

**Assembly Loading Issues**:
- Verify all dependencies are in output folder
- Check app.config binding redirects
- Ensure .NET Framework 4.7.2 is installed

### Common Installation Issues

**Context Menu Not Appearing**:
1. Restart Windows Explorer
2. Restart computer
3. Check Windows Event Log for errors
4. Verify COM registration

**Permission Errors**:
- Ensure running as Administrator
- Check UAC settings
- Verify file permissions

**API Key Issues**:
- Verify OpenRouter API key is valid
- Check internet connectivity
- Review application logs in `%APPDATA%\AIFileSorter\`

## Security Considerations

### Code Signing
- Consider code signing for production releases
- Use trusted certificate authority
- Sign both DLL and installer scripts

### API Key Security
- API keys are stored in Windows Registry (encrypted)
- Keys are not transmitted except to OpenRouter API
- No telemetry or data collection

### Permissions
- Extension requires Administrator privileges for installation only
- Runtime operation uses standard user permissions
- No network access except for AI API calls

## Version Management

### Assembly Versioning
Update version in `Properties\AssemblyInfo.cs`:
```csharp
[assembly: AssemblyVersion("1.0.0.0")]
[assembly: AssemblyFileVersion("1.0.0.0")]
```

### Release Notes
Maintain changelog for each release:
- New features
- Bug fixes
- Breaking changes
- Known issues

## Support and Maintenance

### Logging
Application logs are stored in:
- `%APPDATA%\AIFileSorter\AIFileSorter.log`
- `%APPDATA%\AIFileSorter\diagnostics\`

### Updates
- Uninstall previous version before installing new version
- Backup user settings if needed
- Test compatibility with new Windows updates

### Monitoring
- Monitor OpenRouter API usage and costs
- Track user feedback and issues
- Monitor Windows compatibility updates

## Deployment Checklist

### Pre-Release
- [ ] Code review completed
- [ ] All tests passing
- [ ] Version numbers updated
- [ ] Documentation updated
- [ ] Security review completed

### Build Process
- [ ] Clean build successful
- [ ] All dependencies included
- [ ] Strong name signing working
- [ ] Package creation successful
- [ ] File integrity verified

### Testing
- [ ] Developer machine testing
- [ ] Clean machine testing
- [ ] Multiple Windows versions tested
- [ ] Installation/uninstallation tested
- [ ] Core functionality verified

### Distribution
- [ ] ZIP package created
- [ ] Installation instructions updated
- [ ] Release notes prepared
- [ ] Support documentation ready
- [ ] Distribution channels prepared

### Post-Release
- [ ] Monitor for issues
- [ ] Collect user feedback
- [ ] Track API usage
- [ ] Plan next release cycle