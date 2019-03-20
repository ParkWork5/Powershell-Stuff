# Manages local user account
# Add or create local user account
# local account lookup


function showUsers()
{
    
Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount = True"

}

function modifyUsers()

{
 $selection = Read-Host -Prompt "Delete or Add?"

 if ($selection -eq "Add")
 {

 addUser;

 }

 elseif ($selection -eq "Delete")
 {

 deleteUser;

 }


}

function addUser()
{
$userName = Read-Host -Prompt "Name of user:"
$userPassword = Read-Host -AsSecureString -Prompt "User password:"
$userDecript = Read-Host -Prompt "User account description:"
$userGroup = Read-Host -Prompt "User Group:"

New-LocalUser $userName -Password $userPassword -Description $userDecript 
Add-LocalGroupMember -Group $userGroup -Member $userName
}

function deleteUser()
{

$userName = Read-Host -Prompt "Name of user to delete:"

Remove-LocalUser $userName
}

function lookupUser()
{
$userName = Read-Host -Prompt "Name of user to lookup"
$out = Get-LocalUser -Name $userName

if ($null -eq $out)
{
Write-Output "User not found"
}
else
{
Write-Output  $out

Get-WmiObject -Class Win32_UserAccount  -Property "AccountType", "Status", "InstallDate", "Lockout", "SIDType" -Filter "Name = '$out'" 

}

}













Write-Host "
            ++++++++++++++++++++++++++++++++++++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++++++++++++++++++++++++++++++++++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++             ++++             ++++
            ++++++++++++++++++++++++++++++++++++++"
$hostname = hostname


Write-Host "What would you like to do?"
Write-Host "You are currently on the computer called: $hostname"
Write-Host "1. Manage local users"
Write-Host "2. Local user search and lookup"

$selection = Read-Host -Prompt "Enter selection:"

switch ( $selection )
{
   ($selection = 1)
   {
   showUsers;
   modifyUsers;
   Read-Host -Prompt "Done?"

   
   }

   ($selection = 2)
   {
   lookupUser;
    Read-Host -Prompt "Done?"
   }

}

