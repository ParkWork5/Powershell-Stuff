# Modying network card settings

Function Convert-RvNetInt64ToIpAddress() 
{ 
    Param    #Rudolf Vesely code on cidr to subent mask conversion
    ( 
        [int64] 
        $Int64 
    ) 
 
    # Return 
    '{0}.{1}.{2}.{3}' -f ([math]::Truncate($Int64 / 16777216)).ToString(), 
        ([math]::Truncate(($Int64 % 16777216) / 65536)).ToString(), 
        ([math]::Truncate(($Int64 % 65536)/256)).ToString(), 
        ([math]::Truncate($Int64 % 256)).ToString() 
} 
 
Function Convert-RvNetSubnetMaskCidrToClasses 
{  
    Param 
    ( 
        [int] 
        $SubnetMaskCidr 
    ) 
 
    # #Rudolf Vesely code on cidr to subent mask conversion
    Convert-RvNetInt64ToIpAddress -Int64 ([convert]::ToInt64(('1' * $SubnetMaskCidr + '0' * (32 - $SubnetMaskCidr)), 2)) 
}

function Convert-IpAddressToMaskLength([string] $dottedIpAddressString)
{
  $result = 0; 
  # ensure we have a valid IP address
  [IPAddress] $ip = $dottedIpAddressString;  # Code of the internet not mine
  $octets = $ip.IPAddressToString.Split('.');
  foreach($octet in $octets)
  {
    while(0 -ne $octet) 
    {
      $octet = ($octet -shl 1) -band [byte]::MaxValue
      $result++; 
    }
  }
  return $result;
}

function grabDns([int] $ifIndex)
{


$dnsServer = Get-DnsClientServerAddress -InterfaceIndex $ifIndex

For($i=0; $i -lt $dnsServer.ServerAddresses.count; $i++)
{
$server =  $dnsServer.ServerAddresses.get($i)

$serverList = $server + "," + $serverList

}


return $serverList;

}



function menu()
{
$hostName = hostname

Write-Output "Hello you are modifying network cards on the host $hostName" | Out-Host

Get-NetAdapter -IncludeHidden | select -Property Name  |Out-Host

$cardName = Read-Host -Prompt "Which card would you like to modify? Enter the name"


$networkCard = Get-NetAdapter -Name $cardName 


Get-NetIPConfiguration -InterfaceIndex $networkCard.ifIndex | Out-Host



return $networkCard


}


