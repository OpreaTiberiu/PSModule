function Start-Task1 {
    Write-Log "`n--- TASK 1: Data Gathering & Export ---`n" -Type Title

    try {
        $sysInfo = Get-SystemInfo
        Export-Info -InputObject $sysInfo -Path './sysinfo.xml' -Format XML
        Write-Log "System info exported to sysinfo.xml`n"
    } catch {
        Write-Log "Failed to export system info: $_" -Level Red
    }

    try {
        $users = New-UserObject -Input './data/test_data.csv'
        Export-Info -InputObject $users -Path './users.xml' -Format XML
        Write-Log "Users from CSV exported to users.xml`n"
    } catch {
        Write-Log "Failed to process users CSV: $_" -Type Error
    }

    $people = @(
        @{ Title = 'Project Manager';   Email = 'alice.johnson@example.com' }
        @{ Title = 'Software Engineer'; Email = 'bob.smith@example.com' }
        @{ Title = 'HR Specialist';     Email = 'carol.white@example.com' }
        @{ Title = 'QA Analyst';        Email = 'david.brown@example.com' }
        @{ Title = 'UX Designer';       Email = 'eva.green@example.com' }
    )

    try {
        Export-Info -InputObject (New-UserObject -Input $people) -Path './people.json' -Format JSON
        Write-Log "People hash table exported to people.json`n"
    } catch {
        Write-Log "Failed to export people hash table: $_" -Type Error
    }

    $peopleObjs = @(
        [PSCustomObject]@{ Name = 'Alice Johnson';  Title = 'Project Manager';   Email = 'alice.johnson@example.com' }
        [PSCustomObject]@{ Name = 'Bob Smith';      Title = 'Software Engineer'; Email = 'bob.smith@example.com' }
        [PSCustomObject]@{ Name = 'Carol White';    Title = 'HR Specialist';     Email = 'carol.white@example.com' }
        [PSCustomObject]@{ Name = 'David Brown';    Title = 'QA Analyst';        Email = 'david.brown@example.com' }
        [PSCustomObject]@{ Name = 'Eva Green';      Title = 'UX Designer';       Email = 'eva.green@example.com' }
    )

    try {
        Export-Info -InputObject (New-UserObject -Input $peopleObjs) -Path './peopleObjs.json' -Format JSON
        Write-Log "People objects exported to peopleObjs.json`n"
    } catch {
        Write-Log "Failed to export people objects: $_" -Type Error
    }

    $singleHash = @{
        Name = 'Alice Johnson'
        Email = 'alice.johnson@example.com'
        Title = 'Project Manager'
        Password = 'VerySecurePass'
    }

    try {
        Export-Info -InputObject (New-UserObject -Input $singleHash) -Path './singleHash.xml' -Format XML
        Write-Log "Single hash exported to singleHash.xml`n"
    } catch {
        Write-Log "Failed to export single hash: $_" -Type Error
    }
}

function Start-Task2 {
    Write-Log "`n--- TASK 2: Weather Export to SQL ---`n" -Type Title
    $weatherData = $null

    try {
        $weatherData = Get-LocationWeather
        Write-Log "Weather data read from API successfully`n"
    } catch {
        Write-Log "Failed to read data from API: $_" -Type Error
        throw
    }
    try {
        Export-WeatherToSql -Weather $weatherData
        Write-Log "Weather data exported to SQL successfully`n"
    } catch {
        Write-Log "Failed to export weather data to SQL. Did you launch the database before running?" -Type Error
        Write-Log "Exception: $_" -Type Error
        throw
    }
}

if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module .\MyModule\MyModule.psm1

Write-Log "`n===== Starting PowerShell Automation Script =====`n" -Type Title

try {
    Start-Task1
    Start-Task2 
    Write-Log "`n===== Script execution completed successfully =====" -Type Title
} catch {
    Write-Log "`n[ERROR] Script encountered an error: $_" -Type Error
}