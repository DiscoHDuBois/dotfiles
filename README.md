# Dotfiles

My current configuration.

## Structure

- `home/` → files that go in `~/` (`.zshrc`, `.bashrc`, `.bash_profile`, `.bash_logout`)
- `config/` → files that go in `~/.config/`
  - `kitty/` — terminal emulator
  - `starship.toml` — prompt
  - `fastfetch/` — system info shown when kitty opens (`config.jsonc`, `gen_config.py`, `lain.png` logo), plus `logo.png` used as the Logo Menu icon
  - `nvim/` — Neovim
  - `xdg-terminals.list`, `gnome-xdg-terminals.list` — set kitty as the default terminal
  - `gtk-3.0/gtk.css`, `gtk-4.0/gtk.css` — kitty palette for GTK3 (adw-gtk3-dark) and libadwaita apps; delete them to go back to the default colors
  - `mpv/` — player (`mpv.conf`, `input.conf`, uosc/thumbfast options)
  - `background` — wallpaper (set by `org.gnome.desktop.background.ini`)
- `gnome/` → GNOME desktop (dconf), tiling WM-like setup
  - `dconf/*.ini` — one file per dconf path (`org.gnome.mutter.ini` → `/org/gnome/mutter/`): shortcuts, fixed workspaces, interface, wallpaper, extension settings
  - `extensions.txt` — enabled extensions (UUIDs)
  - `export.sh` — re-export the current config into `dconf/`
  - `restore.sh` — load `dconf/*.ini` back into dconf

## Restore

```sh
cp -a home/. ~/
cp -a config/. ~/.config/
rm -rf ~/.cache/fastfetch/images   # regenerate fastfetch's logo cache

# GNOME: install the extensions in gnome/extensions.txt first, then
dconf dump / > ~/dconf-backup.ini   # backup
./gnome/restore.sh
```

To update the copy after changing settings: `./gnome/export.sh`

## GNOME shortcuts (Tiling Shell, i3-style)

| Keys | Action |
|---|---|
| `Super+Enter` / `Ctrl+Alt+T` | kitty |
| `Super+Q` | close window |
| `Super+Arrows` | move focus |
| `Super+Shift+Arrows` | move window between tiles |
| `Super+Ctrl+Shift+Arrows` | move window to another monitor |
| `Super+1…5` / `Super+Shift+1…5` | go to / move window to workspace N |
| `Super+F` / `Super+Shift+F` | maximize / fullscreen |
| `Super+H` | minimize |

## Dependencies (not included)

- Packages: `zsh`, `kitty`, `starship`, `fastfetch`, `neovim`, `mpv`
- mpv scripts: [uosc](https://github.com/tomasklaen/uosc) (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/tomasklaen/uosc/HEAD/installers/unix.sh)"`, installs scripts and fonts) and [thumbfast](https://github.com/po5/thumbfast) (`thumbfast.lua` in `~/.config/mpv/scripts/`)
- GNOME extensions: see `gnome/extensions.txt` (Tiling Shell, Blur my Shell, Space Bar, …) — install via Extension Manager (`flatpak install flathub com.mattjakeman.ExtensionManager`)
- Icons: **Tela-circle-purple-dark** — `git clone https://github.com/vinceliuice/Tela-circle-icon-theme && bash Tela-circle-icon-theme/install.sh purple` (installs to `~/.local/share/icons`)
- Cursors: **Catppuccin Mocha Mauve** — extract `catppuccin-mocha-mauve-cursors.zip` from https://github.com/catppuccin/cursors/releases into `~/.local/share/icons`
- Shell theme: **Marble-violet-dark** — `git clone https://github.com/imarkoff/Marble-shell-theme && cd Marble-shell-theme && python3 install.py --hue 265 --name violet --mode dark --floating-panel` (installs to `~/.themes`, needs the User Themes extension)
- GTK3 theme: `sudo dnf install adw-gtk3-theme` (`adw-gtk3-dark`). To let Flatpak apps read the CSS: `flatpak override --user --filesystem=xdg-config/gtk-4.0:ro --filesystem=xdg-config/gtk-3.0:ro`
- Fonts: **JetBrainsMono Nerd Font** (kitty), **MesloLGS NF** and **Noto Sans** (mpv)
- Oh My Zsh: https://ohmyz.sh
- Oh My Zsh plugins:

  ```sh
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  ```
