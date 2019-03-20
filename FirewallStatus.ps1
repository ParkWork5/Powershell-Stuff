function checkFirewall([string] $hostname)
{

$domainFirewall = Invoke-Command -ScriptBlock {netsh advfirewall show domain} 
$publicFirewall = Invoke-Command {netsh advfirewall show public}
$privateFirewall = Invoke-Command {netsh advfirewall show private}

Write-Output "========================DOMAIN FIREWALL===================================="
Write-Output $domainFirewall | findstr /C:"State" /C:"Firewall Policy" /C:"LocalFirewallRules" /C:"LocalConSecRules" /C:"RemoteManagement" /C:"LogAlowedConnections" /C:"LogDroppedConnections" /C:"FileName" 
Write-Output "==========================================================================="

Write-Output " "
Write-Output "========================PUBLIC FIREWALL===================================="
Write-Output $publicFirewall | findstr /C:"State" /C:"Firewall Policy" /C:"LocalFirewallRules" /C:"LocalConSecRules" /C:"RemoteManagement" /C:"LogAlowedConnections" /C:"LogDroppedConnections" /C:"FileName" 
Write-Output "==========================================================================="

Write-Output " "
Write-Output "========================PUBLIC FIREWALL===================================="
Write-Output $privateFirewall | findstr /C:"State" /C:"Firewall Policy" /C:"LocalFirewallRules" /C:"LocalConSecRules" /C:"RemoteManagement" /C:"LogAlowedConnections" /C:"LogDroppedConnections" /C:"FileName" 
Write-Output "==========================================================================="

}

$hostname = hostname
checkFirewall($hostname);