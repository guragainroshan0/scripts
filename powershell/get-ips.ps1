<# 

Get ips using ipconfig and select-string to filter just the ips.
$ips is an array so loop through it to get the ip's associated.

#>
$ips=(ipconfig | select-string IPv4)
for($i=0;$i -lt $ips.Count;$i++)
{
	echo $ips[$i].ToString().Split(':')[1];

}