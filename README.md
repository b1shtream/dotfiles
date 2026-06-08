# dotfiles

My personal **i3wm** rig on EndeavourOS (Arch-based) — a tiling setup tuned for a fast, keyboard-driven workflow.

> Built on the EndeavourOS i3 Community Edition base, then customized: autotiling, Polybar, picom compositor, a modern rofi launcher, redshift, and a plugin-based Vim.

## ✨ Highlights

- **WM:** i3 + [autotiling](https://github.com/nwg-piotr/autotiling) (balanced splits along the longer edge)
- **Bar:** [Polybar](https://github.com/polybar/polybar) — workspaces, window title, CPU/RAM/temp, volume, network, battery, tray
- **Compositor:** [picom](https://github.com/yshui/picom) — transparency, blur, shadows, fades, rounded corners
- **Launcher:** rofi — modern centered menu with icons (`Mod+d`)
- **Terminal:** [Alacritty](https://github.com/alacritty/alacritty) (JetBrainsMono Nerd Font)
- **Editor:** Vim + [vim-plug](https://github.com/junegunn/vim-plug) (gruvbox, NERDTree, fzf, airline, gitgutter…)
- **Shell:** Bash + fzf (`Ctrl-R`/`Ctrl-T`/`Alt-C`), zoxide, eza, bat
- **Notifications:** dunst · **Clipboard:** copyq · **Night light:** redshift
- **Theme:** Arc-Dark + Qogir-Dark icons + gruvbox accents

## ⌨️ Key bindings (mod = Super/Win)

| Keys | Action |
|------|--------|
| `Mod+Enter` | Terminal (Alacritty) |
| `Mod+d` | App launcher (rofi) |
| `Mod+q` | Close window |
| `Mod+h/j/k/l` | Focus left/down/up/right |
| `Mod+Shift+h/j/k/l` | Move window |
| `Mod+v` / `Mod+Shift+v` | Split below / split right |
| `Mod+r` | Resize mode |
| `Mod+f` | Fullscreen |
| `Mod+minus` | Toggle scratchpad dropdown terminal |
| `Mod+c` | Clipboard history (copyq) |
| `Mod+Escape` | Lock screen |
| `Print` | Screenshot (flameshot) |
| `F1` | Keybinding cheat-sheet |

## 📦 Dependencies

```bash
sudo pacman -S --needed \
  i3-wm i3lock polybar picom rofi dunst alacritty \
  autotiling redshift copyq flameshot brightnessctl playerctl \
  feh xss-lock xorg-xset \
  vim fzf ripgrep fd zoxide eza bat \
  ttf-jetbrains-mono-nerd noto-fonts
```

Vim plugins install on first launch via vim-plug (`:PlugInstall`).

## 🚀 Install

```bash
git clone https://github.com/b1shtream/dotfiles.git
cd dotfiles
./install.sh            # symlinks configs into ~ (backs up anything existing)
# or: ./install.sh --copy   to copy instead of symlink
```

Existing files are moved to `~/.dotfiles-backup/<timestamp>/` before linking — nothing is overwritten silently. Then log out and back in, or restart i3 with `Mod+Shift+R`.

## 📁 Layout

```
.config/
  i3/         alacritty/   polybar/   rofi/
  dunst/      redshift/    picom.conf
  gtk-3.0/    gtk-4.0/     xsettingsd/  nwg-look/
  btop/       htop/        neofetch/    nano/
.bashrc
.vimrc
install.sh
```

## 🙏 Credits

i3 base configuration and scripts from the
[EndeavourOS i3wm setup](https://github.com/endeavouros-team/endeavouros-i3wm-setup).

## License

[MIT](LICENSE) © 2026 Riya Bisht
