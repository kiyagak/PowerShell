# function to store code blocks that will be reused
function script1 {
	# store the date into a variable
	$date = get-date

	# store th day, month, and year into their own variables
	$day = $date.Day
	$month = $date.Month
	$year = $date.Year

	# store the result of whether or not the current date is 
	# within daylight savings time
	$dstDate = $date.IsDaylightSavingTime()
	# store the date ninety days into the past into a variable
	$prevDate = $date.AddDays(-90)
	# store daylight savings time date into a variable
	$dstPrevDate = $prevDate.IsDaylightSavingTime()

	# print the month, day, and year
	"$month/$day/$year"
	# print a statement specifying whether or not the current date
	# is within daylight savings time
	if ($dstDate) {
	"Date is daylight savings time.  "
	} else {
	"Date is not daylight savings time.  "
	}

	# print the date that is ninety days into the past
	"$prevDate"

	# print whether or not the date ninety days into the past
	# falls within daylight savings time
	if ($dstPrevDate) {
	"Date minus ninety days is daylight savings time.  "
	} else {
	"Date minus ninety days is not daylight savings time.  "
	}
}

# execute function and redirect output into text file
script1 > KuteesaKiyaga-HW2_1.txt
