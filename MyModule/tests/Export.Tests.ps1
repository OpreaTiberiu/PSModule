# Requires -Module Pester
if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module "$PSScriptRoot\..\MyModule.psm1" -Force

Describe "Export-Info" {
    BeforeAll{
        $testObject = [PSCustomObject]@{
            Name = "Test"
            Value = 123
        }
    }

    Context "Export to JSON" {
        It "Exports object to JSON file" {
            $path = Join-Path $env:TEMP "test_export.json"
            Remove-Item $path -ErrorAction SilentlyContinue

            Export-Info -InputObject $testObject -Path $path -Format JSON

            $content = Get-Content $path -Raw
            $content | Should -Match '"Name":\s*"Test"'
            $content | Should -Match '"Value":\s*123'
            Remove-Item $path
        }
    }

    Context "Export to XML" {
        It "Exports object to XML file" {
            $path = Join-Path $env:TEMP "test_export.xml"
            Remove-Item $path -ErrorAction SilentlyContinue

            Export-Info -InputObject $testObject -Path $path -Format XML

            $content = Get-Content $path -Raw
            $content | Should -Match '<Name>Test</Name>'
            $content | Should -Match '<Value>123</Value>'
            Remove-Item $path
        }
    }

    Context "Error handling" {
        It "Throws when given invalid path" {
            { Export-Info -InputObject $testObject -Path '?:\bad\path\file.json' -Format JSON } | Should -Throw
        }
        It "Throws when given invalid format" {
            { Export-Info -InputObject $testObject -Path "$env:TEMP\file.txt" -Format 'TXT' } | Should -Throw
        }
    }
}