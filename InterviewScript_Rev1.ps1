$sentence = "But the rest of mankind, who were not killed by these plagues, did not repent of the works of their hands, that they should not worship demons, and idols of gold, silver, brass, stone, and wood, which can neither see nor hear nor walk."
$arraySentence = $sentence -split " "
$lastWord = ""

$sentence50 = ""

foreach ($word in $arraySentence) {
	$lastWord = $word + " "
	
	# changed from 50 to 49
	if ($totalLength -gt 49) {
		# if the sub-50 character block is not empty
		if ($sentence50 -ne "") {
			# print sub-50 character string blocks from the string
			$sentence50.Length		
			$sentence50
		}
		
		$sentence50 = ""
	}

	$sentence50 += $word + " "
	$totalLength = $sentence50.Length + $word.Length
}

if ($totalLength -gt 49) {
	$sentence50 = ($sentence50 -split "$lastWord$")[0]
	$sentence50.Length
	$sentence50
	$lastWord.Length
	$lastWord
} else {
	# print the string's last sub-50 character block
	$sentence50.Length
	$sentence50
}




