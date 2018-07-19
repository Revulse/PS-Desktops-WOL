Function GetMac{
	$macs = Get-DhcpServerv4Lease -ComputerName "atrdc2.appliedtechres.com" -Scope 192.173.1.0
        return $macs.clientid

	}
Function MacList {
return GetMac
}

ForEach ($mac in MacList) {

    $port = 9
    $broadcast = '192.173.1.255'

	    $mac=(($mac.replace(":","")).replace("-","")).replace(".","")
	    $target=0,2,4,6,8,10 | % {[convert]::ToByte($mac.substring($_,2),16)}
	    $packet = (,[byte]255 * 6) + ($target * 16)

	    $UDPclient = new-Object System.Net.Sockets.UdpClient
	    $UDPclient.Connect($broadcast,$port)
	    [void]$UDPclient.Send($packet, 102)
	    }