$logCategories = @("Application", "Security", "System")

foreach ($log in $logCategories) {
    $beforeCount = (wevtutil qe $log /c:1 /rd:true /f:text 2>$null).Count

    Write-Host "Clearing $log logs... ($beforeCount entries)"

    wevtutil cl $log

    if ($?) {
        Write-Host "$log logs cleared successfully! ($beforeCount logs removed)"
    } else {
        Write-Host "Failed to clear $log logs!"
    }
}

Write-Host "Windows Logs have been cleared successfully!"
