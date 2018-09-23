# function to store code blocks that will be reused
function script3 {
	# create variable to store bios items
	$bios = Get-WMIObject win32_bios

	# variables to store bios name and version
	$name = $bios.name
	$version = $bios.version

	# print the bios name and version
	"BIOS name: $name"
	"BIOS version: $version"
	""
	""
	""
	# create variable to store battery items
	$battery = Get-WMIObject win32_battery

	# variables to store battery name, 
	# estimated runtime, and estimated charge remaining
	$name = $battery.name
	$estimatedruntime = $battery.estimatedruntime
	$estimatedchargeremaining = $battery.estimatedchargeremaining

	# print the battery name, # estimated runtime, 
	# and estimated charge remaining
	"battery name: $name"
	"battery estimated run time: $estimatedruntime"
	"battery estimated charge remaining: $estimatedchargeremaining"
	""
	""
	""
	# create array to store serial port items
	$serPortArr = Get-WMIObject win32_serialport

	# loop through array items
	for ( $i = 0; $i -lt $serPortArr.Length; $i++ ) { 
		# variables to store serial port name and status
		$name = $serPortArr[$i].name
		$providertype = $serPortArr[$i].providertype
		
		# print the serial port name and status
		"Serial port name: $name"
		"Serial port status: $providertype"
		""
	}

	# variable to store the number of present serial ports
	$serPortCount = $serPortArr.Length
	""
	# print the sum of present serial ports
	"There are $serPortCount Serial ports.  "
	""
	""
	""
	# create array to store fixed drive items
	$diskArr = Get-WMIObject win32_logicaldisk
	# variables initialized at 0 to store total capacity of all fixed drives
	$totCapacityUnconv = 0
	$totCapacityConv = 0

	# print output table column headers
	"DeviceID `t Size"
	"--------------------------"

	# loop through array items
	foreach ( $item in Get-WMIObject win32_logicaldisk ) { 
		# variables to store fixed drive device ID and size
		$deviceID = $item.DeviceID
		$size = $item.Size
		
		# print the fixed drive device ID and size onto the table
		"$deviceID `t`t`t $size"
		# variable increments each fixed drive's size to form a total
		# capacity amount for all fixed drives
		$totCapacityUnconv += $item.Size
	}
	""
	# variable stores conversion of all disks' total capacity
	# from bytes to gigabytes
	$totCapacityConv = $totCapacityUnconv / 1073741274
	# print the total capacity of all hard disks in gigabytes
	"Total capacity of all fixed drives: $totCapacityConv GBs"
}

# execute function and redirect output into text file
script3 > KuteesaKiyaga-HW2_3.txt
