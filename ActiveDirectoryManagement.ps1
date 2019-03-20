function newUser()
{
$name = Read-Host -Prompt "Name of new user?"
$group = Read-Host -Prompt "Group to assign user to?(I think User is default)"
$password = Read-Host -AsSecureString -Prompt "Password for user(atleast 8 characters etc)"

New-ADUser -Name $name -Type $group -ChangePasswordAtLogon $true -Enabled $true -AccountPassword $password 
}

function addToGroup()
{
$name = Read-Host -Prompt "Name of user(s)?"
$group = Read-Host -Prompt "Group to add user(s) to"
Add-ADGroupMember -Identity $group -Members $name
}

function newUserPlus()
{
$name = Read-Host -Prompt "Name of new user?"
$group = Read-Host -Prompt "Group to assign user to?(I think User is default)"
$ou = Read-Host -Prompt "Name of OU to assign user(s) to"
$password = Read-Host -AsSecureString -Prompt "Password for user(atleast 8 characters etc)"

New-ADUser -Name $name -Type $group -Path "OU=$ou" -ChangePasswordAtLogon $true -Enabled $true -AccountPassword $password 
}

function newGroup()
{
$groupName = Read-Host -Prompt "Name of group?"
$scope = Read-Host -Prompt "Scope of group?(Local, Global, or Universal)"
$category = Read-Host -Prompt "Group category?(Security or Distrubition)"
$description = Read-Host -Prompt "Group description?"


New-ADGroup -Name $groupName -GroupScope $scope -GroupCategory $category 
}

function newOU()
{
$name = Read-Host -Prompt "OU name?"
#$path = Read-Host -Prompt "Path?"
New-ADOrganizationalUnit -Name $name #-Path $path
}

function userSearch()
{

$name = Read-Host -Prompt "Name of user"
#$scope = Read-Host -Prompt "What containers/domain controllers to search?"

Get-ADUser -Identity $name 
}

function deleteOU()
{
$ou = Read-Host -Prompt "Name of OU.(Can in also use DC for location)"
Get-ADOrganizationalUnit -Filter * | Where-Object Name -eq $ou | Remove-ADOrganizationalUnit
 
}

function removeGroup()
{

$group = Read-Host -Prompt "Name of group to delete"
Get-ADGroup -Filter * | Where-Object Name -eq $group | Remove-ADGroup 
}


function menu()
{
$hostname = hostname

Write-Output "Hello you are modifying active directory on $hostname"
Write-Output "1. Create a new user"
Write-Output "2. Add user to a group"
Write-Output "3. Create a new user + OU"
Write-Output "4. Create new group"
Write-Output "5. Create new OU"
Write-Output "6. Search for user"
Write-Output "7. Delete user"
Write-Output "8. Delete OU"
Write-Output "9. Delete Group"
Write-Output "10. Quit"

$selection = Read-Host -Prompt "Selection?"
$looper = $true
while($looper -eq $true)
{
menu
if($selection -eq 1)
{
newUser
}
elseif($selection -eq 2)
{
addToGroup
}
elseif($selection -eq 3)
{
newUserPlus
}
elseif($selection -eq 4)
{
newGroup
}
elseif($selection -eq 5)
{
newOU
}
elseif($selection -eq 6)
{
userSearch
}
elseif($selection -eq 7)
{
deleteUser
}
elseif($selection -eq 8)
{
deleteOU
}
elseif($selection -eq 9)
{
removeGroup
}
elseif($selection -eq 10)
{
$looper = $false
}
}
}

menu