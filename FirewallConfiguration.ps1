function menu()
{
$hostname = hostname
Write-Output "Hello you are modifying firewall rules on $hostname"
Write-Output "1. Get current active firewall rules(Present Properties)"
Write-Output "2. Get current active firewall rules(Custom)"

$selection = Read-Host -Prompt "Selection?"



if($selection -eq 1)
{
getRules
}
if($selection -eq 2)
{
getRulesCustom
}
}

function getRules()
{
 $activeRules = Get-NetFirewallRule -PolicyStore ActiveStore | Where-Object -Property Enabled -eq "True" | Select-Object -Property Name, DisplayName, Description, Group, Direction, Action, EdgeTraversalPolicy, PrimaryStatus, PolicyStoreSource

 for($i=0; $i -lt $activeRules.Count; $i++)
 {
  $Name = $activeRules.Get($i).Name
  $DisplayName = $activeRules.Get($i).DisplayName
  $Description = $activeRules.Get($i).Description
  $Direction = $activeRules.Get($i).Direction
  $Action = $activeRules.Get($i).Action
  $EdgeTraversal = $activeRules.Get($i).EdgeTraversalPolicy
  $Group = $activeRules.Get($i).Group
  $PrimaryStatus = $activeRules.Get($i).PrimaryStatus
  $PolicySource = $activeRules.Get($i).PolicyStoreSource

  Write-Output "==========================================="
  Write-Output "Name: $Name"
  Write-Output "Display Name: $DisplayName"
  Write-Output "Description: $Description"
  Write-Output "Group: $Group"
  Write-Output "Direction: $Direction"
  Write-Output "Action: $Action"
  Write-Output "Edge Traversal Policy: $EdgeTraversal"
  Write-Output "Primary Status: $PrimaryStatus"
  Write-Output "Policy Store Source: $PolicySource"
  Write-Output "==========================================="
  Write-Output " "
 }

 function getRulesCustom()
 {

 }

}




menu