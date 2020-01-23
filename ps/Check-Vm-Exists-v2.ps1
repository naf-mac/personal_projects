param($Server,$User,$Password)
Connect-ViServer $Server -User $User -Password $Password

$vms = Get-Content "C:\Users\nflor65-ba\Desktop\ps\vmlist.txt"

foreach ($vm in $vms)
{

$Exists = get-vm -name $vm -ErrorAction SilentlyContinue  
If ($Exists){  
     Write "$vm is in $Server"  | out-file C:\temp\check_vm_output.txt -Append
}
Else {
     Write "$vm is NOT in $Server" | out-file C:\temp\check_vm_output.txt -Append
}
}
