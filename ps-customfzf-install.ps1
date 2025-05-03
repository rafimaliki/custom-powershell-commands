# ps-customfzf-install.ps1

# Check if fzf is installed
$fzfPath = Get-Command fzf -ErrorAction SilentlyContinue
if (-not $fzfPath) {
    Write-Host "fzf is not found. Installing fzf..."
    
    # Try installing using winget (Windows package manager)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id=fzf.fzf
    }
    # If winget isn't available, try choco
    elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install fzf
    }
    # Download fzf manually if no package manager found
    else {
        Write-Host "No package manager found. Please install fzf manually from https://github.com/junegunn/fzf"
    }
} else {
    Write-Host "fzf is already installed."
}

# Add fzf-related functions (cdf, cdff, cdfc)
$profilePath = $PROFILE

# Define the functions

$customFzfFunctions = @'
function cdf {
    $esc = [char]27
    $current = Get-Location

    while ($true) {
        $previous = $current
        $dirs = @(Get-ChildItem -Path $current -Directory | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name + '/'
                FullPath    = $_.FullName
                DisplayName = $_.Name + '/'
                Type        = 'Directory'
            }
        })
        $files = @(Get-ChildItem -Path $current -File | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name
                FullPath    = $_.FullName
                DisplayName = "$esc[38;5;240m$($_.Name)$esc[0m"
                Type        = 'File'
            }
        })

        $items = $dirs + $files
        $fzfResult = $items.DisplayName |
            fzf --ansi --expect=enter,right,left `
                --prompt "$current> " `
                --layout=reverse-list --height=40% --border
        if (-not $fzfResult) { return }

        $key  = $fzfResult[0]
        $name = $fzfResult[1]

        $stripped = $name -replace "$esc\[[0-9;]*m", ''

        if ($key -eq 'left' -and $current -eq (Get-PSDrive -PSProvider FileSystem | Where Root -eq $current).Root) {
            continue
        }
        if ($key -eq 'left') {
            $parent = Split-Path $current -Parent
            if ($parent -ne $current) {
                $current = $parent
            }
            continue
        }

        $selected = $items | Where-Object { $_.Name -eq $stripped }
        if (-not $selected) { return }

        if ($selected.Type -eq 'Directory') {
            if ($key -eq 'enter') {
                Set-Location $selected.FullPath
                return
            } elseif ($key -eq 'right') {
                $current = $selected.FullPath
            }
        } else {
            if ($key -eq 'enter') {
                Start-Process $selected.FullPath
                return
            }
        }
    }
}

function cdfc {
    $esc = [char]27
    $current = Get-Location

    while ($true) {
        $previous = $current
        $dirs = @(Get-ChildItem -Path $current -Directory | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name + '/'
                FullPath    = $_.FullName
                DisplayName = $_.Name + '/'
                Type        = 'Directory'
            }
        })
        $files = @(Get-ChildItem -Path $current -File | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name
                FullPath    = $_.FullName
                DisplayName = "$esc[38;5;240m$($_.Name)$esc[0m"
                Type        = 'File'
            }
        })

        $items = $dirs + $files
        $fzfResult = $items.DisplayName |
            fzf --ansi --expect=enter,right,left `
                --prompt "$current> " `
                --layout=reverse-list --height=40% --border
        if (-not $fzfResult) { return }

        $key  = $fzfResult[0]
        $name = $fzfResult[1]

        # strip ANSI from selection to find object
        $stripped = $name -replace "$esc\[[0-9;]*m", ''

        if ($key -eq 'left' -and $current -eq (Get-PSDrive -PSProvider FileSystem | Where Root -eq $current).Root) {
            continue
        }
        if ($key -eq 'left') {
            $parent = Split-Path $current -Parent
            if ($parent -ne $current) {
                $current = $parent
            }
            continue
        }

        $selected = $items | Where-Object { $_.Name -eq $stripped }
        if (-not $selected) { return }

        if ($selected.Type -eq 'Directory') {
            if ($key -eq 'enter') {
                Set-Location $selected.FullPath
                code .
                return
            } elseif ($key -eq 'right') {
                $current = $selected.FullPath
            }
        } else {
            if ($key -eq 'enter') {
                Start-Process $selected.FullPath
                return
            }
        }
    }
}

function cdff {
    $esc = [char]27
    $current = Get-Location

    while ($true) {
        $previous = $current
        $dirs = @(Get-ChildItem -Path $current -Directory | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name + '/'
                FullPath    = $_.FullName
                DisplayName = $_.Name + '/'
                Type        = 'Directory'
            }
        })
        $files = @(Get-ChildItem -Path $current -File | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name
                FullPath    = $_.FullName
                DisplayName = "$esc[38;5;240m$($_.Name)$esc[0m"
                Type        = 'File'
            }
        })

        $items = $dirs + $files
        $fzfResult = $items.DisplayName |
            fzf --ansi --expect=enter,right,left `
                --prompt "$current> " `
                --layout=reverse-list --height=40% --border
        if (-not $fzfResult) { return }

        $key  = $fzfResult[0]
        $name = $fzfResult[1]

        # strip ANSI from selection to find object
        $stripped = $name -replace "$esc\[[0-9;]*m", ''

        if ($key -eq 'left' -and $current -eq (Get-PSDrive -PSProvider FileSystem | Where Root -eq $current).Root) {
            continue
        }
        if ($key -eq 'left') {
            $parent = Split-Path $current -Parent
            if ($parent -ne $current) {
                $current = $parent
            }
            continue
        }

        $selected = $items | Where-Object { $_.Name -eq $stripped }
        if (-not $selected) { return }

        if ($selected.Type -eq 'Directory') {
            if ($key -eq 'enter') {
                Set-Location $selected.FullPath
                Start-Process explorer .
                return
            } elseif ($key -eq 'right') {
                $current = $selected.FullPath
            }
        } else {
            if ($key -eq 'enter') {
                Start-Process $selected.FullPath
                return
            }
        }
    }
}

'@


# Add functions to profile
Add-Content -Path $profilePath -Value $customFzfFunctions

Write-Host "fzf functions (cdf, cdff, cdfc) have been added to your PowerShell profile."
Write-Host "Please restart your PowerShell session to use the new functions."
