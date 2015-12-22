#header
import-module DnsServer #DNS module used for powershell dns intergration
. "C:\sql functions includes.ps1" #for functions
#make output to log file
 "begining new instance" | Out-File 'file.txt' -Append
 get-date | Out-File 'file.txt' -Append
#connection details
$MySQLAdminUserName = ‘User’ #MYSQL_Username
$MySQLAdminPassword = ‘Password’# MYSQL_Pasword
$MySQLDatabase = ‘dns’ #MYSQL_Database
$MySQLHost = ‘sqlserver.com’ #MYSQL_Server
$ConnectionString = “server=” + $MySQLHost + “;port=3306;uid=” + $MySQLAdminUserName + “;pwd=” + $MySQLAdminPassword + “;database=”+$MySQLDatabase
[void][System.Reflection.Assembly]::LoadWithPartialName(“MySql.Data”)
$Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
$Connection.ConnectionString = $ConnectionString

########
#New Record
########
$c = newrecordcreate 
$c #table of all new records
$hostarr = $c | select -exp host #array of host's
$arecordarr = $c | select -exp A_Record #array of IP addresses
$txtrecord = $c | select -exp TXT_Record #array of IP addresses

if($hostarr.Count -gt 1 ){
for($i = 0; $i -le $hostarr.Count - 1; $i++){
try
          {
Add-DnsServerResourceRecordA -IPv4Address $arecordarr[$i] -Name $hostarr[$i] -ZoneName boothtech.uk -AllowUpdateAny -TimeToLive 1:00:10
 "Added host:   $hostarr[$i]    with IP:   $arecordarr[$i]"  | Out-File 'file.txt' -Append
 Add-DnsServerResourceRecord -DescriptiveText $txtrecord[$i] -Name $hostarr[$i] -Txt -ZoneName boothtech.uk -AllowUpdateAny -TimeToLive 1:00:10
 "Added txt record:   $hostarr[$i]    with description:   $txtrecord[$i]"  | Out-File 'file.txt' -Append
 }
 catch{
"an error has occured during the New record creation loop" | Out-File 'file.txt' -Append
 }
}
newrecorddispose #marks records as added
}

elseif($hostarr.Count -eq 1 ) {
try
{
Add-DnsServerResourceRecordA -IPv4Address $arecordarr -Name $hostarr -ZoneName boothtech.uk -AllowUpdateAny -TimeToLive 1:00:10
"Added host:  $hostarr    with IP:   $arecordarr " | Out-File 'file.txt' -Append
 Add-DnsServerResourceRecord -DescriptiveText $txtrecord -Name $hostarr -Txt -ZoneName boothtech.uk -AllowUpdateAny -TimeToLive 1:00:10
 "Added txt record:  $hostarr    with description:   $txtrecord " | Out-File 'file.txt' -Append
newrecorddispose #marks records as added
}
 catch{
"an error has occured during the New record creation stage" | Out-File 'file.txt' -Append
 }
}

else {
"no new records" | Out-File 'file.txt' -Append
}

########
#update records
########

$d = updaterecordlist 
$d #table of all records with updates
$updatehostarr = $d | select -exp host #array of host's with updates
$updatearecordarr = $d | select -exp A_Record #array of IP addresses with updates

if($updatehostarr.Count -gt 1 ){
for($i = 0; $i -le $updatehostarr.Count - 1; $i++){
try
{
$oldDNSRecord = Get-DnsServerResourceRecord -ZoneName boothtech.uk -Name $updatehostarr[$i] -RRType A
$newDNSRecord = Get-DnsServerResourceRecord -ZoneName boothtech.uk -Name $updatehostarr[$i] -RRType A
$newDNSRecord.recorddata.ipv4address=[System.Net.IPAddress]::parse($updatearecordarr[$i])
Set-dnsserverresourcerecord -newinputobject $newDNSRecord -OldInputObject $oldDNSRecord -zonename boothtech.uk
"$updatehostarr[$i]  updated" | Out-File 'file.txt' -Append
}
 catch{
"an error has occured during the record update loop" | Out-File 'file.txt' -Append
 }
}
updaterecorddispose #marks records as added
}

elseif($updatehostarr.Count -eq 1 ) {
try
{
$oldDNSRecord = Get-DnsServerResourceRecord -ZoneName boothtech.uk -Name $updatehostarr -RRType A
$newDNSRecord = Get-DnsServerResourceRecord -ZoneName boothtech.uk -Name $updatehostarr -RRType A
$newip = $updatearecordarr.TrimEnd( )
$newDNSRecord.recorddata.ipv4address=[System.Net.IPAddress]::parse($newip)
Set-dnsserverresourcerecord -newinputobject $newDNSRecord -OldInputObject $oldDNSRecord -zonename boothtech.uk
" $updatehostarr  updated $updatearecordarr " | Out-File 'file.txt' -Append
updaterecorddispose #marks records as added
}
 catch{
"an error has occured during the record update stage" | Out-File 'file.txt' -Append
 }
}

else {
"no updates" | Out-File 'file.txt' -Append
}
#deletions come soon
exit 20
