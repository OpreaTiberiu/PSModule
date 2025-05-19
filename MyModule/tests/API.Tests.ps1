# Requires -Module Pester
if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module "$PSScriptRoot\..\MyModule.psm1" -Force


Describe "Get-LocationCoordinates" {
    Context "When called with a valid location" {
        It "Returns a hashtable with Latitude and Longitude" {
            $result = Get-LocationCoordinates -Location "Zurich"
            $result | Should -BeOfType 'Hashtable'
            $result.Keys | Should -Contain "Latitude"
            $result.Keys | Should -Contain "Longitude"
            $result.Latitude | Should -BeOfType 'Double'
            $result.Longitude | Should -BeOfType 'Double'
        }
    }

    Context "When called with an invalid location" {
        It "Throws an error" {
            { Get-LocationCoordinates -Location "asdkjfhaksjdhfakjsdhf" } | Should -Throw
        }
    }
}

Describe "Get-LocationWeather" {
    Context "When called with a valid location" {
        It "Returns a weather object with expected properties" {
            $weather = Get-LocationWeather -Location "Zurich"
            $weather | Should -Not -BeNullOrEmpty
            $weather | Should -BeOfType 'PSCustomObject'
            $weather.PSObject.Properties.Name | Should -Contain "temperature"
            $weather.PSObject.Properties.Name | Should -Contain "windspeed"
        }
    }

    Context "When called with an invalid location" {
        It "Throws an error" {
            { Get-LocationWeather -Location "asdkjfhaksjdhfakjsdhf" } | Should -Throw
        }
    }
}
