<# 	Name:	Kuteesa Kiyaga
	Date: June 18, 2019
	Function: Find information about servers.  
#>



# declare a function that takes a computer name as a parameter
Function ServerPMCheckList ($computerName) {
	# variable that stores a server's disk information
	$disks = Get-WmiObject -Computer $computerName -Class Win32_logicaldisk
	
	# iterate through all server's disks
	For ($i=0; $i -lt $disks.length; $i++) {
		# variable containing the server's free disk space
		$freeSpace = ($disks[$i] | Select FreeSpace).FreeSpace
		# variable containing the server's disk capacity
		$diskSize = ($disks[$i] | Select Size).Size
		
		# if the total disk capacity variable is not null or empty
		if (-not [string]::IsNullOrEmpty($diskSize)) {
			# variable containing each disk's filled space
			$diskUtilization = ($freeSpace / $diskSize) * 100
			# add the server's disk utilization to the PowerShell object
			$disks[$i] | Add-Member -NotePropertyName 'DiskUtilization' -NotePropertyValue $diskUtilization
		}
	}
	
	
	
	# create a new PowerShell object to contain data about the servers
	$psObject = New-Object PSObject
	
	# add the server's host name to the PowerShell object
	$psObject | Add-Member -NotePropertyName 'Hostname' (Get-WmiObject -Computer $computerName -Class win32_SystemEnclosure | Select PSComputerName).PSComputerName
	# add the server's manufacturer name to the PowerShell object
	$psObject | Add-Member -NotePropertyName 'Manufacturer' (Get-WmiObject -Computer $computerName -Class win32_SystemEnclosure | Select Manufacturer).Manufacturer
	# add the server's model name to the PowerShell object 
	$psObject | Add-Member -NotePropertyName 'Model' (Get-WmiObject -Computer $computerName -Class Win32_ComputerSystem | Select-Object Model).Model
	# add the server's service tag to the PowerShell object
	$psObject | Add-Member -NotePropertyName 'Service Tag' (Get-WmiObject -Computer $computerName -Class win32_SystemEnclosure | Select SerialNumber).SerialNumber
	# add the server's operating system to the PowerShell object
	$psObject | Add-Member -NotePropertyName 'Operating System' (Get-WmiObject -Computer $computerName -Class Win32_OperatingSystem | Select-Object Caption).Caption
	# add the server's disk information to the PowerShell object
	$psObject | Add-Member -NotePropertyName 'DiskInformation' -NotePropertyValue ($disks | Select DeviceID, VolumeName, Path, DiskUtilization)
	
	# output the PowerShell object's contents in table format
	return $psObject
}

# call the function to gather data about the desired server
ServerPMChecklist -computerName "TOR-DC-0001"
