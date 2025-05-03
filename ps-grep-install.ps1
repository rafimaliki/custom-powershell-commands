# ps-grep-install.ps1

# Install grep function
$profilePath = $PROFILE

# Define the grep function
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
