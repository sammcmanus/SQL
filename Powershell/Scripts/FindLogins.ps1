$IncludeJville = IF("$(Read-Host 'Include Jville Servers (Y/N)')" -eq "Y") {$true} ELSE {$false}
$IncludePlano = IF("$(Read-Host 'Include Plano Servers (Y/N)')" -eq "Y") {$true} ELSE {$false}

Function GetLogonsByServer
{
	Param($Servers,$users)

	$report = @()

	ForEach ($s in $Servers) {

		$proc = Get-WmiObject win32_process -ComputerName $s -Filter "Name = 'explorer.exe'" | Where-Object {$users -contains ($_.GetOwner()).User}

		if ($proc -ne $null) {
			ForEach ($p in $proc) {
				$temp = "" | SELECT Computer, Domain, User
				$temp.computer = $s
				$temp.user = ($p.GetOwner()).User
				$temp.domain = ($p.GetOwner()).Domain
				$report += $temp
			}
		}
	}

	$report
}


Function GetServerList 
{
	Param($IncludeJville = $true,$IncludePlano = $false)

	$servers = @()

	if ($IncludeJville) 
	{
		$servers += ("Server1","Server2")
	}
	
	if ($IncludePlano) {
		$servers += ("server1","server2")
	}
	
	$servers
}

$users = @("user1","user2")
$servers = GetServerList -IncludeJville $IncludeJville -IncludePlano $IncludePlano

GetLogonsByServer -Servers $servers -users $users