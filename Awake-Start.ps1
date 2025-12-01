# Set UTF-8
chcp 65001
[console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Import Windows API
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NativeMethods {
    [DllImport("kernel32.dll")]
    public static extern uint SetThreadExecutionState(uint esFlags);
}
"@

# UInt32 constants
$ES_CONTINUOUS       = [uint32]2147483648  # 0x80000000
$ES_SYSTEM_REQUIRED  = [uint32]1
$ES_DISPLAY_REQUIRED = [uint32]2

# Script directory and files
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$stopFile  = Join-Path $scriptDir "stop.keep"
$logFile   = Join-Path $scriptDir "keep-awake.log"
$maxLines  = 500

# Log function
function Write-Log($text) {
    $time = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $line = "[$time] $text"
    Add-Content -Path $logFile -Value $line -Encoding UTF8

    # Keep only recent $maxLines
    if (Test-Path $logFile) {
        $lines = Get-Content -Path $logFile -Encoding UTF8
        if ($lines.Count -gt $maxLines) {
            $lines[-$maxLines..-1] | Set-Content -Path $logFile -Encoding UTF8
        }
    }
}

# Startup log
Write-Log "Keep-Awake started"

# Remove old stop file
if (Test-Path $stopFile) { Remove-Item $stopFile -Force }

# Loop to keep awake
$counter = 0
$updateInterval = 60 * 10  # every 120 seconds log a loop update

while ($true) {
    # Check stop file
    if (Test-Path $stopFile) {
        Write-Log "Keep-Awake stopped"
        Remove-Item $stopFile -Force
        exit
    }

    # Prevent lock screen
    [NativeMethods]::SetThreadExecutionState(
        $ES_CONTINUOUS -bor $ES_SYSTEM_REQUIRED -bor $ES_DISPLAY_REQUIRED
    ) | Out-Null

    # Loop update log
    $counter += 60
    if ($counter -ge $updateInterval) {
        Write-Log "Keep-Awake loop check | running"
        $counter = 0
    }

    Start-Sleep -Seconds 60
}
