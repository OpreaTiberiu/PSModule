function Export-Info {
    <#
    .DESCRIPTION
    Exports an object to XML or JSON file.

    .PARAMETER InputObject
    The object to export.

    .PARAMETER Path
    The file path to export to.

    .PARAMETER Format
    The export format: JSON or XML (default JSON).

    #>
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject,

        [Parameter(Mandatory)]
        [string]$Path,

        [ValidateSet('JSON', 'XML')]
        [string]$Format = 'JSON'
    )
    try {
        switch ($Format) {
            'JSON' {
                $json = $InputObject | ConvertTo-Json -Depth 10 -ErrorAction Stop
                $json | Out-File -FilePath $Path -Encoding utf8 -ErrorAction Stop
            }
            'XML' {
                Export-ToReadableXmlWriter -InputObject $InputObject -Path $Path
            }
        }
    }
    catch {
        Write-Log "Failed to export object to $Format at $Path. Error: $_" -Type Error
        throw
    }
}

function Export-ToReadableXmlWriter {
    <#
    .DESCRIPTION
    Exports an object to readable XML.

    .PARAMETER InputObject
    The object to export.

    .PARAMETER Path
    The file path to export to.

    #>
    param (
        [Parameter(Mandatory)]
        [Object[]]$InputObject,

        [Parameter(Mandatory)]
        [string]$Path
    )

    try {
        $settings = New-Object System.Xml.XmlWriterSettings
        $settings.Indent = $true
        $settings.IndentChars = "  "
        $settings.NewLineChars = "`r`n"
        $settings.NewLineHandling = "Replace"
        $writer = $null

        $writer = [System.Xml.XmlWriter]::Create($Path, $settings)
        $writer.WriteStartDocument()
        $writer.WriteStartElement("Root")

        foreach ($obj in $InputObject) {
            $writer.WriteStartElement("Element")

            foreach ($prop in $obj.PSObject.Properties) {
                Export-NestedProperty -InputObject $prop -Writer $writer
            }
            $writer.WriteEndElement()
        }
        $writer.WriteEndElement()
        $writer.WriteEndDocument()
        $writer.Flush()
    } 
    catch {
        Write-Log "Failed to export object to XML at $Path with error: $_" -Type Error
        throw
    }
    finally {
        if ($writer) {
            $writer.Close()
        }
    }
}

function Export-NestedProperty {
    <#
    .DESCRIPTION
    Exports a nested property to xml.

    .PARAMETER InputObject
    The object to export.

    .PARAMETER Writer
    The writer used for exporting.

    #>
    param (
        [Parameter(Mandatory)]
        [Object]$InputObject,

        [Parameter(Mandatory)]
        [System.Xml.XmlWriter]$Writer
    )

    try {
        if ($InputObject.value -is [System.Collections.IEnumerable] -and -not ($InputObject.value -is [string])) {
            for ($index=0; $index -le $InputObject.value.Length - 1; $index++) {
                $writer.WriteStartElement("$($InputObject.Name)_$index")
                $itemObject = [PSCustomObject]$InputObject.value[$index]

                foreach ($prop in $itemObject.PSObject.Properties) {
                    Export-NestedProperty -InputObject $prop -Writer $writer
                }
                $writer.WriteEndElement()
            }
        } else {
            $writer.WriteElementString($InputObject.Name, [string]$InputObject.value)
        }
    } catch {
        Write-Log "Failed to export nested property with error: $_" -Type Error
        throw
    }
}