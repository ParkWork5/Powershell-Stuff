function menu
{
$hostname = hostname

Write-Output "Hello you are running S^3 on $hostname"
Write-Output "Before running ensure all computers can use WinRM and support =< Powershell 3 "
Write-Output "1. Single AD Computer"
Write-Output "2. Demo Mode"
Write-Output "3. Run on all AD Computers"

$selection = Read-Host -Prompt "Selection?"

if($selection -eq 1)
{
}
elseif($selection -eq 2)
{

antivirus
}
elseif($selection -eq 3)
{
}
}



function antiVirusChunk()
{
param($product,$pathExe,$reportingExe,$timeStamp,$defStatus,$rtStatus,$computerIP)

$antiVirusChunk = New-Object PSObject

$antiVirusChunk | Add-Member -type NoteProperty -Name ProductName -Value $product
$antiVirusChunk | Add-Member -type NoteProperty -Name ProductExePath -Value $pathExe
$antiVirusChunk | Add-Member -type NoteProperty -Name ReportingExePath -Value $reportingExe
$antiVirusChunk | Add-Member -type NoteProperty -Name Timestamp -Value $timeStamp
$antiVirusChunk | Add-Member -type NoteProperty -Name DefinitionStatus -Value $defStatus
$antiVirusChunk | Add-Member -type NoteProperty -Name RealTimeStatus -Value $rtStatus
$antiVirusChunk | Add-Member -type NoteProperty -Name ComputerIP -Value $computerIP 

return $antiVirusChunk
}

function antiVirus
{

$arrayPosition = 0;
$antivirusProducts = @()
$action = Write-Output "A couple things happened. 1. Cant find class name 2. WinRm isnt working"
foreach ($computer in Get-ADComputer -Filter *)
{

  $dnsCompName = $computer.DNSHostName
  $currentAntivirus = Invoke-Command -ScriptBlock{ Get-CimInstance -ComputerName $dnsCompName -Namespace root/SecurityCenter2 -ClassName AntivirusProduct -ErrorAction SilentlyContinue }
  
  if($currentAntivirus -eq $null)
  {
  Write-Output $action
  }

  else
  {
   antiVirusChunk($currentAntivirus.displayName,$currentAntivirus.pathToSignedProductExe,$currentAntivirus.pathToSignedReportingExe,$currentAntivirus.timeStamp)
  }
}


}


function statusFind()
{
param($productState)
switch ($productState) { 
    "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"} 
    "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"} 
    "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
    "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"} 
    "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"} 
    "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"} 
    "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
    "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"} 
    "397568" {$defstatus = "Up to date"; $rtstatus = "Enabled"}
    "393472" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
default {$defstatus = "Unknown" ;$rtstatus = "Unknown"} 
}

$status = @()
$status += $defstatus
$status += $rtstatus

return $status
}

menu