# Name: Kuteesa Kiyaga
# Date: August 22, 2022
# Function: Use PowerShell to automate configuration of Azure AD users, dynamic an dassigned security groups, 
#		creation of a secondary Azure tenant, and guest user management

# Reference
# https://github.com/MicrosoftLearning/AZ-104-MicrosoftAzureAdministrator/blob/master/Instructions/Labs/LAB_01-Manage_Azure_AD_Identities.md



# install the Azure PowerShell module
# https://docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-8.2.0
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force

# install  Azure AD module
# https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0
Install-Module AzureAD



# import Az accounts
Import-Module Az.Accounts

# import Azure AD module
# https://docs.microsoft.com/en-us/powershell/azure/active-directory/install-adv2?view=azureadps-2.0
Import-Module AzureAD

# https://www.partitionwizard.com/clone-disk/running-scripts-is-disabled-on-this-system.html
# allow scripts to run
Set-ExecutionPolicy RemoteSigned

#connect to your Azure account
Connect-AzAccount


# get Azure AD tenant
# https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-how-to-find-tenant
$azTenant = Get-AzTenant
$azTenantIDA1 = $azTenant.Id
$upnSuffix = $azTenant.Domains[0]
$userNameA1 = "az104-01a-aaduser1"
$mailNameA1 = "$userNameA1@$upnSuffix"

# connect to Azure AD
# https://docs.microsoft.com/en-us/powershell/module/azuread/connect-azuread?view=azureadps-2.0
Connect-AzureAD -TenantId $azTenantIDA1

# create Azure AD user
# https://docs.microsoft.com/en-us/powershell/module/azuread/new-azureaduser?view=azureadps-2.0
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Privacy123!"

$objectUserA1 = New-AzureADUser -DisplayName $userNameA1 -PasswordProfile $PasswordProfile -AccountEnabled $true -UsageLocation "US" -JobTitle "Cloud Administrator" -Department "IT" -MailNickName $userNameA1 -UserPrincipalName $mailNameA1
$idUserA1 = $objectUserA1.ObjectId

# assign Azure AD role
# https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell
# Get-AzRoleAssignment -SignInName $mailNameA1
# Get-AzADUser -StartsWith $userNameA1

$idRoleAssignedA1 = (Get-AzureADMSRoleDefinition -Filter "displayName eq 'User Administrator'").Id

# assign role to user
# https://docs.microsoft.com/e-us/powershell/module/azuread/new-azureadmsroleassignment?view=azureadps-2.0
# https://docs.microsoft.com/en-us/azure/active-directory/roles/custom-assign-powershell
# https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-powershell
New-AzureADMSRoleAssignment -RoleDefinitionId $idRoleAssignedA1 -PrincipalId $idUserA1 -DirectoryScopeId "/"

# connect to Azure AD using newly created account
Connect-AzureAD -TenantId $azTenantIDA1

# create 2nd user
$userNameA2 = "az104-01a-aaduser2"
$mailNameA2 = "$userNameA2@$upnSuffix"

# create Azure AD user
$objectUserA2 = New-AzureADUser -DisplayName $userNameA2 -PasswordProfile $PasswordProfile -AccountEnabled $true -UsageLocation "US" -JobTitle "System Administrator" -Department "IT" -MailNickName $userNameA1 -UserPrincipalName $mailNameA2

# assign Azure AD Premium P2 license
# https://techcommunity.microsoft.com/t5/azure/manage-licenses-with-powershell-in-azure-active-directory/m-p/2627903
# http://woshub.com/manage-user-licenses-m365-azure/
# https://www.ntweekly.com/2019/06/09/list-global-administrators-in-office-365-and-azure-ad-using-powershell/
# https://docs.microsoft.com/en-us/powershell/module/azuread/get-azureaddirectoryrole?view=azureadps-2.0

$adminGlobal = Get-AzureADDirectoryRole | where{$_.displayname -like "global administrator"}
$UserUPN = (Get-AzureADDirectoryRoleMember -ObjectId $adminGlobal.ObjectId)[0].UserPrincipalName
$LicPlan = "AAD_PREMIUM_P2"
$License = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicense
$License.SkuId = (Get-AzureADSubscribedSku | Where-Object -Property SkuPartNumber -Value $LicPlan -eq).SkuID
$assignlic = New-Object -TypeName Microsoft.Open.AzureAD.Model.AssignedLicenses
$assignlic.AddLicenses = $License
Set-AzureADUserLicense -ObjectId $UserUPN -AssignedLicenses $assignlic
Get-AzureADUserLicenseDetail -objectid $UserUPN

# create dynamic Azure AD groups
# https://helloitsliam.com/2021/01/25/note-to-self-powershell-create-dynamic-azure-ad-group/
# https://stackoverflow.com/questions/62030759/how-to-create-dynamic-groups-in-azure-ad-through-powershell



