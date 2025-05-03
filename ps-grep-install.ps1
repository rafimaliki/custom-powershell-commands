# ps-grep-install.ps1

# Install grep function
$profilePath = $PROFILE

# Get PowerShell profile path
$profilePath = $PROFILE

# Ensure the directory exists
$profileDir = Split-Path $profilePath
if (-not (Test-Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
}

# Ensure the profile file exists
if (-not (Test-Path $profilePath)) {
    New-Item -Path $profilePath -ItemType File -Force | Out-Null
}

# Function
$grepFunction = @'
function grep {
    param(
        [string]$Pattern,   # The pattern you're searching for
        [string]$Path       # The path to start the search from
    )
    
    # Default to current directory if no path is specified
    if (-not $Path) {
        $Path = Get-Location
    }

    # Use Get-ChildItem to get all files recursively, then pipe to Select-String
    Get-ChildItem -Path $Path -Recurse -File | Select-String -Pattern $Pattern
}
'@

# Add grep function to profile
Add-Content -Path $profilePath -Value $grepFunction

Write-Host "grep function has been added to your PowerShell profile."
Write-Host "Please restart your PowerShell session to use the new function."
