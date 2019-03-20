# Grab basic hardware info about host

function physicalInfo()
{

Write-Output "Physical Info about host"



Write-Output "========================================================"
Write-Output "CPU"
Get-CimInstance -ClassName Win32_Processor | select -Property Manufacturer, DeviceID, LoadPercentage | Out-Host  
Write-Output "========================================================"
Write-Output "RAM"
Get-CimInstance -ClassName Win32_PhysicalMemory | select -Property  BankLabel, Speed, Tag, PartNumber | Out-Host
Write-Output "========================================================"
Write-Output "Network Adapters"
Get-NetAdapter | select -Property Name, Status, MACAddress | Out-Host
Write-Output "========================================================"
Write-Output "Internal Storage Devices"
Get-CimInstance -ClassName Win32_DiskDrive | select -Property Name, Model, Status, DeviceID, Size | Out-Host
Write-Output "========================================================"
Write-Output "Temp Sensors"
$tempOut = Get-CimInstance -ClassName CIM_Sensor

if ($tempOut -eq $null)
{
Write-Output "No temp sensors to access"
}
else
{
Write-Output $tempOut

}
Write-Output "========================================================"
Read-Host -Prompt "Done?"







}










$hostname = hostname
Write-Output "Grabbing info for host '$hostname'"

physicalInfo;

 











