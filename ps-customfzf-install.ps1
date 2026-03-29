cls

[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

function /flashmind {
    $old = Get-Location
    Set-Location "C:\Files\Source-Code\Non-Kuliah\Notes-App\flashmind"
    npm run start
    Set-Location $old
}

function /memo {
    Set-Location "C:\Files\Source-Code\Non-Kuliah\Notes-App\my-memo"
}

function /sync {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('leetcode')]
        [string]$target,
        [switch]$nc
    )

    switch ($target) {
        'leetcode' {
            $scriptDir = "C:\Files\Source-Code\Non-Kuliah\Leetcode\markdown-generator"

            if ($nc) {
                py "$scriptDir\main.py" --nocheck
            } else {
                py "$scriptDir\main.py"
            }
        }
    }
}

function /src {
    Set-Location "C:\Files\Source-Code"
}

function /ta {
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet('fe', 'be', 'doc')]
        [string]$target
    )

    switch ($target) {
        'fe'  { Set-Location "C:\Files\Source-Code\Kuliah\Tugas_Akhir\Aplikasi_OBE\frontend" }
        'be'  { Set-Location "C:\Files\Source-Code\Kuliah\Tugas_Akhir\Aplikasi_OBE\backend" }
        'doc' { Set-Location "C:\Files\Source-Code\Kuliah\Tugas_Akhir\Tugas_Akhir" }
    }
}

# Custom command to navigate files/folders using fzf
function /cd {
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

# Help command to list all custom commands with descriptions
function /help {
    $commands = @(
        [PSCustomObject]@{ Command = '/flashmind'; Description = 'Start FlashMind' }
        [PSCustomObject]@{ Command = '/memo';      Description = 'Go to my-memo project directory' }
        [PSCustomObject]@{ Command = '/sync';      Description = 'Run sync script (example: /sync leetcode [-nc])' }
        [PSCustomObject]@{ Command = '/src';       Description = 'Go to Source-Code root directory' }
        [PSCustomObject]@{ Command = '/ta';        Description = 'Go to TA folder (fe|be|doc)' }
        [PSCustomObject]@{ Command = '/cd';        Description = 'Navigate files/folders with fzf' }
        [PSCustomObject]@{ Command = '/help';      Description = 'Show this custom command list' }
    )

    $commands | Format-Table -AutoSize
}


# Custom prompt function to show current directory and git branch (if inside a git repository)
function prompt {
    $branch = ''
    try {
        if (git rev-parse --is-inside-work-tree 2>$null) {
            $branchName = git rev-parse --abbrev-ref HEAD 2>$null
            if ($branchName) {
                $branchText = " [ $branchName]"
                $color = if ($branchName -eq 'main') { 'Green' } else { 'DarkGray' }

                Write-Host "$PWD" -NoNewline
                Write-Host "$branchText" -NoNewline -ForegroundColor $color
                return "> "
            }
        }
    } catch {}

    return "$PWD> "
}
