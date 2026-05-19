#!/usr/bin/env bash
# ██████╗  █████╗ ███╗   ██╗██╗  ██╗██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
# ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
# ██║  ██║███████║██╔██╗ ██║█████╔╝ ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝
# ██║  ██║██╔══██║██║╚██╗██║██╔═██╗ ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
# ██████╔╝██║  ██║██║ ╚████║██║  ██╗███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
# ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
# modern arch. no compromises.

set -euo pipefail

# ── Catppuccin Mocha palette ──────────────────────────────────────────────────
ROSEWATER='\033[38;2;245;224;220m'
FLAMINGO='\033[38;2;242;205;205m'
PINK='\033[38;2;245;194;231m'
MAUVE='\033[38;2;203;166;247m'
RED='\033[38;2;243;139;168m'
MAROON='\033[38;2;235;160;172m'
PEACH='\033[38;2;250;179;135m'
YELLOW='\033[38;2;249;226;175m'
GREEN='\033[38;2;166;227;161m'
TEAL='\033[38;2;148;226;213m'
SKY='\033[38;2;137;220;235m'
SAPPHIRE='\033[38;2;116;199;236m'
BLUE='\033[38;2;137;180;250m'
LAVENDER='\033[38;2;180;190;254m'
TEXT='\033[38;2;205;214;244m'
SUBTEXT1='\033[38;2;186;194;222m'
OVERLAY0='\033[38;2;108;112;134m'
BASE='\033[48;2;30;30;46m'
BOLD='\033[1m'
RESET='\033[0m'

# ── Helpers ───────────────────────────────────────────────────────────────────
banner() {
  echo -e ""
  echo -e "${MAUVE}${BOLD}  ══╡ $1 ╞══${RESET}"
  echo -e ""
}

info() { echo -e "  ${BLUE}  ${TEXT}$1${RESET}"; }
ok() { echo -e "  ${GREEN}  ${TEXT}$1${RESET}"; }
warn() { echo -e "  ${YELLOW}  ${TEXT}$1${RESET}"; }
err() {
  echo -e "  ${RED}  ${TEXT}$1${RESET}"
  exit 1
}
ask() { echo -e -n "  ${LAVENDER}  ${TEXT}$1 ${OVERLAY0}» ${RESET}"; }
section() { echo -e "\n${MAUVE}${BOLD}$1${RESET}\n"; }

confirm() {
  ask "$1 [y/N]"
  read -r ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

# ── Pre-flight ────────────────────────────────────────────────────────────────
clear
echo -e "${BASE}${MAUVE}${BOLD}"
cat <<'EOF'
  ██████╗  █████╗ ███╗   ██╗██╗  ██╗██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗
  ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝██║     ██║████╗  ██║██║   ██║╚██╗██╔╝
  ██║  ██║███████║██╔██╗ ██║█████╔╝ ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝
  ██║  ██║██╔══██║██║╚██╗██║██╔═██╗ ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗
  ██████╔╝██║  ██║██║ ╚████║██║  ██╗███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗
  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝
EOF
echo -e "${RESET}"
echo -e "  ${SUBTEXT1}modern arch. no compromises.${RESET}\n"
echo -e "  ${OVERLAY0}niri + miri · ghostty · fish · GarrysVim · walker · swaync · Catppuccin Mocha${RESET}\n"

[[ "$EUID" -eq 0 ]] && err "Don't run as root. Run as your user with sudo access."
command -v pacman &>/dev/null || err "This installer requires Arch Linux."

# ── Questions ─────────────────────────────────────────────────────────────────
banner "Setup"

ask "Username"
read -r DL_USER
[[ -z "$DL_USER" ]] && err "Username cannot be empty."

ask "Hostname"
read -r DL_HOST
[[ -z "$DL_HOST" ]] && err "Hostname cannot be empty."

echo -e "\n  ${LAVENDER}  ${TEXT}GPU driver${RESET}"
echo -e "  ${OVERLAY0}  1) NVIDIA   2) AMD   3) Intel${RESET}"
ask "Choice [1/2/3]"
read -r GPU_CHOICE
case "$GPU_CHOICE" in
  1) GPU="nvidia" ;;
  2) GPU="amd" ;;
  3) GPU="intel" ;;
  *) err "Invalid GPU choice." ;;
esac

