<#
Name: 		Kuteesa Kiyaga
Date: 		April 20, 2019
Function: 	List an Active Directory security group's member users and
			output the results into a .CSV file stored on the 
			user's desktop.  
#>

# function that returns Active Directory information
# parameter takes a String array
function OutputGroupMembers {
 param( [string[]]$securityGroups )
	# loop to iterate through each Active Directory security group
	foreach ($group in $securityGroups) {
		# each security group will have its own output .CSV file,
		# stored on the user's desktop
		
		# append the group name to the associated Active Directory	
		# security group's output .CSV file
		$group
		
		# append the group member user to the associated Active Directory	
		# security group's output .CSV file
		Get-ADGroupMember -Identity $group | Select SamAccountName
	}
}

# array variable stores a list of Active Directory security groups
# passed into the function as the String array parameter
$securityGroups = @(
	"Domain Admins",
	"Domain Controllers",
	"Enterprise Admins",
	"Schema Admins"
)

# call the function using the security groups array as a parameter
# output the function's results into a .CSV file on the user's desktop
OutputGroupMembers $securityGroups >> "C:\users\$Env:username\Desktop\$group.csv"
