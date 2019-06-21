<# Name: Kuteesa Kiyaga
Date: May 21, 2019
Function: Produce a list of software currently installed on a computer.  #>



# prompt the user to enter a computer name
$computerName = Read-Host -Prompt 'Input your computer name'

# echo a list of programs installed on the specified computer name
get-wmiobject Win32_Product -computername $computerName | Select-Object Name | Sort-Object -Property Name