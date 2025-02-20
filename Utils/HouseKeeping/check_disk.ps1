$diskSpace = Get-PSDrive -Name C
$freeSpaceGB = [math]::Round($diskSpace.Free / 1GB)

if ($freeSpaceGB -lt 0.5) {
    Write-Host "C drive is low on space ($freeSpaceGB GB), unable to access Service Center or Service Studio."
    exit
} else {
    Write-Host "C drive has sufficient space ($freeSpaceGB GB), proceeding with the process."
}
