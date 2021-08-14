# script to create azure resources
# is meant to work as a module. Not a good implementation

#todo write scriptts to create other resources as well

function create_credentials($server_name)
{
	# get credentials for server to create
	# these credentials are later used to authenticate to the deployed virtual Machines

	# username and password Strings, Not a good approach need to change it later
	[String]$username = "<dummy-username>"+$server_name
	[String]$password = "<dummy-password>" + $server_name

	# convert password to securestring
	[securestring]$secPassword = ConvertTo-SecureString $password -AsPlainText -Force
	
	# create PSCredential object from data, psCredential object has username and securepassword string
	[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($username,$secPassword)	

	Write-Output "Creds are : {} : {} " -f $username,$password
	return $credObject
}

function create_resource_group($name,$Location="southeastasia")
{
	# creates resource group and set location to southeastasis
	New-AzResourcegroup  -ResourceGroupName $name -Location $Location	

	Write-Output "ResourceGroup {} created with location {}." -f $name,$Location
}


function delete_resource_group($name="myResourceGroup")
{
	# remove resource group to free all the resources inside it
	Remove-AzResourceGroup -Name $name

	#For debugging purpose
	Write-Output "ResourceGroup {} deleted " -f $name
}


function create_VM($resource_group_name="myResourceGroup",$Name="myVM",$Location="southeastasia",$VirtualNetworkName="myVirtualNetwork",$SubnetName="mySubnet",$SecurityGroupName="mySecurityGroup",$PublicAddressName="myPublicAddress")
{

	# if something is already created just set it as none
	# may need to change this to different function as previously created resources could be used.
	if($resource_group_name -ne "None")
	{
		#Create resource_group
		create_resource_group $resource_group_name $Location
	}

	#Create Other Resources like virtualNetwork, subnet to use, SecurityGroup, publicAddressName
	

	# create credentials
	$creds=create_credentials $Name

	#createVM from all the information
	New-AzVm `
    -ResourceGroupName $resource_group_name `
    -Name $Name `
    -Location $Location `
    -VirtualNetworkName $VirtualNetworkName `
    -SubnetName $SubnetName `
    -SecurityGroupName $SecurityGroupName `
    -PublicIpAddressName $PublicAddressName `
    -Credential $creds

	Get-AzPublicIpAddress -ResourceGroupName $resource_group_name | Select-Object IpAddress

}


