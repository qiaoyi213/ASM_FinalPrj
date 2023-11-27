Remove-Item .\build\*
Remove-Item .\obj\*


$r1 = & ".\tools\assemble.ps1" | Select-Object -Last 1
if(!$r1) {
	Write-Output "Assemble Failed"
	exit
}
$r2 = & ".\tools\link.ps1" | Select-Object -Last 1
if(!$r2) {
	Write-Output "Link Failed"
	exit
}
Write-Output "BUILD SUCCESS!"

.\build\main.exe