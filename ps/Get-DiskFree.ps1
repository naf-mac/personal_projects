<#Usage
The function can be utilized for a variety of use cases. The following are just a few examples: 

# Default Output
By default, the function will return PS "disk" objects. From this specific output, you will notice three separate objects are returned from the local computer named DC01 with the numeric values in bytes.
PS> Get-DiskFree

FileSystem : NTFS
Type       : Local Fixed Disk
Used       : 13246943232
Volume     : C:
Available  : 29595770880
Computer   : DC01
Size       : 42842714112

FileSystem : CDFS
Type       : CD-ROM Disc
Used       : 623890432
Volume     : D:
Available  : 0
Computer   : DC01
Size       : 623890432

FileSystem : NTFS
Type       : Network Connection
Used       : 16416772096
Volume     : Z:
Available  : 26425942016
Computer   : DC01
Size       : 42842714112

# Output with the Format Option
In this example, We're performing a query against a couple of remote servers. Instead of having the function return separate PowerShell "disk" objects for each remote computer, we prefer to have the collection output in a structured table format with human-readable numbers. This would be similar to the *nix df command output with the -h option.

Note: The -Format option should only be enabled when no further numeric operations will need to be performed on the Available, Size, and Used properties. The option converts these values to the string data type. 

PS> $cred = Get-Credential -Credential 'example\administrator'
PS> 'db01','sp01' | Get-DiskFree -Credential $cred -Format | ft -GroupBy Name -auto  

   Name: DB01

Name Vol Size  Used  Avail Use% FS   Type
---- --- ----  ----  ----- ---- --   ----
DB01 C:  39.9G 15.6G 24.3G   39 NTFS Local Fixed Disk
DB01 D:  4.1G  4.1G  0B     100 CDFS CD-ROM Disc

   Name: SP01

Name Vol Size   Used   Avail Use% FS   Type
---- --- ----   ----   ----- ---- --   ----
SP01 C:  39.9G  20G    19.9G   50 NTFS Local Fixed Disk
SP01 D:  722.8M 722.8M 0B     100 UDF  CD-ROM Disc

# Low Disk Space
What if we just need a list of Windows servers in the Active Directory domain which have disk space below 20% for their C: volume?
PS> Import-Module ActiveDirectory
PS> $servers = Get-ADComputer -Filter { OperatingSystem -like '*win*server*' } | Select-Object -ExpandProperty Name
PS> Get-DiskFree -cn $servers | Where-Object { ($_.Volume -eq 'C:') -and ($_.Available / $_.Size) -lt .20 } | Select-Object Computer

Computer
--------
FS01
FS03

# Out-GridView
And in this example, we will filter on the local hard drives of four select servers and have the output displayed in an interactive table. 
PS> $cred = Get-Credential 'example\administrator'
PS> $servers = 'dc01','db01','exch01','sp01'
PS> Get-DiskFree -Credential $cred -cn $servers -Format | ? { $_.Type -like '*fixed*' } | select * -ExcludeProperty Type | Out-GridView -Title 'Windows Servers Storage Statistics'


# Output to CSV
PowerShell also gives us the ability to output to a comma-separated values (CSV) file type. This example is similar to the previous except we will also sort the disks by the percentage of usage. We've also decided to narrow the set of properties to name, volume, total size, and the percentage of the drive space currently being used. 
PS> $cred = Get-Credential 'example\administrator'
PS> $servers = 'dc01','db01','exch01','sp01'
PS> Get-DiskFree -Credential $cred -cn $servers -Format | ? { $_.Type -like '*fixed*' } | sort 'Use%' -Descending | select -Property Name,Vol,Size,'Use%' | Export-Csv -Path $HOME\Documents\windows_servers_storage_stats.csv -NoTypeInformation#>

function Get-DiskFree
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Position=0,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Alias('hostname')]
        [Alias('cn')]
        [string[]]$ComputerName = $env:COMPUTERNAME,
        
        [Parameter(Position=1,
                   Mandatory=$false)]
        [Alias('runas')]
        [System.Management.Automation.Credential()]$Credential =
        [System.Management.Automation.PSCredential]::Empty,
        
        [Parameter(Position=2)]
        [switch]$Format
    )
    
    BEGIN
    {
        function Format-HumanReadable 
        {
            param ($size)
            switch ($size) 
            {
                {$_ -ge 1PB}{"{0:#.#'P'}" -f ($size / 1PB); break}
                {$_ -ge 1TB}{"{0:#.#'T'}" -f ($size / 1TB); break}
                {$_ -ge 1GB}{"{0:#.#'G'}" -f ($size / 1GB); break}
                {$_ -ge 1MB}{"{0:#.#'M'}" -f ($size / 1MB); break}
                {$_ -ge 1KB}{"{0:#'K'}" -f ($size / 1KB); break}
                default {"{0}" -f ($size) + "B"}
            }
        }
        
        $wmiq = 'SELECT * FROM Win32_LogicalDisk WHERE Size != Null AND DriveType >= 2'
    }
    
    PROCESS
    {
        foreach ($computer in $ComputerName)
        {
            try
            {
                if ($computer -eq $env:COMPUTERNAME)
                {
                    $disks = Get-WmiObject -Query $wmiq `
                             -ComputerName $computer -ErrorAction Stop
                }
                else
                {
                    $disks = Get-WmiObject -Query $wmiq `
                             -ComputerName $computer -Credential $Credential `
                             -ErrorAction Stop
                }
                
                if ($Format)
                {
                    # Create array for $disk objects and then populate
                    $diskarray = @()
                    $disks | ForEach-Object { $diskarray += $_ }
                    
                    $diskarray | Select-Object @{n='Name';e={$_.SystemName}},
                        @{n='Vol';e={$_.DeviceID}},
                        @{n='Size';e={Format-HumanReadable $_.Size}},
                        @{n='Used';e={Format-HumanReadable `
                        (($_.Size)-($_.FreeSpace))}},
                        @{n='Avail';e={Format-HumanReadable $_.FreeSpace}},
                        @{n='Use%';e={[int](((($_.Size)-($_.FreeSpace))`
                        /($_.Size) * 100))}},
                        @{n='Free%';e={[int](((($_.FreeSpace))`
                        /($_.Size) * 100))}},
                        @{n='FS';e={$_.FileSystem}},
                        @{n='Type';e={$_.Description}}
                }
                else 
                {
                    foreach ($disk in $disks)
                    {
                        $diskprops = @{'Volume'=$disk.DeviceID;
                                   'Size'=$disk.Size;
                                   'Used'=($disk.Size - $disk.FreeSpace);
                                   'Available'=$disk.FreeSpace;
                                   'FileSystem'=$disk.FileSystem;
                                   'Type'=$disk.Description
                                   'Computer'=$disk.SystemName;}
                    
                        # Create custom PS object and apply type
                        $diskobj = New-Object -TypeName PSObject `
                                   -Property $diskprops
                        $diskobj.PSObject.TypeNames.Insert(0,'BinaryNature.DiskFree')
                    
                        Write-Output $diskobj
                    }
                }
            }
            catch 
            {
                # Check for common DCOM errors and display "friendly" output
                switch ($_)
                {
                    { $_.Exception.ErrorCode -eq 0x800706ba } `
                        { $err = 'Unavailable (Host Offline or Firewall)'; 
                            break; }
                    { $_.CategoryInfo.Reason -eq 'UnauthorizedAccessException' } `
                        { $err = 'Access denied (Check User Permissions)'; 
                            break; }
                    default { $err = $_.Exception.Message }
                }
                Write-Warning "$computer - $err"
            } 
        }
    }
    
    END {}
}
