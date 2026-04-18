# Windows 11 Dotfiles

A tiling window manager setup for Windows 11, built for someone coming from **NixOS + Hyprland**. Keybindings mirror Hyprland's `$mainMod = SUPER` layout so muscle memory carries over. Theme targets Noctalia's GruvboxAlt palette.

## Stack

| Tool | Role | Linux Equivalent |
|------|------|-----------------|
| [komorebi](https://github.com/LGUG2Z/komorebi) | Tiling window manager | Hyprland |
| [whkd](https://github.com/LGUG2Z/whkd) | Hotkey daemon | Hyprland `bind =` |
| [YASB](https://github.com/amnweb/yasb) | Status bar | Waybar / Noctalia bar |
| [Neovim](https://neovim.io) | Editor | Same |
| [Windows Terminal](https://aka.ms/terminal) | Terminal | Kitty |
| [Starship](https://starship.rs) | Shell prompt | Same |
| [Zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` | Same |

## Quick Install

On a fresh Windows 11 machine, open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm https://raw.githubusercontent.com/justingilpin/komorebi/main/setup.ps1 | iex
```

The script will walk you through everything — no manual steps required.

## What the Script Does

1. **Installs all packages** via winget
2. **Fixes PATH** for tools that land in non-standard locations
3. **Generates an SSH key** and pauses for you to add it to GitHub
4. **Clones repos** — this repo, dots (NixOS reference), connor (Windows reference)
5. **Deploys all configs** to their expected locations
6. **Sets JetBrainsMono Nerd Font** in Windows Terminal
7. **Optionally starts** komorebi + whkd + YASB

Safe to re-run — every step checks if it's already been done.

## Manual Install

If you prefer to do it yourself:

### 1. Install packages

```powershell
winget install LGUG2Z.komorebi LGUG2Z.whkd AmN.yasb
winget install Neovim.Neovim Git.Git GitHub.cli
winget install BurntSushi.ripgrep.MSVC junegunn.fzf ajeetdsouza.zoxide Starship.Starship
winget install DEVCOM.JetBrainsMonoNerdFont
```

### 2. Clone this repo

```powershell
git clone git@github.com:justingilpin/komorebi.git ~/komorebi
```

### 3. Deploy configs

```powershell
Copy-Item ~/komorebi/komorebi.json      ~/komorebi.json
Copy-Item ~/komorebi/komorebi.bar.json  ~/komorebi.bar.json
Copy-Item ~/komorebi/applications.json  ~/applications.json
Copy-Item ~/komorebi/whkdrc             ~/.config/whkdrc

New-Item -ItemType Directory -Force ~/.config/yasb
Copy-Item ~/komorebi/yasb/config.yaml   ~/.config/yasb/config.yaml
Copy-Item ~/komorebi/yasb/styles.css    ~/.config/yasb/styles.css

New-Item -ItemType Directory -Force $env:LOCALAPPDATA/nvim/lua/config
Copy-Item ~/komorebi/nvim/init.lua                      $env:LOCALAPPDATA/nvim/init.lua
Copy-Item ~/komorebi/nvim/lua/config/options.lua        $env:LOCALAPPDATA/nvim/lua/config/options.lua
Copy-Item ~/komorebi/nvim/lua/config/keymaps.lua        $env:LOCALAPPDATA/nvim/lua/config/keymaps.lua
Copy-Item ~/komorebi/nvim/lua/config/lazy.lua           $env:LOCALAPPDATA/nvim/lua/config/lazy.lua
```

### 4. Start

```powershell
komorebic start --whkd
Start-Process "C:\Program Files\yasb\yasb.exe"
```

## Keybindings

Mirrors Hyprland's `$mainMod = SUPER` layout. Full reference in [`whkdrc`](whkdrc).

### Applications
| Key | Action |
|-----|--------|
| `Win + Enter` | Terminal (Windows Terminal) |
| `Win + B` | Browser (Firefox) |
| `Win + E` | File Manager (Explorer) |
| `Win + R` | YASB launcher |

### Windows
| Key | Action |
|-----|--------|
| `Win + H/J/K/L` | Focus left/down/up/right |
| `Win + Shift + H/J/K/L` | Move window left/down/up/right |
| `Win + Alt + H/J/K/L` | Resize window |
| `Win + Shift + C` | Close window |
| `Win + V` | Toggle float |
| `Win + F` | Toggle fullscreen |
| `Win + P` | Toggle monocle |
| `Win + Space` | Cycle layout |

### Workspaces
| Key | Action |
|-----|--------|
| `Win + 1–0` | Focus workspace 1–10 |
| `Win + Shift + 1–0` | Move window to workspace 1–10 |

### Screenshots
| Key | Action |
|-----|--------|
| `Win + Print` | Screenshot (region select) |
| `Print` | Screenshot (region select) |

### System
| Key | Action |
|-----|--------|
| `Win + Shift + Q` | Restart YASB |
| `Win + Shift + R` | Reload komorebi config |
| `Win + Alt + R` | Reload whkd |

## Neovim

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and auto-install on first launch.

| Plugin | Purpose |
|--------|---------|
| gruvbox.nvim | Colorscheme (GruvboxAlt hard) |
| telescope.nvim | Fuzzy finder (`Ctrl+F` files, `Ctrl+N` grep) |
| nvim-treesitter | Syntax highlighting |
| nvim-lspconfig + mason | LSP (lua, python, typescript) |
| lualine | Statusline |
| oil.nvim | File browser (`-`) |
| neo-tree | File tree (`Space+E`) |
| noice.nvim | Better command UI |
| which-key | Keybind hints |
| copilot.vim | GitHub Copilot |
| gitsigns | Git diff in gutter |

### Key Neovim Bindings (Space = leader)
| Key | Action |
|-----|--------|
| `Ctrl+F` | Find files |
| `Ctrl+N` | Live grep |
| `Ctrl+H/J/K/L` | Navigate splits |
| `Space + /` | Vertical split |
| `Space + -` | Horizontal split |
| `Space + Y/D/P` | Clipboard yank/delete/paste |
| `-` | Open oil (file browser) |
| `Space + E` | Toggle neo-tree |
| `Space + XX` | Toggle diagnostics |

## File Structure

```
komorebi/
├── setup.ps1              # One-command setup script
├── komorebi.json          # Tiling WM config (10 workspaces, BSP, rounded corners)
├── komorebi.bar.json      # Komorebi bar config
├── applications.json      # Per-app rules (float games, etc.)
├── whkdrc                 # Hotkeys (mirrors Hyprland Super bindings)
├── yasb/
│   ├── config.yaml        # Status bar layout and widgets
│   └── styles.css         # Bar styles (semi-transparent, GruvboxAlt colors)
└── nvim/
    ├── init.lua            # Entry point, bootstraps lazy.nvim
    └── lua/config/
        ├── options.lua     # Editor settings
        ├── keymaps.lua     # Keybindings
        └── lazy.lua        # Plugin definitions
```

## References

- [justingilpin/dots](https://github.com/justingilpin/dots) — NixOS + Hyprland config (keybinding reference)
- [ConnorSweeneyDev/.config](https://github.com/ConnorSweeneyDev/.config) — Windows komorebi reference
- [komorebi docs](https://lgug2z.github.io/komorebi)
- [YASB wiki](https://github.com/amnweb/yasb/wiki)
