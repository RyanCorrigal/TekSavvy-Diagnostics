# these will be put into script parameters
$numberOfPings = 50
$addressesToResolve = ("google.ca")
$addressesToPing = ("192.168.1.1")
$nameServerLookupsToTest = ("shaw.ca")
$dnsServersToTest = ("206.248.154.170", "8.8.8.8")

Write-Host("`n`nWelcome to TekSavvy Diagnostics...`n`n")

# returns your current public IP, according to ipinfo.io
function getPublicIpAddress {
    Write-Verbose "Resolving external IP"
    try {
        $ipAddress = Invoke-RestMethod http://ipinfo.io/json
    }
    catch {
        throw "Can't get external IP Address. Quitting."
    }
    if ($null -eq $ipAddress) { throw "Can't get external IP Address. Quitting." }
    return $ipAddress
}

$publicIpAddress = (getPublicIpAddress).ip
Write-Host("Your public IP address is: " + $publicIpAddress)

# PING ALL THE THINGS!!!!!!!!!!!

Write-Host("`nNow performing PING tests..." + "`n")

# ping the provided named addresses and then the subsequently resolved addresses
foreach ($addressToResolve in $addressesToResolve) {
    Write-Host("`nPING test (" + $numberOfPings + " times) to host: " + $addressesToResolve + "`n")
    ping -n $numberOfPings $addressToResolve
    $resolvedAddress = (Test-Connection $addressToResolve -Count 1).IPV4Address.IPAddressToString
    Write-Host("`nPING test (" + $numberOfPings + " times) to resolved IP from host: " + $resolvedAddress  + "`n")
    ping -n $numberOfPings $resolvedAddress
}

# ping all other addresses provided in the top
foreach ($addressToPing in $addressesToPing) {
        Write-Host("`nPING test (" + $numberOfPings + " times) to host: " + $addressToPing + "`n")
        ping -n $numberOfPings $addressToPing
}

# TRACE ALL THE ROUTES!!!

Write-Host("`nNow performing Trace Route tests...`n")

foreach ($addressToResolve in $addressesToResolve) {
    Write-Host("Now performing traceroute to host: " + $addressToResolve + "`n")
    tracert $addressToResolve
    Write-Host("Now performing traceroute to resolved IP from host: " + $addressToResolve + "`n")
    $resolvedAddress = (Test-Connection $addressToResolve -Count 1).IPV4Address.IPAddressToString
    tracert $resolvedAddress
}


# LOOKUP ALL OF THE NAMESERVERS!!!!

Write-Host("`nNow performing DNS tests..." + "`n")

foreach ($dnsServerToTest in $dnsServersToTest) {
    foreach ($nameServerLookupToTest in $nameServerLookupsToTest) {        
        Write-Host("Now performing lookup to " + $nameServerLookupToTest + " from DNS server" + $dnsServerToTest + "`n")
        nslookup $hostToLookup $dnsServerToTest
    }
}

Write-Host("`n`nAll done. Please thank the TekSavvy team for working so hard to help you resolve your issues.`n")
Write-Host("`nPlease email your results to:support@teksavvy.com`n")
