function Get-SystemInfo {
    <#
    .DESCRIPTION
    Collects operating system, CPU, memory, and disk space information.

    .OUTPUTS
    PSCustomObject with OS, CPU, Memory, and Disk info
    #>

    try {
        if ($IsWindows -or $env:OS -eq 'Windows_NT') {
            $os = Get-CimInstance -ClassName Win32_OperatingSystem
            $cpu = Get-CimInstance -ClassName Win32_Processor
            $mem = Get-CimInstance -ClassName Win32_ComputerSystem
            $disks = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" # Local disks only

            $diskInfo = $disks | ForEach-Object {
                [PSCustomObject]@{
                    DeviceID      = $_.DeviceID
                    VolumeName    = $_.VolumeName
                    FileSystem    = $_.FileSystem
                    SizeGB       = [math]::Round($_.Size / 1GB, 2)
                    FreeSpaceGB  = [math]::Round($_.FreeSpace / 1GB, 2)
                    UsedSpaceGB  = [math]::Round(($_.Size - $_.FreeSpace) / 1GB, 2)
                }
            }

            [PSCustomObject]@{
                OSName          = $os.Caption
                OSVersion       = $os.Version
                OSArchitecture  = $os.OSArchitecture
                CPUName         = $cpu.Name
                CPUCores        = $cpu.NumberOfCores
                CPULogicalProcessors = $cpu.NumberOfLogicalProcessors
                TotalMemoryGB   = [math]::Round($mem.TotalPhysicalMemory / 1GB, 2)
                Disks           = $diskInfo
            }
        } else {
           throw "Get-SystemInfo failed, not a Windows machine..."
        }
    }
    catch {
        Write-Log "Failed to collect system information with error: $_" -Type Error
        throw
    }
}
