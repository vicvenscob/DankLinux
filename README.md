<div align="center">

```
██████╗  █████╗ ███╗   ██╗██╗  ██╗██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
██║  ██║███████║██╔██╗ ██║█████╔╝ ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ 
██║  ██║██╔══██║██║╚██╗██║██╔═██╗ ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ 
██████╔╝██║  ██║██║ ╚████║██║  ██╗███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
```

**modern arch. no compromises.**

![Arch](https://img.shields.io/badge/Arch-based-cba6f7?style=flat-square&logo=archlinux&logoColor=1e1e2e&labelColor=1e1e2e)
![Wayland](https://img.shields.io/badge/Wayland-first-89b4fa?style=flat-square&logo=wayland&logoColor=1e1e2e&labelColor=1e1e2e)
![Niri](https://img.shields.io/badge/niri-+miri-a6e3a1?style=flat-square&logoColor=1e1e2e&labelColor=1e1e2e)
![Theme](https://img.shields.io/badge/Catppuccin-Mocha-f5c2e7?style=flat-square&logoColor=1e1e2e&labelColor=1e1e2e)

</div>

---

DankLinux is an opinionated Arch-based install script that drops a fully configured, modern Wayland desktop on top of a bare Arch system. No GUI wizard. No bloat. One script, one stack, one aesthetic.

Inspired by [omarchy](https://github.com/basecamp/omarchy). Built for people who know what they want.

## Stack

| Layer | Tool |
|---|---|
| Compositor | [niri](https://github.com/niri-wm/niri) + [miri](https://github.com/MintyDoggo/miri) |
| Bar | [DMS](https://github.com/niri-wm/niri) (niri-native) |
| Launcher | [walker](https://github.com/abenz1267/walker) |
| Terminal | [ghostty](https://ghostty.org) |
| Shell | [fish](https://fishshell.com) |
| Editor | [GarrysVim](https://github.com/ihave17bucks/GarrysVim) |
| Notifications | [swaync](https://github.com/ErikReider/SwayNotificationCenter) |
| Browser | firefox |
| Files | [yazi](https://github.com/sxyazi/yazi) |
| Music | [strawberry](https://www.strawberrymusicplayer.org) |
| Theme | [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) everywhere |
| Audio | pipewire + wireplumber |
| Fonts | JetBrainsMono Nerd Font |

## Install

Run this on a **fresh Arch install** (post-`archinstall` or manual base). Do **not** run as root.

```bash
curl -fsSL https://raw.githubusercontent.com/ihave17bucks/danklinux/main/install.sh | bash
```

The installer will ask:

- **Username** — your user account name
- **Hostname** — machine hostname
- **GPU** — `nvidia` / `amd` / `intel`

Then it handles the rest.

## What gets configured

- niri with miri master stack tiling, full keybinds, rounded corners
- ghostty with Catppuccin Mocha, JetBrainsMono, blur
- fish with aliases, yazi cwd wrapper, starship prompt
- walker with Mocha-themed CSS
- swaync with Mocha-themed notification center
- GTK3 + GTK4 themed to Catppuccin Mocha + Papirus-Dark icons
- GPU-specific Wayland environment variables
- pipewire services enabled out of the box
- GarrysVim cloned to `~/.config/nvim`

## Keybinds

| Bind | Action |
|---|---|
| `Mod+Return` | terminal (ghostty) |
| `Mod+Space` | launcher (walker) |
| `Mod+E` | files (yazi) |
| `Mod+B` | browser (firefox) |
| `Mod+M` | music (strawberry) |
| `Mod+N` | notification center |
| `Mod+Q` | close window |
| `Mod+F` | maximize column |
| `Mod+Shift+F` | fullscreen |
| `Mod+H/J/K/L` | focus navigation |
| `Mod+Shift+M` | miri master layout |
| `Mod+Shift+S` | miri scroll layout |
| `Mod+Tab` | cycle layout mode |
| `Mod+1–5` | switch workspace |
| `Mod+Shift+1–5` | move window to workspace |
| `Print` | area screenshot |
| `Shift+Print` | full screenshot |
| `Mod+Shift+E` | quit niri |

## Requirements

- Arch Linux base install (no DE)
- Internet connection
- A user with `sudo` access

## License

MIT
