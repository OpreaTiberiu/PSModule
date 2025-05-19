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
    
    try {
        $url = "https://nominatim.openstreetmap.org/search?q=$Location&format=json&limit=1"
        $response = Invoke-RestMethod -Uri $url -Method Get -Headers @{"User-Agent" = "PowerShell Script"}

        if ($response.Count -gt 0) {
            $lat = $response[0].lat
            $lon = $response[0].lon

            return @{
                Latitude = [double]$lat
                Longitude = [double]$lon
            }
        } else {
            throw "No coordinates found for $location"
        }
    } catch {
        Write-Log "Failed to get coordinates with error: $_" -Type Error
        throw
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

    try {
        $coords = Get-LocationCoordinates -Location $Location
        $latitude = $coords.Latitude
        $longitude = $coords.Longitude
        $url = "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true"
        $response = Invoke-RestMethod -Uri $url -Method Get
        
        return $response.current_weather
    } catch {
        Write-Log "Failed to retrieve weather data with error: $_" -Type Error
        throw
    }
}