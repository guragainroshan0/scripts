<# 

Get ips using ipconfig and select-string to filter just the ips.
$ips is an array so loop through it to get the ip's associated.

#>
function Get-IP($ips) {
	$address=@();
	for ($i = 0; $i -lt $ips.Count; $i++) {
		$address =$address + $ips[$i].ToString().Split('')[-1];
	}
	return $address;
}

Write-Output "Local IPv4 Address : `n"
$ipv4 = (ipconfig | select-string IPv4)
Get-IP($ipv4);

Write-Output "`n`nPublic IPv4 Address : `n"
Write-Output (Invoke-WebRequest "https://ifconfig.me" ).content

Write-Output "`n`nLocal IPv6 Address : `n"
$ipv6 = (ipconfig | select-string IPv6)
Get-IP($ipv6);

Write-Output "`n`nPublic IPv6 Address : `n"
Write-Output (Invoke-WebRequest "https://api64.ipify.org").content








