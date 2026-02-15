# Cowork Smart Repair Script - Microsoft Store Version
# Automatically detects and fixes common Cowork issues

$ErrorActionPreference = "SilentlyContinue"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Cowork Smart Repair Tool" -ForegroundColor Cyan
Write-Host "  (Microsoft Store Version)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check and start service
Write-Host "[1/3] Checking CoworkVMService..." -ForegroundColor Yellow
$service = Get-Service -Name "CoworkVMService"

if ($service.Status -eq "Stopped") {
    Write-Host "      Service is STOPPED - Starting now..." -ForegroundColor Yellow
    Start-Service -Name "CoworkVMService"
    Start-Sleep -Seconds 3
    $service = Get-Service -Name "CoworkVMService"
    if ($service.Status -eq "Running") {
        Write-Host "      SUCCESS: Service started" -ForegroundColor Green
    } else {
        Write-Host "      ERROR: Failed to start service" -ForegroundColor Red
    }
} else {
    Write-Host "      OK: Service is running" -ForegroundColor Green
}

Write-Host ""

# Step 2: Check VM bundle health (Microsoft Store location)
Write-Host "[2/3] Checking VM bundle health..." -ForegroundColor Yellow

$vmBundlePath = "$env:LOCALAPPDATA\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude\vm_bundles\claudevm.bundle"
$needsRebuild = $false
$reason = ""

if (-not (Test-Path $vmBundlePath)) {
    $needsRebuild = $true
    $reason = "VM bundle does not exist"
} else {
    $rootfsPath = "$vmBundlePath\rootfs.vhdx"
    $sessiondataPath = "$vmBundlePath\sessiondata.vhdx"
    
    if (-not (Test-Path $rootfsPath)) {
        $needsRebuild = $true
        $reason = "Missing rootfs.vhdx file"
    } elseif (-not (Test-Path $sessiondataPath)) {
        Write-Host "      WARNING: Missing sessiondata.vhdx" -ForegroundColor Yellow
        Write-Host "      OK: Core VM files present" -ForegroundColor Green
    } else {
        $rootfsAge = (Get-Date) - (Get-Item $rootfsPath).LastWriteTime
        if ($rootfsAge.TotalDays -gt 30) {
            Write-Host "      WARNING: VM bundle is old" -ForegroundColor Yellow
            Write-Host "      OK: VM bundle exists" -ForegroundColor Green
        } else {
            Write-Host "      OK: VM bundle appears healthy" -ForegroundColor Green
        }
    }
}

Write-Host ""

if ($needsRebuild) {
    Write-Host "[3/3] VM bundle needs rebuild" -ForegroundColor Yellow
    Write-Host "      Reason: $reason" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "      Delete and rebuild VM bundle? (Y/N)" -ForegroundColor White
    
    $choice = Read-Host "      "
    
    if ($choice -eq "Y" -or $choice -eq "y") {
        Write-Host ""
        Write-Host "      Closing Claude Desktop..." -ForegroundColor Yellow
        Stop-Process -Name "Claude" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        
        Write-Host "      Deleting VM bundle..." -ForegroundColor Yellow
        $vmBundlesRoot = "$env:LOCALAPPDATA\Packages\Claude_pzs8sxrjxfjjc\LocalCache\Roaming\Claude\vm_bundles"
        Remove-Item -Path $vmBundlesRoot -Recurse -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
        
        if (-not (Test-Path $vmBundlesRoot)) {
            Write-Host "      SUCCESS: VM bundle deleted" -ForegroundColor Green
        } else {
            Write-Host "      WARNING: Could not delete" -ForegroundColor Red
        }
    } else {
        Write-Host "      Skipped" -ForegroundColor Gray
    }
} else {
    Write-Host "[3/3] VM bundle check complete" -ForegroundColor Yellow
    Write-Host "      No rebuild needed" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Press any key to close..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
