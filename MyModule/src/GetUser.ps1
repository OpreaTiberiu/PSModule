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
    
    try {
        $outputUsers = @()

        if ($InputObject -is [string] -and (Test-Path $InputObject) -and ($InputObject -like '*.csv')) {
            try {
                $data = Import-Csv -Path $InputObject -ErrorAction Stop
            }
            catch {
                Write-Log "Could not parse CSV input: $_" -Type Error
                throw
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
                    throw "Unknown item type in list: $($item.GetType().Name)"
                }
            }
        } elseif ($InputObject -is [hashtable] -or $InputObject -is [PSCustomObject]) {
            $outputUsers += [PSCustomObject]$InputObject
        } else {
            throw "Unknown input type: $($InputObject.GetType().Name)"
        }
        return $outputUsers
    } catch {
        Write-Log "Failed to create user objects: $_" -Type Error
        throw
    }
}
