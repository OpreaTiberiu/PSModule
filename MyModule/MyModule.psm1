$ErrorActionPreference = 'Stop'

Get-ChildItem -Path "$PSScriptRoot\src\*.ps1" | ForEach-Object {
    . $_.FullName
}

Export-ModuleMember -Function Get-SystemInfo, New-UserObject, Export-Info, Get-LocationWeather, Export-WeatherToSql, Write-Log, Get-LocationCoordinates
