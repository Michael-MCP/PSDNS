Function ipcollect{
  <#
  .SYNOPSIS
  Returns A_Record from MYSQL records
  .DESCRIPTION
  Returns A_record for given host
  .EXAMPLE
  get-A_Record -www
  .EXAMPLE
  get-a_record -host
  .PARAMETER computername
  The computer name to query. Just one.
  .PARAMETER logname
  The name of a file to write failed computer names to. Defaults to errors.txt.
  #>
 [CmdletBinding()]
 Param(
 [Parameter(
Mandatory = $true,
ParameterSetName = '',
ValueFromPipeline = $true)]
[string]$hostname
)
$Query = 'SELECT `A_Record` FROM `boothtech.uk` WHERE `HOST` = "' + $hostname + '"'
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, “data”)
$a = $dataSet.Tables[ 0 ] | select -exp A_Record
$Connection.Close()
      Write-Output ($a)
    }

Function recordtoupdate{
Param(
 [Parameter(
Mandatory = $true,
ParameterSetName = '',
ValueFromPipeline = $true)]
[string]$hostname
)

#call function
$b = ipcollect $hostname
$oldobj = get-dnsserverresourcerecord  -Name $hostname -zonename "boothtech.uk" -rrtype "A"
$newobj = get-dnsserverresourcerecord  -Name $hostname -zonename "boothtech.uk" -rrtype "A"
#$updateip = "8.8.8.8" #Public Ip address from mysql 
$newobj.recorddata.ipv4address=[System.Net.IPAddress]::parse($b)
Set-dnsserverresourcerecord -newinputobject $newobj -OldInputObject $oldobj -zonename "boothtech.uk" 
}

Function newrecordcreate{
$Query = 'SELECT `host`,`A_Record`, `TXT_Record` FROM `boothtech.uk` WHERE `added` = 1'
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, “data”)
$a = $dataSet.Tables[ 0 ] | select 
$Connection.Close()
#UPDATE `boothtech.uk` SET `added` = '0' WHERE `boothtech.uk`.`added` = '1';
      Write-Output ($a)
}
Function newrecorddispose{
$Query = 'UPDATE `boothtech.uk` SET `added` =0 WHERE `boothtech.uk`.`added` =1'
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$Command.ExecuteNonQuery()
$Connection.Close()
Write-Output ("Marked as added")
}
Function updaterecordlist{
$Query = 'SELECT `host`,`A_Record` FROM `boothtech.uk` WHERE `updated` = 1'
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
$DataSet = New-Object System.Data.DataSet
$RecordCount = $dataAdapter.Fill($dataSet, “data”)
$a = $dataSet.Tables[ 0 ] | select 
$Connection.Close()
#UPDATE `boothtech.uk` SET `added` = '0' WHERE `boothtech.uk`.`added` = '1';
      Write-Output ($a)
}
Function updaterecorddispose{
$Query = 'UPDATE `boothtech.uk` SET `updated` =0 WHERE `boothtech.uk`.`updated` =1'
$Connection.Open()
$Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
$Command.ExecuteNonQuery()
$Connection.Close()
Write-Output ("Marked as added")
}
