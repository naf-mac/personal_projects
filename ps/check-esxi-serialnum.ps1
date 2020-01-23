$esxlist = get-vmhost

foreach($Esx in $esxlist){

$esxcli=Get-EsxCli -VMHost $Esx

write-host $Esx.Name $esxcli.hardware.platform.get().SerialNumber

}
