﻿Set-ExecutionPolicy Bypass -Scope Process

#$IPList = @('172.16.82.57','172.16.81.95','10.20.26.13')
$IPList = Get-Content C:\Media\dev\ps\resolve_dns_list_ip.txt -Encoding UTF8
$ServerList = @('172.16.20.11','172.16.20.12')

$FinalResult = @()
foreach ($IP in $IPList) {
    $tempObj = "" | Select-Object Name, IPAddress, Status, ErrorMessage
    try {
        $dnsRecord = Resolve-DnsName $IP -Server $ServerList -ErrorAction Stop
        $tempObj.Name = ($dnsRecord.NameHost -join ',')
        $tempObj.IPAddress = $IP
        $tempObj.Status = 'OK'
        $tempObj.ErrorMessage = ''
    }
    catch {
        $tempObj.Name = $Name
        $tempObj.IPAddress = ''
        $tempObj.Status = 'NOT_OK'
        $tempObj.ErrorMessage = $_.Exception.Message
    }
    $FinalResult += $tempObj
}
return $FinalResult