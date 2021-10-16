# TekSavvy-Helper-Tool
I am incredibly lazy and didn't feel like typing in all of the commands and capturing all of the output required for some troubleshooting so I wrote this script...

Usage:

Change the variables in the top of the script to suite your testing needs. I will eventually parameterize these.

You may need to change the _Exectution Policy_ to run this script.

Run PowerShell as admin and run the following command (this allows unrestricted exectution for the duration of this PowerShell session. When the console is exited, the default Execution Policy then takes effect (what ever it was *before* we ran this:
Set-ExecutionPolicy Unrestricted Process




$numberOfPings = 1
$addressesToResolve = ("google.ca")
$addressesToPing = ("192.168.1.1")
$nameServerLookupsToTest = ("shaw.ca")
$dnsServersToTest = ("206.248.154.170", "8.8.8.8")

¯\_(ツ)_/¯
