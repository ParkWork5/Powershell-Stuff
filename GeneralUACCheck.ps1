

function uacCheck()
{
$uacValues =  Get-ItemProperty -path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"

$ConsentPromptBehaviorAdmin = $uacValues.ConsentPromptBehaviorAdmin

Write-Output " "
Write-Output "=====BEHAVIOR OF UAC PROMPT FOR ADMINS IN ADMIN APPROVAL MODE=============="

Write-Output "Value stored in registry for ConsentPromptBehaviorAdmin Key is $ConsentPromptBehaviorAdmin "

if($ConsentPromptBehaviorAdmin -eq 5)
{
Write-Output "Applies to admins in Admin Approval Mode(defualt): Prompt for consent for non Windows programs/binaries"
}
elseif($ConsentPromptBehaviorAdmin -eq 4)
{
Write-Output "Applies to admins in Admin Approval Mode: Prompt for consent when operation requires elevation of privilage"
}
elseif($ConsentPromptBehaviorAdmin -eq 3)
{
Write-Output "Applies to admins in Admin Approval Mode: User is prompted for admin user/pass for operation"
}
elseif($ConsentPromptBehaviorAdmin -eq 2)
{
Write-Output "Applies to admin in Admin Approval Mode: Prompt for consent on secure desktop"

}
elseif($ConsentPromptBehaviorAdmin -eq 1)
{
Write-Output "Applies to admin in Admin Approval Mode: Prompt for users credentials for operation"
}

elseif($ConsentPromptBehaviorAdmin -eq 0)
{
Write-Output "Applies to admin in Admin Approval Mode: Elevate without prompting"
}
Write-Output "==========================================================================="
Write-Output " "

Write-Output "================BEHAVIOR OF UAC PROMPT FOR NON-ADMINS======================"

$ConsentPromptBehaviorUser = $uacValues.ConsentPromptBehaviorUser

Write-Output "Value stored in registry for ConsentPromptBehaviorUser Key is $ConsentPromptBehaviorUser "

if($ConsentPromptBehaviorUser -eq 3)
{
Write-Output "UAC prompts user for crendentials when elevated privileges are needed"
}

if($ConsentPromptBehaviorUser -eq 1)
{
Write-Output "UAC prompts user for crendentials w/ secure desktop when elevated privileges are needed"
}

if($ConsentPromptBehaviorUser -eq 0)
{
Write-Output "UAC denys all evelation request"
}
Write-Output "==========================================================================="
Write-Output " "

Write-Output "========================INSTALLER DETCTION================================="
$EnableInstallerDetection = $uacValues.EnableInstallerDetection

Write-Output "Value stored in registry for EnableInstallerDetection  Key is $EnableInstallerDetection "

if($EnableInstallerDetection -eq 1)
{
Write-Output "Installer detectition is enabled(Defualt for home versions of windows)"
}
elseif($EnableInstallerDetection -eq 0)
{
Write-Output "Installer detectition is disabled(Defualt for enterprise)"
}

Write-Output "==========================================================================="
Write-Output " "

Write-Output "============SECURE DESKTOP WHEN PROMPT FOR ELEVATION======================="

$PromptOnSecureDesktop = $uacValues.PromptOnSecureDesktop

Write-Output "Value stored for PromptOnSecureDesktop is $PromptOnSecureDesktop "

if($PromptOnSecureDesktop -eq 1)
{
Write-Output "Secure desktop is switched to when prompting for elevation (This overrides any other secure desktop behavior set)"
}
elseif($PromptOnSecureDesktop -eq 0)
{
Write-Output "Secure desktop is not used when prompting for elevation (This overrides any other secure desktop behavior set)"
}
Write-Output "==========================================================================="


}



$hostname = hostname
Write-Output "Hello you are checking some uac registry values on: "$hostname


uacCheck;