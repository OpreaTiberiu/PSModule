function Write-Log {
    param (
        [string]$Message,
        [ValidateSet("Info", "Warning", "Error", "Title")]
        [string]$Type = "Info"
    )

    switch ($Type) {
        "Info"    { Write-Host "[INFO]    $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
        "Error"   { Write-Host "[ERROR]   $Message" -ForegroundColor Red }
        "Title"   { Write-Host "$Message" -ForegroundColor Cyan }
    }
}