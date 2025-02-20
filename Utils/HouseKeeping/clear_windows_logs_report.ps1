$logFilePath = "C:\Users\admin-app\Documents\Utils\HouseKeeping\Logs\log_cleanup_report_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# 1. Check the storage of C Disk
"Clear Windows Event Logs Report - $(Get-Date)" | Out-File -FilePath $logFilePath -Append

$diskSpace = Get-PSDrive -Name C
$freeSpaceGB = [math]::Round($diskSpace.Free / 1GB)

if ($freeSpaceGB -lt 0.5) {
    Write-Host "C drive is low on space ($freeSpaceGB GB), unable to access Service Center or Service Studio."
    "C drive is low on space ($freeSpaceGB GB), unable to proceed with the process." | Out-File -FilePath $logFilePath -Force
} else {
    Write-Host "C drive has sufficient space ($freeSpaceGB GB), proceeding with the process."
    "C drive has sufficient space ($freeSpaceGB GB)." | Out-File -FilePath $logFilePath -Force
}

# 2. Clear Windows Event Logs
$logCategories = @("Application", "Security", "System")

foreach ($log in $logCategories) {
    $beforeCount = (wevtutil qe $log /c:1 /rd:true /f:text 2>$null).Count

    $message = "Clearing $log logs... ($beforeCount entries)"
    $message | Out-File -FilePath $logFilePath -Append

    wevtutil cl $log

    if ($?) {
        $successMessage = "$log logs cleared successfully! ($beforeCount logs removed)"
        $successMessage | Out-File -FilePath $logFilePath -Append
    } else {
        $failureMessage = "Failed to clear $log logs!"
        $failureMessage | Out-File -FilePath $logFilePath -Append
    }
}

"Windows Logs have been cleared successfully!" | Out-File -FilePath $logFilePath -Append
Write-Host "Windows Logs have been cleared and logged to: $logFilePath"