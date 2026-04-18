# Komorebi + YASB Config

Windows tiling window manager setup using [komorebi](https://github.com/LGUG2Z/komorebi) and [YASB](https://github.com/amnweb/yasb).

## Files

| File | Description |
|------|-------------|
| `komorebi.json` | Komorebi static config |
| `komorebi.bar.json` | Komorebi bar config |
| `applications.json` | App-specific komorebi rules |
| `whkdrc` | Hotkey config (whkd) |
| `yasb/config.yaml` | YASB bar config |
| `yasb/styles.css` | YASB styles |

## Install

```powershell
winget install LGUG2Z.komorebi
winget install AmN.yasb
```

## Usage

Copy configs to their expected locations:

```powershell
Copy-Item komorebi.json ~\komorebi.json
Copy-Item komorebi.bar.json ~\komorebi.bar.json
Copy-Item applications.json ~\applications.json
Copy-Item whkdrc ~\.config\whkdrc
Copy-Item yasb\config.yaml "$env:USERPROFILE\.config\yasb\config.yaml" -Force
Copy-Item yasb\styles.css "$env:USERPROFILE\.config\yasb\styles.css" -Force
```

Then start:

```powershell
komorebic start --whkd --bar
```