Remove-Module AzureAD -ErrorAction SilentlyContinue
Install-Module -Name AzureADPreview -AllowClobber -Force
Import-Module AzureADPreview
Connect-AzureAD -TenantId $azTenantIDA1

# Create a Cloud Administrator Security Group
$CloudGroupName = "IT Cloud Administrators"
$CloudGroupMailName = "ITCloudAdministrators"
$CloudGroupQuery = "(user.jobTitle -contains ""Cloud Administrator"")"

$CloudDevices = New-AzureADMSGroup `
    -Description "$($CloudGroupName)" `
    -DisplayName "$($CloudGroupName)" `
    -MailEnabled $false `
    -SecurityEnabled $true `
    -MailNickname "$($CloudGroupMailName)" `
    -GroupTypes "DynamicMembership" `
    -MembershipRule "$($CloudGroupQuery)" `
    -MembershipRuleProcessingState "Paused"

# Set the Dynamic Azure Active Directory Group to Sync
Set-AzureADMSGroup -Id $CloudDevices.Id -MembershipRuleProcessingState "Paused"

# Create a System Administrator Security Group
$SystemGroupName = "IT System Administrators"
$SystemGroupMailName = "ITSystemAdministrators"
$SystemGroupQuery = "(user.jobTitle -contains ""System Administrator"")"

$SystemDevices = New-AzureADMSGroup `
    -Description "$($SystemGroupName)" `
    -DisplayName "$($SystemGroupName)" `
    -MailEnabled $false `
    -SecurityEnabled $true `
    -MailNickname "$($SystemGroupMailName)" `
    -GroupTypes "DynamicMembership" `
    -MembershipRule "$($SystemGroupQuery)" `
    -MembershipRuleProcessingState "Paused"

# Set the Dynamic Azure Active Directory Group to Sync
Set-AzureADMSGroup -Id $SystemDevices.Id -MembershipRuleProcessingState "Paused"

# Create a IT Lab Administrator Security Group
New-AzureADGroup -DisplayName "IT Lab Administrators" -Description "Contoso IT Lab administrators" -MailEnabled $false -SecurityEnabled $true -MailNickName "ITLabAdministrators"


$arrayGroups = get-azureadgroup | Where-Object DisplayName -notLike "*Lab*"
$groupLabId = (get-azureadgroup | Where-Object DisplayName -Like "*Lab*")[0].ObjectId

# add groups to Lab Administrators group
# https://docs.microsoft.com/en-us/powershell/module/azuread/add-azureadgroupmember?view=azureadps-2.0


Connect-AzureAD -TenantId $azTenantIDA1
foreach ($adGroup in $arrayGroups)
{
	$adGroup.ObjectId
	Add-AzureADGroupMember -ObjectId $groupLabId -RefObjectId $adGroup.ObjectId
}







# create new tenant named "Contoso Lab"
# https://docs.microsoft.com/en-us/azure/active-directory/fundamentals/active-directory-access-create-new-tenant
# cannot be done through PowerShell as of August 22, 2022

Remove-Module AzureADPreview -ErrorAction SilentlyContinue
Install-Module -Name AzureAD -AllowClobber -Force
Import-Module AzureAD

# https://docs.microsoft.com/en-us/powershell/module/az.accounts/get-aztenant?view=azps-8.2.0
Connect-AzAccount
$IdTenantContoso = (Get-AzTenant | Where-object Name -Like "*Contoso*")[0].Id

# Switch to another active directory tenant.
Set-AzContext -TenantId $IdTenantContoso

# create Azure AD user on second tenant
$azTenant = (Get-AzTenant | Where-Object Name -Like "*Contoso*")[0]
$azTenantIDB1 = $azTenant.Id

Connect-AzureAD -TenantId $azTenantIDB1
$upnSuffix = $azTenant.Domains[0]
$userNameB1 = "az104-01b-aaduser1"
$mailNameB1 = "$userNameB1@$upnSuffix"

$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Privacy123!"
$objectUserB1 = New-AzureADUser -DisplayName $userNameB1 -PasswordProfile $PasswordProfile -AccountEnabled $true -UsageLocation "US" -JobTitle "System Administrator" -Department "IT" -MailNickName $userNameB1 -UserPrincipalName $mailNameB1
$idUserA1 = $objectUser.ObjectId

$azTenant = (Get-AzTenant | Where-Object Name -eq "Default Directory")[0]
$idTenantDefault = $azTenant.Id
Connect-AzureAD -TenantId $idTenantDefault

New-AzureADMSInvitation -InvitedUserEmailAddress $mailNameB1 -SendInvitationMessage $True -InviteRedirectUrl "http://myapps.microsoft.com"

$idGuestUser = (Get-AzureADUser | Where-Object DisplayName -eq $userNameB1)[0].ObjectId

Add-AzureADGroupMember -ObjectId $groupLabId -RefObjectId $idGuestUser