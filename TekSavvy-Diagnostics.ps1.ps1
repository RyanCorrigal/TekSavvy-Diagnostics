# these will be put into script parameters
$numberOfPings = 50
$addressesToResolve = ("google.ca")
$addressesToPing = ("192.168.1.1")
$nameServerLookupsToTest = ("shaw.ca")
$dnsServersToTest = ("206.248.154.170", "8.8.8.8")

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
    Write-Verbose "External IP is $ipAddress"
    return $ipAddress
}

$publicIpAddress = (getPublicIpAddress).ip


# PING ALL THE THINGS!!!!!!!!!!!

# ping our router's IP
$addressesToPing = ($publicIpAddress, 'google.ca', '192.168.1.1')

# ping the provided named addresses and then the subsequently resolved addresses
foreach ($addressToResolve in $addressesToResolve) {
    ping -n $numberOfPings $addressToResolve
    ping -n $numberOfPings (Test-Connection $addressToResolve -Count 1).IPV4Address.IPAddressToString
}

# ping all other addresses provided in the top
foreach ($addressToPing in $addressesToPing) {
    ping -n $numberOfPings $addressToPing
}

# TRACE ALL THE ROUTES!!!

foreach ($addressToResolve in $addressesToResolve) {
    tracert $addressToResolve
    tracert (Test-Connection $addressToResolve -Count 1).IPV4Address.IPAddressToString
}


# LOOKUP ALL OF THE NAMESERVERS!!!!

foreach ($dnsServerToTest in $dnsServersToTest) {
    foreach ($nameServerLookupToTest in $nameServerLookupsToTest) {        
        nslookup $hostToLookup $dnsServerToTest
    }
}

Write-Host("Add done. Please thank the TekSavvy team for working so hard to help you resolve your issues. 👌")
Write-Host("Please email your results to:support@teksavvy.com")
