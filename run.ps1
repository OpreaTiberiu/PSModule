if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module .\MyModule\MyModule.psm1

######################################################################################################
# TASK 1
######################################################################################################
$sysInfo = Get-SystemInfo
Export-Info -InputObject $sysInfo -Path './sysinfo.xml' -Format XML

$users = New-UserObject -Input './data/test_data.csv'
Export-Info -InputObject $users -Path './users.xml' -Format XML

$people = @(
    @{ Title = 'Project Manager';   Email = 'alice.johnson@example.com' },
    @{ Title = 'Software Engineer'; Email = 'bob.smith@example.com' },
    @{ Title = 'HR Specialist';     Email = 'carol.white@example.com' },
    @{ Title = 'QA Analyst';        Email = 'david.brown@example.com' },
    @{ Title = 'UX Designer';       Email = 'eva.green@example.com' }
)
Export-Info -InputObject $(New-UserObject -Input $people )-Path './people.json' -Format JSON

$peopleObjs = @(
    [PSCustomObject]@{ Name = 'Alice Johnson';  Title = 'Project Manager';   Email = 'alice.johnson@example.com' }
    [PSCustomObject]@{ Name = 'Bob Smith';      Title = 'Software Engineer'; Email = 'bob.smith@example.com' }
    [PSCustomObject]@{ Name = 'Carol White';    Title = 'HR Specialist';     Email = 'carol.white@example.com' }
    [PSCustomObject]@{ Name = 'David Brown';    Title = 'QA Analyst';        Email = 'david.brown@example.com' }
    [PSCustomObject]@{ Name = 'Eva Green';      Title = 'UX Designer';       Email = 'eva.green@example.com' }
)
Export-Info -InputObject $(New-UserObject -Input $peopleObjs )-Path './peopleObjs.json' -Format JSON


$singleHash = @{ Name = 'Alice Johnson';   Email = 'alice.johnson@example.com'; Title = 'Project Manager'; Password = 'VerySecurePass' }
Export-Info -InputObject $(New-UserObject -Input $singleHash )-Path './singleHash.xml' -Format XML

######################################################################################################
# TASK 2
######################################################################################################

# Used the setup from TASK 3 Docker-Compose-Stack - run docker-compose up in that project before running this
# Used PostgreSQL ODBC Driver from https://www.postgresql.org/ftp/odbc/releases/REL-17_00_0004/
Export-WeatherToSql -Weather $(Get-LocationWeather)


