#!/usr/bin/env bash
# Export GNOME dconf → gnome/dconf/ (org.gnome.mutter.ini → /org/gnome/mutter/)
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p dconf

PATHS=(
  # Interface, background, workspaces, mutter
  org/gnome/desktop/interface
  org/gnome/desktop/background
  org/gnome/desktop/wm/preferences
  org/gnome/mutter
  # Shortcuts
  org/gnome/desktop/wm/keybindings
  org/gnome/shell/keybindings
  org/gnome/settings-daemon/plugins/media-keys
  # Extensions
  org/gnome/shell/extensions/user-theme
  org/gnome/shell/extensions/tilingshell
  org/gnome/shell/extensions/blur-my-shell
  org/gnome/shell/extensions/space-bar
  org/gnome/shell/extensions/dash2dock-lite
  org/gnome/shell/extensions/rounded-window-corners-reborn
  org/gnome/shell/extensions/org/pshow/gradienttopbar
  org/gnome/shell/extensions/Logo-menu
  org/gnome/shell/extensions/vitals
  org/gnome/shell/extensions/caffeine
  org/gnome/shell/extensions/customize-clock-on-lockscreen
  org/gnome/shell/extensions/desktop-cube
)

for p in "${PATHS[@]}"; do
  dconf dump "/$p/" > "dconf/${p//\//.}.ini"
done

# Enabled extensions
{
  echo "[/]"
  echo "enabled-extensions=$(gsettings get org.gnome.shell enabled-extensions)"
} > dconf/org.gnome.shell.ini

gnome-extensions list --enabled > extensions.txt
echo "Exported $(ls dconf | wc -l) files to $(pwd)/dconf"
