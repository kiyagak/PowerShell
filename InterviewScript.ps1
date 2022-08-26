$sentence = "many words in here and then there are more words than we need to split dddd"
$arraySentence = $sentence -split " "

$sentence50 = ""

foreach ($word in $arraySentence) {
	$sentence50 += $word + " "
	
	$totalLength = $sentence50.Length + $word.Length

	if ($totalLength -gt 50) {
		break
	}	
}

$sentence50.Length
$sentence50