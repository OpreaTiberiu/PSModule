function New-UserObject {
    <#
    .DESCRIPTION
    Reads user data from CSV file path or array of objects and creates User objects.

    .PARAMETER Input
    Path to CSV file  an array of CustomObjects or Hashtables.

    .OUTPUTS
    Array of objects representing users
    #>
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject
    )
    
    $outputUsers = @()

    if ($InputObject -is [string] -and (Test-Path $InputObject) -and ($InputObject -like '*.csv')) {
        try {
            $data = Import-Csv -Path $InputObject -ErrorAction Stop
        }
        catch {
            Write-Error "Could not parse CSV input: $_"
            exit 1
        }
        foreach ($user in $data) {
            $userHash = @{}

            foreach ($prop in $user.PSObject.Properties) {
                $userHash[$prop.Name] = $prop.Value
            }
            $outputUsers += [PSCustomObject]$userHash
        }
    } elseif ($InputObject -is [System.Collections.IEnumerable] -and -not ($InputObject -is [string])) {
        foreach ($item in $InputObject) {
            if ($item -is [hashtable] -or $item -is [PSCustomObject]) {
                $outputUsers += [PSCustomObject]$item
            } else {
                Write-Error "Unknown item type in list: $($item.GetType().Name)"

                exit 1
            }
        }
    } elseif ($InputObject -is [hashtable] -or $InputObject -is [PSCustomObject]) {
        $outputUsers += [PSCustomObject]$InputObject
    } else {
        Write-Error "Unknown input type: $($InputObject.GetType().Name)"

        exit 1
    }
    return $outputUsers
}