echo ""
info "Username : ${MAUVE}${DL_USER}${RESET}"
info "Hostname : ${MAUVE}${DL_HOST}${RESET}"
info "GPU      : ${MAUVE}${GPU}${RESET}"
echo ""

confirm "Looks good? Start install" || {
  warn "Aborted."
  exit 0
}

# ── Hostname ──────────────────────────────────────────────────────────────────
banner "System"
info "Setting hostname..."
echo "$DL_HOST" | sudo tee /etc/hostname >/dev/null
sudo tee /etc/hosts >/dev/null <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${DL_HOST}.localdomain ${DL_HOST}
EOF
ok "Hostname set to ${DL_HOST}"

# ── Pacman setup ──────────────────────────────────────────────────────────────
info "Configuring pacman..."
sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
sudo pacman -Syu --noconfirm
ok "Pacman configured"

# ── yay ───────────────────────────────────────────────────────────────────────
banner "AUR Helper"
if ! command -v yay &>/dev/null; then
  info "Installing yay..."
  sudo pacman -S --noconfirm --needed git base-devel
  tmp=$(mktemp -d)
  git clone https://aur.archlinux.org/yay.git "$tmp/yay"
  (cd "$tmp/yay" && makepkg -si --noconfirm)
  rm -rf "$tmp"
  ok "yay installed"
else
  ok "yay already present"
fi

# ── Core packages ─────────────────────────────────────────────────────────────
banner "Packages"

PACMAN_PKGS=(
  # wayland core
  wayland wayland-protocols wlroots xdg-desktop-portal xdg-desktop-portal-gtk
  xdg-utils xdg-user-dirs

  # niri stack
  niri

  # audio
  pipewire pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse wireplumber

  # shell & editor deps
  fish neovim git curl wget unzip ripgrep fd fzf

  # terminal
  ghostty

  # apps
  firefox yazi strawberry

  # fonts
  ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji

  # system
  polkit polkit-gnome gnome-keyring libsecret
  brightnessctl playerctl grim slurp wl-clipboard cliphist
  network-manager-applet blueman
  thunar-archive-plugin file-roller

  # theming
  papirus-icon-theme
)

AUR_PKGS=(
  miri-niri  # master stack tiling for niri
  walker-bin # launcher
  swaync     # notification daemon
  dms-bar    # niri status bar
  garrysvim  # neovim distro (or clone from github if not in AUR)
  catppuccin-gtk-theme-mocha
  papirus-folders-catppuccin-git
)

info "Installing pacman packages..."
sudo pacman -S --noconfirm --needed "${PACMAN_PKGS[@]}"
ok "Pacman packages done"

info "Installing AUR packages..."
# garrysvim may not be in AUR — handled separately below
AUR_NO_GARRY=("${AUR_PKGS[@]/garrysvim/}")
yay -S --noconfirm --needed "${AUR_NO_GARRY[@]}" || warn "Some AUR packages failed — check manually"
ok "AUR packages done"

# ── GPU drivers ───────────────────────────────────────────────────────────────
banner "GPU: ${GPU}"
case "$GPU" in
  nvidia)
    info "Installing NVIDIA drivers..."
    sudo pacman -S --noconfirm --needed nvidia nvidia-utils nvidia-settings lib32-nvidia-utils
    # Wayland env vars
    sudo tee /etc/environment >/dev/null <<'EOF'
LIBVA_DRIVER_NAME=nvidia
GBM_BACKEND=nvidia-drm
__GLX_VENDOR_LIBRARY_NAME=nvidia
WLR_NO_HARDWARE_CURSORS=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
MOZ_ENABLE_WAYLAND=1
EOF
    ok "NVIDIA configured"
    ;;
  amd)
    info "Installing AMD drivers..."
    sudo pacman -S --noconfirm --needed mesa vulkan-radeon libva-mesa-driver lib32-mesa lib32-vulkan-radeon
    sudo tee /etc/environment >/dev/null <<'EOF'
RADV_PERFTEST=gpl
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
EOF
    ok "AMD configured"
    ;;
  intel)
    info "Installing Intel drivers..."
    sudo pacman -S --noconfirm --needed mesa vulkan-intel intel-media-driver lib32-mesa
    sudo tee /etc/environment >/dev/null <<'EOF'
MOZ_ENABLE_WAYLAND=1
ELECTRON_OZONE_PLATFORM_HINT=wayland
EOF
    ok "Intel configured"
    ;;
esac

