<# Name: Kuteesa Kiyaga
Date: May 21, 2019
Function: Produce a list of software currently installed on a computer.  #>


# prompt the user to enter a computer name
$computerName = Read-Host -Prompt 'Input your computer name: '

# echo a list of programs installed on the remote computer
Invoke-Command -ComputerName $computerName -ScriptBlock {
	Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName | Select DisplayName | Sort-Object DisplayName
}