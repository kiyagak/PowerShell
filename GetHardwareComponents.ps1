# function to store code blocks that will be reused
function script2 {
	# create array to store printer items
	$printArr = Get-WMIObject win32_printer

	# loop through array items
	for ( $i = 0; $i -lt $printArr.Length; $i++ ) { 
		# variables to store printer name and status
		$name = $printArr[$i].name
		$printerStatus = $printArr[$i].printerStatus
		
		# print the printer name and status
		"Printer name: $name"
		"Printer status: $printerStatus"
		""
	}

	# variable to store the number of present printers
	$printCount = $printArr.Length
	""
	# print the sum of present printers
	"There are $printCount printers.  "
	""
	""
	""
	# create array to store memory items
	$memArr = Get-WMIObject win32_physicalmemory

	# variable initialized at 0, made to store the
	# total memory of all memory sticks
	$totGBUnconv = 0
	# variable storing the number of memory sticks
	$stickSum = $memArr.Length

	# loop through array items
	for ( $i = 0; $i -lt $memArr.Length; $i++ ) {
		# variables to store memory name and capacity
		$name = $memArr[$i].name
		$capacity = $memArr[$i].capacity
		# variable collecting each memory stick's total capacity to
		# eventually form a final total capacity of all sticks
		$totGBUnconv += $capacity
		
		# print memory name & capacity
		"Memory name: $name"
		"Memory capacity: $capacity"
		""
	}
	# variable to convert the total capacity from bytes into gigabytes
	$totGBConv = $totGBUnconv / 1073741274
	""
	# print the sum of memory sticks
	"There are $stickSum memory sticks.  "
	# print the total amount of gigabytes available on all memory sticks
	"There is $totGBConv total GB.  "
	""
	""
	""
	# create variable to store operating system items
	$os = Get-WMIObject win32_operatingsystem

	# variables to store operating system serial number and version
	$serialnum = $os.serialnumber
	$version = $os.version

	# print the operating system serial number and version
	"Operating system serial number: $serialnum"
	"Operating system version: $version"
	""
	""
	""
	# create array to store desktop items
	$desktopArr = Get-WMIObject win32_desktop

	# loop through array items
	for ( $i = 0; $i -lt $desktopArr.Length; $i++ ) {
		# variables to store desktop name and screensaveractive result
		$name = $desktopArr[$i].name
		$screensaveractive = $desktopArr[$i].screensaveractive
		
		# print the desktop name and screensaveractive result
		"Desktop name: $name"
		"Desktop screensaver active: $screensaveractive"
		""
	}
	""
	""
	""
}

# execute function and redirect output into text file
script2 > KuteesaKiyaga-HW2_2.txt
