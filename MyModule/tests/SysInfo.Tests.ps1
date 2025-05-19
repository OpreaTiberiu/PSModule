# Requires -Module Pester
if (Get-Module -Name 'MyModule') {
    Remove-Module MyModule -Force
}
Import-Module "$PSScriptRoot\..\MyModule.psm1" -Force

Describe "Get-SystemInfo" {
    Context "On Windows platform" {
        It "Returns a PSCustomObject" {
            $result = Get-SystemInfo

            $result | Should -BeOfType PSCustomObject
        }
    }

    Context "On non-Windows platform" {
        It "Throws an error if not on Windows" {
            # Simulate non-Windows by temporarily unsetting $IsWindows and $env:OS
            $oldIsWindows = $IsWindows
            $oldEnvOS = $env:OS
            Remove-Variable -Name IsWindows -ErrorAction SilentlyContinue
            $env:OS = "Linux"

            { Get-SystemInfo } | Should -Throw "Get-SystemInfo failed, not a Windows machine..."

            # Restore environment
            if ($null -ne $oldIsWindows) { Set-Variable -Name IsWindows -Value $oldIsWindows }
            $env:OS = $oldEnvOS
        }
    }
}