function modifySettings()
{
Param([Object[]] $inputObject)
$looper = $true

$cardIpInfo = Get-NetIPConfiguration -InterfaceIndex $inputObject.ifIndex 

while($looper -eq $true)
{
Write-Host "What options would you to modify on this network card?"
Write-Host "1. IP Address"
Write-Host "2. Subnet"
Write-Host "3. DNS Server"
Write-Host "4. Default Gateway"
Write-Host "5. Whole 9 yards(IP, Default, Subnet, and DNS)"
Write-Host "6. Turn Off"
Write-Host "7. Turn On"
Write-Host "8. New nic Config"
Write-Host "9. Delete Current nic Config"
Write-Host "10. Disable DHCP "
Write-Host "11. Enable DHCP"
Write-Host "12. Select new nic"
Write-Host "13. Done"

$selection = Read-Host -Prompt "Selection?"
$ipInfo = Get-NetIPAddress -InterfaceIndex $inputObject.ifIndex -AddressFamily IPv4 

if ($ipInfo -eq $null)
{

$ipInfo = Get-NetIPAddress -InterfaceIndex $inputObject.ifIndex -AddressFamily IPv4


}

if($cardIpInfo -eq $null)
{
$cardIpInfo = Get-NetIPConfiguration -InterfaceIndex $inputObject.ifIndex 
}



if($selection -eq 1)
{

Write-Host "Current Ip Address is: "$ipInfo.IPAddress  
$newIpAddress = Read-Host -Prompt "New IpAddress "

Write-Host "Removing current config."

Remove-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $ipInfo.IPAddress

New-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $newIpAddress -PrefixLength $ipInfo.PrefixLength -DefaultGateway $cardIpInfo.IPv4DefaultGateway.NextHop 

$serverList = grabDns($inputObject.ifIndex)



Set-DnsClientServerAddress -InterfaceIndex $inputObject.ifIndex -ServerAddresses ($serverList)


}

if($selection -eq 2)
{
Write-Host "Current IPAddress: "$ipInfo.IPAddress
$subnetMask = Convert-RvNetSubnetMaskCidrToClasses($ipInfo.PrefixLength);

Write-Host "Current SubnetPrefix:"$ipInfo.PrefixLength
Write-Host "Current SubnetMask:"$subnetMask

$newSubMask = Read-Host -Prompt "What is the new subnet mask?:"

$newCidr = Convert-IpAddressToMaskLength($newSubMask);

Set-NetIPAddress -InterfaceIndex $inputObject.ifIndex -PrefixLength $newCidr


}

if($selection -eq 3)
{



$serverList = grabDns($inputObject.ifIndex)

Write-Host "Current DNS Servers are:"$serverList

$newDNS = Read-Host -Prompt "Enter new dns servers. Note: If multiple seperate with , and no spaces"

Set-DnsClientServerAddress -InterfaceIndex $inputObject.ifIndex -ServerAddresses ($newDNS)

}

if($selection -eq 4)
{

$gateway =  $cardIpInfo.IPv4DefaultGateway.NextHop 
Write-Host "Current Gateway is"$gateway

$newGateway = Read-Host -Prompt "Enter the new gateway"

Write-Host "Removing old defualt gateway"

Write-Host "Applying new one"

$dnsServer = grabDns($inputObject.ifIndex)

Remove-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $ipInfo.IPAddress


New-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $ipInfo.IPAddress -PrefixLength $ipInfo.PrefixLength -DefaultGateway $newGateway

Set-DnsClientServerAddress -InterfaceIndex $inputObject.ifIndex -ServerAddresses ($dnsServer)

}

if($selection -eq 5)
{

$newIpAddress = Read-Host -Prompt "Enter IP Address"
$gateway = Read-Host -Prompt "Enter Gateway"
$newDns = Read-Host -Prompt "Enter DNS Servers"
$newSubMask = Read-Host -Prompt "Enter in subnet mask(entering n auto calculates subnet based on ip address)"

if($newSubMask -eq "n")
{

$newSubMask = Convert-IpAddressToMaskLength($newIpAddress)
}
else
{
$newSubMask = Convert-IpAddressToMaskLength($newSubMask)
}


Write-Host "Applying new config"

Remove-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $ipInfo.IPAddress 

New-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $newIpAddress -PrefixLength $newSubMask -DefaultGateway $gateway

Set-DnsClientServerAddress -InterfaceIndex $inputObject.ifIndex -ServerAddresses ($newDns)

Write-Host "New config applied"


}

if($selection -eq 6)
{

Disable-NetAdapter -Name $inputObject.Name
}

if($selection -eq 7)
{
Enable-NetAdapter -Name $inputObject.Name
}

if($selection -eq 8)
{
$newIpAddress = Read-Host -Prompt "Enter IP Address"
$gateway = Read-Host -Prompt "Enter Gateway"
$newDns = Read-Host -Prompt "Enter DNS Servers"
$newSubMask = Read-Host -Prompt "Enter in subnet mask(entering n auto calculates subnet based on ip address)"

if($newSubMask -eq "n")
{

$newSubMask = Convert-IpAddressToMaskLength($newIpAddress)
}
else
{
$newSubMask = Convert-IpAddressToMaskLength($newSubMask)
}


New-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $newIpAddress -PrefixLength $newSubMask -DefaultGateway $gateway

Set-DnsClientServerAddress -InterfaceIndex $inputObject.ifIndex -ServerAddresses ($newDns)

Write-Output "Config Applied"

}

if($selectoin -eq 9)
{

Remove-NetIPAddress -InterfaceIndex $inputObject.ifIndex -IPAddress $ipInfo.IPAddress  
Write-Host "Current config deleted"
}

if($selection -eq 10)
{
Set-NetIPInterface -InterfaceIndex $inputObject.ifIndex -Dhcp Disabled
}

if($selection -eq 11)
{
Set-NetIPInterface -InterfaceIndex $inputObject.ifIndex -Dhcp Enabled
}

if($selection -eq 12)
{
$networkCard = menu;
modifySettings($networkCard);
}

if($selection -eq 13)
{
$looper = $false

}



}


}



$networkCard = menu;

modifySettings($networkCard);














