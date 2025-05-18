function Get-LocationCoordinates {
    <#
    .DESCRIPTION
    Gets oordinates  for a certain location

    .PARAMETER Location
    The location to check coordinates for.

    .OUTPUTS
    Coordinates for the desired location

    #>
    param (
        [string]$Location = "Fehraltorf"
    )
    $url = "https://nominatim.openstreetmap.org/search?q=$Location&format=json&limit=1"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{"User-Agent" = "PowerShell Script"}
        if ($response.Count -gt 0) {
            $lat = $response[0].lat
            $lon = $response[0].lon
            return @{
                Latitude = [double]$lat
                Longitude = [double]$lon
            }
        } else {
            Write-Warning "No coordinates found for $location"
            return $null
        }
    } catch {
        Write-Error "Failed to get coordinates: $_"
        return $null
    }
}

function Get-LocationWeather {
    <#
    .DESCRIPTION
    Gets weather info for a certain location

    .PARAMETER Location
    The location to check weather for.

    .OUTPUTS
    Current weather for the desired location

    #>
    param (
        [string]$Location = "Fehraltorf"
    )

    $coords = Get-LocationCoordinates -Location $Location
    $latitude = $coords.Latitude
    $longitude = $coords.Longitude
    $url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true"

    try {
        $response = Invoke-RestMethod -Uri $url -Method Get
    } catch {
        Write-Error "Failed to retrieve weather data: $_"
        exit 1
    }

    return $response.current_weather
}