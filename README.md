# Cowork-repair-tool
Windows repair utility for Claude Cowork
# Cowork Repair Tool for Windows

Automated PowerShell utility to diagnose and fix common Claude Cowork issues on Windows.

## What It Fixes

✅ **CoworkVMService stopped or not running** - Automatically starts the service  
✅ **Corrupted VM bundle files** - Detects and offers to delete/rebuild  
✅ **Automatic path detection** - Works with Microsoft Store installation  
✅ **One-click repair** - Just run the shortcut

## Requirements

- Windows 10 or Windows 11
- Claude Desktop (Microsoft Store version)
- PowerShell
- Administrator privileges

## Installation

### Method 1: Desktop Shortcut (Recommended)

1. **Download** `CoworkRepair.ps1` from this repository (click the file → Download button)

2. **Save it to your Desktop**

3. **Create a shortcut:**
   - Right-click on Desktop → New → Shortcut
   - **Target:** `powershell.exe -NoExit -ExecutionPolicy Bypass -File "C:\Users\YOUR_USERNAME\Desktop\CoworkRepair.ps1"`
   - **Name it:** `Fix Cowork`
   - Click OK

4. **Set to run as administrator:**
   - Right-click the shortcut → Properties
   - Click "Advanced" button
   - Check ✅ "Run as administrator"
   - Click OK → OK

5. **Run it:** Double-click "Fix Cowork" whenever Cowork stops working

### Method 2: Direct PowerShell

1. Download `CoworkRepair.ps1`
2. Right-click it → "Run with PowerShell"
3. Click "Yes" when prompted for administrator access

## What It Does

### Check 1: Service Status
- Checks if CoworkVMService is running
- Automatically starts it if stopped
- Reports if service doesn't exist (not installed)

### Check 2: VM Bundle Health
- Locates VM bundle in Microsoft Store app path
- Checks for required files (rootfs.vhdx, sessiondata.vhdx)
- Detects corrupted or missing files
- Offers to delete corrupted bundle (Claude will redownload automatically)

### Check 3: Results
- Shows clear status for each check
- Provides actionable recommendations
- Leaves window open so you can read results

## Common Issues This Fixes

| Problem | Solution |
|---------|----------|
| "sdk-daemon not connected" | Restarts CoworkVMService |
| Cowork stuck on "Sending message..." | Restarts service |
| "Failed to start Claude's workspace" | Detects corrupted VM bundle |
| Random Cowork failures | Full diagnostic check |

## Background

Created while troubleshooting issues documented in:
- [Issue #25513](https://github.com/anthropics/claude-code/issues/25513) - VPN incompatibility
- [Issue #25808](https://github.com/anthropics/claude-code/issues/25808) - Folder selection issues

This tool helps users recover from common Cowork failures without reinstalling Claude Desktop.

## Limitations

⚠️ **This is a workaround, not a fix.** The underlying issues should be addressed by Anthropic.

This tool cannot fix:
- VPN routing issues (see #25513)
- Folder selection/mounting bugs (see #25808)
- Windows Firewall blocks
- Network connectivity problems

## Contributing

Found a bug or want to improve the tool? Open an issue or submit a pull request!

## License

MIT License - Free to use and modify

## Disclaimer

This is a community tool, not officially supported by Anthropic. Use at your own risk.
