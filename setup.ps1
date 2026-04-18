#Requires -RunAsAdministrator
# Windows 11 Setup Script
# Repo: https://github.com/justingilpin/komorebi
#
# Usage (fresh machine):
#   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
#   irm https://raw.githubusercontent.com/justingilpin/komorebi/main/setup.ps1 | iex
#
# Or clone first then run:
#   git clone https://github.com/justingilpin/komorebi ~/komorebi
#   ~/komorebi/setup.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$GITHUB_USER = "justingilpin"
$REPOS = @{
    komorebi = "git@github.com:justingilpin/komorebi.git"
    dots     = "git@github.com:justingilpin/dots.git"
    connor   = "git@github.com:ConnorSweeneyDev/.config.git"
}

function Write-Step { param($msg) Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok   { param($msg) Write-Host "    OK: $msg" -ForegroundColor Green }
function Write-Skip { param($msg) Write-Host "    --: $msg (already done)" -ForegroundColor DarkGray }

# ─────────────────────────────────────────────────────────────────────────────
# 1. WINGET PACKAGES
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Installing packages via winget"

$packages = @(
    # Window manager stack
    @{ id = "LGUG2Z.komorebi";              name = "komorebi" },
    @{ id = "LGUG2Z.whkd";                  name = "whkd (hotkey daemon)" },
    @{ id = "AmN.yasb";                     name = "YASB (status bar)" },

    # Terminal / shell
    @{ id = "Microsoft.WindowsTerminal";    name = "Windows Terminal" },
    @{ id = "Starship.Starship";            name = "starship prompt" },
    @{ id = "ajeetdsouza.zoxide";           name = "zoxide" },

    # Editor
    @{ id = "Neovim.Neovim";               name = "neovim" },

    # Dev tools
    @{ id = "Git.Git";                      name = "git" },
    @{ id = "GitHub.cli";                   name = "gh (GitHub CLI)" },
    @{ id = "BurntSushi.ripgrep.MSVC";      name = "ripgrep" },
    @{ id = "junegunn.fzf";                 name = "fzf" },

    # Browser
    @{ id = "Mozilla.Firefox";              name = "Firefox" },

    # Fonts
    @{ id = "DEVCOM.JetBrainsMonoNerdFont"; name = "JetBrainsMono Nerd Font" }
)

foreach ($pkg in $packages) {
    $installed = winget list --id $pkg.id --exact 2>$null | Select-String $pkg.id
    if ($installed) {
        Write-Skip $pkg.name
    } else {
        Write-Host "    Installing $($pkg.name)..." -NoNewline
        winget install --id $pkg.id --accept-package-agreements --accept-source-agreements --silent
        Write-Ok $pkg.name
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# 2. PATH — add tools that winget drops in non-standard locations
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Updating PATH"

$pathsToAdd = @(
    "C:\Program Files\whkd\bin",
    "C:\Program Files\Neovim\bin",
    "C:\Program Files\starship\bin",
    "C:\Program Files\GitHub CLI"
)

# WinGet portable packages land in AppData — find them dynamically
$wingetPkgs = "$env:LOCALAPPDATA\Microsoft\WinGet\Packages"
@("zoxide*", "ripgrep*", "fzf*") | ForEach-Object {
    $match = Get-ChildItem $wingetPkgs -Filter $_ -Directory -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($match) { $pathsToAdd += $match.FullName }
}

$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
$newPaths = $pathsToAdd | Where-Object { $_ -and $currentPath -notlike "*$_*" }
if ($newPaths) {
    [Environment]::SetEnvironmentVariable("PATH", $currentPath + ";" + ($newPaths -join ";"), "User")
    Write-Ok "Added: $($newPaths -join ', ')"
} else {
    Write-Skip "PATH already up to date"
}

# Reload PATH in current session
$env:PATH = [Environment]::GetEnvironmentVariable("PATH","Machine") + ";" +
            [Environment]::GetEnvironmentVariable("PATH","User")

# ─────────────────────────────────────────────────────────────────────────────
# 3. SSH KEY
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "SSH key"

$sshKey = "$env:USERPROFILE\.ssh\id_ed25519"
if (Test-Path $sshKey) {
    Write-Skip "SSH key already exists at $sshKey"
} else {
    ssh-keygen -t ed25519 -C "$GITHUB_USER@windows" -f $sshKey -N '""'
    Write-Ok "SSH key generated"
    Write-Host ""
    Write-Host "    Add this public key to GitHub → Settings → SSH keys:" -ForegroundColor Yellow
    Get-Content "$sshKey.pub"
    Write-Host ""
    Read-Host "    Press Enter once you've added the key to GitHub"
}

# ─────────────────────────────────────────────────────────────────────────────
# 4. GIT CONFIG
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Git global config"

$gitEmail = git config --global user.email 2>$null
if (-not $gitEmail) {
    git config --global user.email "justin.lee.gilpin@gmail.com"
    git config --global user.name  "justingilpin"
    git config --global core.autocrlf false
    Write-Ok "Git config set"
} else {
    Write-Skip "Git already configured as $gitEmail"
}

# ─────────────────────────────────────────────────────────────────────────────
# 5. CLONE REPOS
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Cloning repos"

foreach ($entry in $REPOS.GetEnumerator()) {
    $dest = "$env:USERPROFILE\$($entry.Key)"
    if (Test-Path $dest) {
        Write-Skip "$($entry.Key) already at $dest"
    } else {
        git clone $entry.Value $dest
        Write-Ok "Cloned $($entry.Key) → $dest"
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# 6. KOMOREBI CONFIG
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Deploying komorebi config"

$komorebiSrc = "$env:USERPROFILE\komorebi"

@(
    @{ src = "$komorebiSrc\komorebi.json";      dst = "$env:USERPROFILE\komorebi.json" },
    @{ src = "$komorebiSrc\komorebi.bar.json";  dst = "$env:USERPROFILE\komorebi.bar.json" },
    @{ src = "$komorebiSrc\applications.json";  dst = "$env:USERPROFILE\applications.json" },
    @{ src = "$komorebiSrc\whkdrc";             dst = "$env:USERPROFILE\.config\whkdrc" }
) | ForEach-Object {
    $dir = Split-Path $_.dst
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }
    Copy-Item $_.src $_.dst -Force
    Write-Ok "$($_.src | Split-Path -Leaf) → $($_.dst)"
}

# ─────────────────────────────────────────────────────────────────────────────
# 7. YASB CONFIG
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Deploying YASB config"

$yasbDst = "$env:USERPROFILE\.config\yasb"
New-Item -ItemType Directory -Force $yasbDst | Out-Null

@("config.yaml", "styles.css") | ForEach-Object {
    Copy-Item "$komorebiSrc\yasb\$_" "$yasbDst\$_" -Force
    Write-Ok "$_ → $yasbDst"
}

# ─────────────────────────────────────────────────────────────────────────────
# 8. NEOVIM CONFIG
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Deploying neovim config"

$nvimDst = "$env:LOCALAPPDATA\nvim"
New-Item -ItemType Directory -Force "$nvimDst\lua\config" | Out-Null

Copy-Item "$komorebiSrc\nvim\init.lua" "$nvimDst\init.lua" -Force
Copy-Item "$komorebiSrc\nvim\lua\config\options.lua" "$nvimDst\lua\config\options.lua" -Force
Copy-Item "$komorebiSrc\nvim\lua\config\keymaps.lua" "$nvimDst\lua\config\keymaps.lua" -Force
Copy-Item "$komorebiSrc\nvim\lua\config\lazy.lua"    "$nvimDst\lua\config\lazy.lua"    -Force
Write-Ok "nvim config deployed to $nvimDst"
Write-Host "    Run 'nvim' to auto-install plugins on first launch." -ForegroundColor Yellow

# ─────────────────────────────────────────────────────────────────────────────
# 9. WINDOWS TERMINAL — set font
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Windows Terminal font"

$wtSettings = "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
if (Test-Path $wtSettings) {
    $settings = Get-Content $wtSettings | ConvertFrom-Json
    if ($settings.profiles.defaults.font.face -eq "JetBrainsMono Nerd Font Propo") {
        Write-Skip "Font already set"
    } else {
        if (-not $settings.profiles.defaults.font) {
            $settings.profiles.defaults | Add-Member -NotePropertyName font -NotePropertyValue ([PSCustomObject]@{}) -Force
        }
        $settings.profiles.defaults.font | Add-Member -NotePropertyName face -NotePropertyValue "JetBrainsMono Nerd Font Propo" -Force
        $settings | ConvertTo-Json -Depth 20 | Set-Content $wtSettings
        Write-Ok "Font set to JetBrainsMono Nerd Font Propo"
    }
} else {
    Write-Skip "Windows Terminal settings not found (may not be installed yet)"
}

# ─────────────────────────────────────────────────────────────────────────────
# 10. START KOMOREBI + YASB
# ─────────────────────────────────────────────────────────────────────────────
Write-Step "Starting komorebi and YASB"

$answer = Read-Host "    Start komorebi + whkd + YASB now? (y/n)"
if ($answer -eq "y") {
    komorebic start --whkd
    Start-Sleep 2
    Start-Process "C:\Program Files\yasb\yasb.exe"
    Write-Ok "komorebi and YASB started"
} else {
    Write-Host "    To start manually:" -ForegroundColor Yellow
    Write-Host "      komorebic start --whkd"
    Write-Host "      Start-Process 'C:\Program Files\yasb\yasb.exe'"
}

# ─────────────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Setup complete." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open a new terminal for PATH changes to take effect"
Write-Host "  2. Run 'nvim' to install plugins (lazy.nvim auto-installs on first launch)"
Write-Host "  3. Set Windows Terminal font: JetBrainsMono Nerd Font Propo"
Write-Host "  4. Paste NoctaliaGruvboxAlt colors.json to complete theme setup"
Write-Host ""
