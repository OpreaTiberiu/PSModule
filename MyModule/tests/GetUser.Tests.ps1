# GetUser.Tests.ps1
# Requires -Module Pester
if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module "$PSScriptRoot\..\MyModule.psm1" -Force


Describe "New-UserObject" {

    Context "When InputObject is a CSV file path" {
        It "Should return user objects from CSV" {
            $csvPath = Join-Path $PSScriptRoot 'test_users.csv'
            @"
Name,Email
Alice,alice@example.com
Bob,bob@example.com
"@ | Set-Content $csvPath

            $result = New-UserObject -InputObject $csvPath

            $result | Should -HaveCount 2
            $result[0].Name | Should -Be 'Alice'
            $result[0].Email | Should -Be 'alice@example.com'
            $result[1].Name | Should -Be 'Bob'
            $result[1].Email | Should -Be 'bob@example.com'

            Remove-Item $csvPath
        }
    }

    Context "When InputObject is an array of hashtables" {
        It "Should return user objects from array" {
            $input = @(
                @{ Name = 'Charlie'; Email = 'charlie@example.com' }
                @{ Name = 'Dana'; Email = 'dana@example.com' }
            )
            $result = New-UserObject -InputObject $input

            $result | Should -HaveCount 2
            $result[0].Name | Should -Be 'Charlie'
            $result[1].Email | Should -Be 'dana@example.com'
        }
    }

    Context "When InputObject is a single hashtable" {
        It "Should return a single user object" {
            $input = @{ Name = 'Eve'; Email = 'eve@example.com' }
            $result = New-UserObject -InputObject $input

            $result | Should -HaveCount 1
            $result[0].Name | Should -Be 'Eve'
            $result[0].Email | Should -Be 'eve@example.com'
        }
    }

    Context "When InputObject is an array of PSCustomObjects" {
        It "Should return user objects from array" {
            $input = @(
                [PSCustomObject]@{ Name = 'Frank'; Email = 'frank@example.com' }
                [PSCustomObject]@{ Name = 'Grace'; Email = 'grace@example.com' }
            )
            $result = New-UserObject -InputObject $input

            $result | Should -HaveCount 2
            $result[0].Name | Should -Be 'Frank'
            $result[1].Email | Should -Be 'grace@example.com'
        }
    }

    Context "When InputObject is an unsupported type" {
        It "Should throw an error" {
            { New-UserObject -InputObject 12345 } | Should -Throw
        }
    }
}