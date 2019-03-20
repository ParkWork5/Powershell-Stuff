
function antiVirus
{
$antivirusProducts = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct

$numProducts = $antivirusProducts.count

for($i=0; $i -lt $numProducts; $i++)
{

switch ($antivirusProducts.Get($i).productState) { 
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

$currentProduct = $antivirusProducts.Get($i).displayName
$pathExe = $antivirusProducts.Get($i).pathToSignedProductExe
$reportingExe = $antivirusProducts.Get($i).pathToSignedReportingExe
$timestamp = $antivirusProducts.Get($i).timestamp

Write-Output "======================$currentProduct========================"
Write-Output "Product: $currentProduct "
Write-Output "Real Time Protection: $rtstatus "
Write-Output "Definitions: $defstatus "
Write-Output "Path to Exe: $pathExe" 
Write-Output "Path to Reporting Exe: $reportingExe" 
Write-Output "Timestamp: $timestamp"
Write-Output "=============================================================" 

}


}

antiVirus