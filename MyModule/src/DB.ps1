function Export-WeatherToSql {
    <#
    .DESCRIPTION
    Exports wheather data to sql

    .PARAMETER Weather
    Weather data to be exporter

    .PARAMETER SqlServerInstance
    Sql server to export to

    .PARAMETER DatabaseName
    Database name where data will be exported

    .PARAMETER TableName
    Table where data will be exported

    #>
    param (
        [Parameter(Mandatory)]
        [Object]$Weather,
        [string]$SqlServerInstance = "localhost",
        [string]$DatabaseName = "WeatherDB",
        [string]$TableName = "FehraltorfWeather"
    )
 
    $connStr = "Driver={PostgreSQL Unicode};Server=localhost;Port=5432;Database=WeatherDB;Uid=admin;Pwd=admin123;"
    $conn = $null
    $command = @"
INSERT INTO $TableName (TimeStamp, Temperature, WindSpeed, WindDirection, WeatherCode)
VALUES (
    '$($Weather.time)',
    $($Weather.temperature),
    $($Weather.windspeed),
    $($Weather.winddirection),
    $($Weather.weathercode)
)
"@

    try {
        $conn = New-Object System.Data.Odbc.OdbcConnection($connStr)
        $conn.Open()
        $cmd = $conn.CreateCommand()
        $cmd.CommandText = $command
        $cmd.ExecuteNonQuery()
    } catch {
        Write-Error "Database insertion failed: $_"
    } finally {
        if ($conn) {
            $conn.Close()
        }
    }
}