# ── GarrysVim ────────────────────────────────────────────────────────────────
banner "GarrysVim"
NVIM_CONFIG="$HOME/.config/nvim"
if [[ ! -d "$NVIM_CONFIG" ]]; then
  info "Cloning GarrysVim..."
  git clone https://github.com/ihave17bucks/GarrysVim "$NVIM_CONFIG"
  ok "GarrysVim installed"
else
  warn "~/.config/nvim already exists — skipping"
fi

# ── Dotfiles ──────────────────────────────────────────────────────────────────
banner "Dotfiles"
CONF="$HOME/.config"
mkdir -p "$CONF"/{niri,miri,ghostty,fish,walker,swaync,dms}

# ── niri config ───────────────────────────────────────────────────────────────
info "Writing niri config..."
cat >"$CONF/niri/config.kdl" <<'NIRI'
input {
  keyboard { xkb { layout "us"; } }
  touchpad { tap; natural-scroll; }
}

output "eDP-1" {
  scale 1.0
}

layout {
  gaps 8
  center-focused-column "never"
  preset-column-widths {
    proportion 0.5
    proportion 0.66
    proportion 1.0
  }
  default-column-width { proportion 0.5; }
  focus-ring {
    width 2
    active-color "#cba6f7"
    inactive-color "#313244"
  }
  border { off; }
}

animations {
  slowdown 0.8
}

spawn-at-startup "dms-bar"
spawn-at-startup "miri" "--service"
spawn-at-startup "swaync"
spawn-at-startup "polkit-gnome-authentication-agent-1"
spawn-at-startup "nm-applet" "--indicator"
spawn-at-startup "cliphist" "watch"
spawn-at-startup "fish" "-c" "set -x GTK_THEME Catppuccin-Mocha-Standard-Mauve-Dark"

