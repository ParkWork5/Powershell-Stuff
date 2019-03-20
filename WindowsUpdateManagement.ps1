
function moduleCheck()
{

if (Get-module -ListAvailable -Name PSWindowsUpdate)
{
Write-Output "Module installed. Proceeding"
return $true
}
else{
Write-Output "Module PSWindowsUpdate is not installed. Please go download and place module in %WINDIR%\System32\WindowsPowerShell\v1.0\Modules"
Write-Output " "
return $false
}
}


function menu()
{
$hostname = hostname

Write-Output "Hello you are currently interacting with Windows Update on $hostname "
Write-Output "1. List current pending updates"
Write-Output "2. Search for installed Microsoft updates via KB number(May take a hot minute depending on # of updates)"
Write-Output "3. Search other non Microsoft installed update(s) via Title/Description"
Write-Output "4. Install all updates"
Write-Output "5. Install only Microsoft updates"
Write-Output "6. Install non Microsoft updates"
Write-Output "7. Install update(s) based on Title/Description"
Write-Output "8. Delete update based on KB Id"
$selection = Read-Host -Prompt "Selection?"
if($selection -eq 1)
{
pendingUpdates
}
elseif($selection -eq 2)
{
searchInstalledUpdates
}
elseif($selection -eq 3)
{
searchNonMicrosoft
}
elseif($selection -eq 4)
{
installUpdates(0);
}
elseif($selection -eq 5)
{
installUpdates(1);
}
elseif($selection -eq 6)
{
installUpdates(2);
}
elseif($selection -eq 7)
{
installUpdates(3);
}
elseif($selection -eq 8)
{
deleteUpdates
}
}

function pendingUpdates()
{
$pendingUpdates = Get-WUList

for($i=0; $i -lt $pendingUpdates.Count; $i++)
{
  $kb = $pendingUpdates.Get($i).KB
  $size = $pendingUpdates.Get($i).Size
  $status = $pendingUpdates.Get($i).Status
  $title = $pendingUpdates.Get($i).Title

  Write-Output "============================"
  Write-Output "KB: $kb"
  Write-Output "Size: $size"
  Write-Output "Status: $status"
  Write-Output "Title: $title"
  Write-Output "============================"
  Write-Output "  "
}
}

function searchInstalledUpdates
{
$installedUpdates = Get-WUHistory 

$kbID = Read-Host -Prompt "Enter the KB ID include KB in numberat start"

$filteredUpdates = $installedUpdates | Where-Object {$_.Title -match $kbID} | Select-Object *

for($i; $i -lt $filteredUpdates.Count; $i++)
{
$resultCode = $filteredUpdates.Get($i).ResultCode
$date = $filteredUpdates.Get($i).Date
$title = $filteredUpdates.Get($i).Title
$description = $filteredUpdates.Get($i).Description

if($resultCode -eq 2)
{
$resultCode = "Installed Successfully"
}
else
{
$resultCode = "Install error look at logs"
}
Write-Output "========================"
Write-Output "KB: $kbID"
Write-Output "Result Code: $resultCode"
Write-Output "Date: $date"
Write-Output "Title: $title"
Write-Output "Description: $description"
Write-Output "========================"
Write-Output " "
}

}

function searchNonMicrosoft()
{
$installedUpdates = Get-WUHistory 

$selection = Read-Host -Prompt "Searching by title or description?"

if($selection -eq "description" -or $selection -eq "Description" -or $selection -eq "d")
{
$description = Read-Host -Prompt "Description?"
$filteredUpdates = $installedUpdates | Where-Object {$_.Description -match $description} | Select-Object *
}
else
{

$title = Read-Host -Promt "Title?"
$filteredUpdates = $installedUpdates | Where-Object {$_.Title -match $title} | Select-Object *
}

for($i; $i -lt $filteredUpdates.Count; $i++)
{
$resultCode = $filteredUpdates.Get($i).ResultCode
$date = $filteredUpdates.Get($i).Date
$title = $filteredUpdates.Get($i).Title
$description = $filteredUpdates.Get($i).Description

if($resultCode -eq 2)
{
$resultCode = "Installed Successfully"
}
else
{
$resultCode = "Install error look at logs"
}
Write-Output "========================"
Write-Output "Result Code: $resultCode"
Write-Output "Date: $date"
Write-Output "Title: $title"
Write-Output "Description: $description"
Write-Output "========================"
Write-Output " "
}

}

function installUpdates([int] $option)
{
if($option -eq 0)
{
Get-WUInstall
}
elseif($option -eq 1)
{
Get-WUInstall -MicrosoftUpdate -Verbose
}
elseif($option -eq 2)
{
Get-WUInstall | Where-Object  {$_.Title -ne "Microsoft"} | Select-Object *
}
elseif($option -eq 3)
{
$selection = Read-Host -Prompt "Searching by title or description?"

if($selection -eq "description" -or $selection -eq "Description" -or $selection -eq "d")
{
$description = Read-Host -Prompt "Description?"
Get-WUInstall | Where-Object {$_.Description -match $description} | Select-Object *  

}
else
{

$title = Read-Host -Promt "Title?"
Get-WUInstall | Where-Object {$_.Title -match $title} | Select-Object *
}
}

}

deleteUpdates
{
$kbId = Read-Host -Prompt "Enter kb id of update(s) you want to delete"

Get-WUUninstall -KBArticleID $kbId
}



$status = moduleCheck
if ($status -eq $true)
{
Write-Output "Proceeding"
menu
}
else
{

}