binds {
  // apps
  Mod+Return { spawn "ghostty"; }
  Mod+Space  { spawn "walker"; }
  Mod+E      { spawn "yazi"; }
  Mod+B      { spawn "firefox"; }
  Mod+M      { spawn "strawberry"; }
  Mod+N      { spawn "swaync-client" "-t"; }

  // miri layouts
  Mod+Shift+M { spawn "miri" "action" "set-focused-workspace-mode" "master"; }
  Mod+Shift+S { spawn "miri" "action" "set-focused-workspace-mode" "scroll"; }
  Mod+Tab     { spawn "miri" "action" "cycle-focused-workspace-mode"; }

  // miri overrides
  Mod+Shift+Left  { spawn "miri" "override" "move-column-left"; }
  Mod+Shift+Right { spawn "miri" "override" "move-column-right"; }
  Mod+Shift+Home  { spawn "miri" "override" "move-column-to-first"; }
  Mod+Shift+End   { spawn "miri" "override" "move-column-to-last"; }
  Mod+Shift+1     { spawn "miri" "override" "move-column-to-workspace" "1"; }
  Mod+Shift+2     { spawn "miri" "override" "move-column-to-workspace" "2"; }
  Mod+Shift+3     { spawn "miri" "override" "move-column-to-workspace" "3"; }
  Mod+Shift+4     { spawn "miri" "override" "move-column-to-workspace" "4"; }
  Mod+Shift+5     { spawn "miri" "override" "move-column-to-workspace" "5"; }
  Mod+Ctrl+I      { spawn "miri" "override" "move-column-to-workspace-up"; }
  Mod+Ctrl+U      { spawn "miri" "override" "move-column-to-workspace-down"; }

  // niri native
  Mod+Left        { focus-column-left; }
  Mod+Right       { focus-column-right; }
  Mod+Up          { focus-window-up; }
  Mod+Down        { focus-window-down; }
  Mod+H           { focus-column-left; }
  Mod+L           { focus-column-right; }
  Mod+K           { focus-window-up; }
  Mod+J           { focus-window-down; }
  Mod+1           { focus-workspace 1; }
  Mod+2           { focus-workspace 2; }
  Mod+3           { focus-workspace 3; }
  Mod+4           { focus-workspace 4; }
  Mod+5           { focus-workspace 5; }
  Mod+Q           { close-window; }
  Mod+F           { maximize-column; }
  Mod+Shift+F     { fullscreen-window; }
  Mod+R           { switch-preset-column-width; }
  Mod+Minus       { set-column-width "-5%"; }
  Mod+Equal       { set-column-width "+5%"; }

  // media / system
  XF86AudioRaiseVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
  XF86AudioLowerVolume  { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
  XF86AudioMute         { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
  XF86MonBrightnessUp   { spawn "brightnessctl" "set" "+5%"; }
  XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
  XF86AudioPlay         { spawn "playerctl" "play-pause"; }
  XF86AudioNext         { spawn "playerctl" "next"; }
  XF86AudioPrev         { spawn "playerctl" "previous"; }

  // screenshot
  Print       { spawn "sh" "-c" "grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date +%s).png"; }
  Shift+Print { spawn "sh" "-c" "grim ~/Pictures/Screenshots/$(date +%s).png"; }

  Mod+Shift+E { quit; }
}

window-rule {
  geometry-corner-radius 8
  clip-to-geometry true
}
NIRI
ok "niri config written"

# ── miri config ───────────────────────────────────────────────────────────────
info "Writing miri config..."
cat >"$CONF/miri/config.toml" <<'MIRI'
[global]
default_workspace_mode = "master"

[master]
column_width_percentage = 50.0
maximize_single_window = true

[scroll]
maintain_focus_on_new_window = false
MIRI
ok "miri config written"

# ── ghostty config ────────────────────────────────────────────────────────────
info "Writing ghostty config..."
cat >"$CONF/ghostty/config" <<'GHOSTTY'
theme = catppuccin-mocha
font-family = "JetBrainsMono Nerd Font"
font-size = 13
background-opacity = 0.95
background-blur-radius = 20
cursor-style = block
cursor-style-blink = true
window-decoration = false
window-padding-x = 12
window-padding-y = 8
shell-integration = fish
GHOSTTY
ok "ghostty config written"

# ── fish config ───────────────────────────────────────────────────────────────
info "Writing fish config..."
mkdir -p "$HOME/.config/fish"
cat >"$HOME/.config/fish/config.fish" <<'FISH'
if status is-interactive
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  set -gx BROWSER firefox
  set -gx GTK_THEME "Catppuccin-Mocha-Standard-Mauve-Dark"
  set -gx XDG_CURRENT_DESKTOP niri

  # aliases
  alias v   "nvim"
  alias vim "nvim"
  alias ls  "ls --color=auto"
  alias la  "ls -la --color=auto"
  alias cat "bat"
  alias y   "yazi"

  # yazi shell wrapper (cwd on exit)
  function ya
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      cd -- $cwd
    end
    rm -f -- "$tmp"
  end

  # prompt: starship if available, else minimal
  if command -q starship
    starship init fish | source
  else
    function fish_prompt
      echo -n (set_color magenta)(prompt_pwd)(set_color normal)" λ "
    end
  end
end
FISH
ok "fish config written"

# ── walker config ─────────────────────────────────────────────────────────────
info "Writing walker config..."
cat >"$CONF/walker/config.toml" <<'WALKER'
[ui]
width = 600
max_entries = 8
placeholder = "run something..."

[style]
# Catppuccin Mocha — walker uses CSS
WALKER
# Walker CSS (Catppuccin Mocha)
mkdir -p "$CONF/walker"
cat >"$CONF/walker/style.css" <<'CSS'
* {
  font-family: "JetBrainsMono Nerd Font";
  font-size: 14px;
}
#window {
  background: #1e1e2e;
  border: 1px solid #313244;
  border-radius: 12px;
  padding: 8px;
}
#input {
  background: #181825;
  color: #cdd6f4;
  border: 1px solid #45475a;
  border-radius: 8px;
  padding: 8px 12px;
  margin-bottom: 6px;
  caret-color: #cba6f7;
}
#input:focus { border-color: #cba6f7; }
.entry {
  color: #cdd6f4;
  border-radius: 6px;
  padding: 6px 10px;
}
.entry:selected, .entry:hover { background: #313244; color: #cba6f7; }
.entry .name { color: #cdd6f4; }
.entry .sub  { color: #6c7086; font-size: 12px; }
CSS
ok "walker config written"

# ── swaync config ─────────────────────────────────────────────────────────────
info "Writing swaync config..."
cat >"$CONF/swaync/config.json" <<'SWAYNC'
{
  "positionX": "right",
  "positionY": "top",
  "control-center-margin-top": 8,
  "control-center-margin-bottom": 8,
  "control-center-margin-right": 8,
  "control-center-margin-left": 0,
  "notification-icon-size": 64,
  "notification-body-image-height": 100,
  "notification-body-image-width": 200,
  "timeout": 5,
  "timeout-low": 2,
  "timeout-critical": 0,
  "fit-to-screen": false,
  "control-center-width": 500,
  "control-center-height": 600,
  "notification-window-width": 400,
  "keyboard-shortcuts": true,
  "image-visibility": "when-available",
  "transition-time": 200,
  "hide-on-clear": false,
  "hide-on-action": true
}
SWAYNC
cat >"$CONF/swaync/style.css" <<'SWAYNC_CSS'
* { font-family: "JetBrainsMono Nerd Font"; }

.notification-row { outline: none; }

.notification {
  background: #1e1e2e;
  border: 1px solid #313244;
  border-radius: 10px;
  margin: 6px 12px;
  padding: 0;
}

.notification-content {
  padding: 12px;
  border-radius: 10px;
  color: #cdd6f4;
}

.notification-default-action { border-radius: 10px; }
.notification-default-action:hover { background: #313244; }

.close-button {
  background: #313244;
  color: #cdd6f4;
  border-radius: 5px;
  border: none;
  padding: 2px 6px;
}
.close-button:hover { background: #f38ba8; color: #1e1e2e; }

.summary { font-weight: bold; color: #cba6f7; }
.time    { color: #6c7086; font-size: 11px; }
.body    { color: #cdd6f4; }

.control-center {
  background: #1e1e2e;
  border: 1px solid #313244;
  border-radius: 12px;
}

.control-center-list-placeholder { color: #6c7086; }

.floating-notifications { background: transparent; }
SWAYNC_CSS
ok "swaync config written"

# ── Screenshot dir ────────────────────────────────────────────────────────────
mkdir -p ~/Pictures/Screenshots
ok "Screenshots dir ready"

# ── Default shell ─────────────────────────────────────────────────────────────
banner "Shell"
FISH_BIN=$(which fish)
if ! grep -q "$FISH_BIN" /etc/shells; then
  echo "$FISH_BIN" | sudo tee -a /etc/shells >/dev/null
fi
sudo chsh -s "$FISH_BIN" "$USER"
ok "fish set as default shell"

# ── Services ──────────────────────────────────────────────────────────────────
banner "Services"
systemctl --user enable --now pipewire pipewire-pulse wireplumber
ok "pipewire services enabled"

# ── GTK theme ────────────────────────────────────────────────────────────────
info "Applying GTK theme..."
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat >"$HOME/.config/gtk-3.0/settings.ini" <<'GTK'
[Settings]
gtk-theme-name=Catppuccin-Mocha-Standard-Mauve-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-cursor-theme-name=Catppuccin-Mocha-Dark-Cursors
gtk-application-prefer-dark-theme=1
GTK
cp "$HOME/.config/gtk-3.0/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
ok "GTK theme applied"

# ── Niri as default session ───────────────────────────────────────────────────
banner "Session"
if [[ ! -f /usr/share/wayland-sessions/niri.desktop ]]; then
  warn "niri.desktop not found in wayland-sessions — you may need to add it manually"
else
  ok "niri wayland session available"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "  ${GREEN}${BOLD}██████╗  ██████╗ ███╗   ██╗███████╗${RESET}"
echo -e "  ${GREEN}${BOLD}██╔══██╗██╔═══██╗████╗  ██║██╔════╝${RESET}"
echo -e "  ${GREEN}${BOLD}██║  ██║██║   ██║██╔██╗ ██║█████╗  ${RESET}"
echo -e "  ${GREEN}${BOLD}██║  ██║██║   ██║██║╚██╗██║██╔══╝  ${RESET}"
echo -e "  ${GREEN}${BOLD}██████╔╝╚██████╔╝██║ ╚████║███████╗${RESET}"
echo -e "  ${GREEN}${BOLD}╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝${RESET}"
echo ""
echo -e "  ${TEXT}DankLinux is installed. Reboot and select ${MAUVE}niri${TEXT} at your display manager.${RESET}"
echo ""
echo -e "  ${SUBTEXT1}Stack:${RESET}"
echo -e "  ${OVERLAY0}  niri + miri · ghostty · fish · GarrysVim · walker · swaync · DMS${RESET}"
echo -e "  ${OVERLAY0}  firefox · yazi · strawberry · Catppuccin Mocha${RESET}"
echo ""
echo -e "  ${YELLOW}  Reboot now? (recommended)${RESET}"
confirm "Reboot" && sudo reboot
