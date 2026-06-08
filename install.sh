#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Dotfiles installer — symlinks every tracked file into $HOME.
# Existing files are backed up to ~/.dotfiles-backup/<timestamp>/ first.
# Usage:  ./install.sh           (symlink everything)
#         ./install.sh --copy    (copy instead of symlink)
# ---------------------------------------------------------------------------
set -euo pipefail

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
MODE="symlink"
[ "${1:-}" = "--copy" ] && MODE="copy"

echo ":: Installing dotfiles from $DOTDIR (mode: $MODE)"

# Every tracked file under the repo, relative to repo root (skip meta files).
mapfile -t FILES < <(cd "$DOTDIR" && git ls-files | grep -vE '^(README\.md|LICENSE|install\.sh|\.gitignore|screenshots/)')

for rel in "${FILES[@]}"; do
    src="$DOTDIR/$rel"
    dest="$HOME/$rel"
    mkdir -p "$(dirname "$dest")"

    # back up an existing real file/dir (not our own symlink)
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        mkdir -p "$BACKUP/$(dirname "$rel")"
        mv "$dest" "$BACKUP/$rel"
        echo "  backed up: $rel"
    elif [ -L "$dest" ]; then
        rm -f "$dest"
    fi

    if [ "$MODE" = "copy" ]; then
        cp "$src" "$dest"
    else
        ln -s "$src" "$dest"
    fi
    echo "  linked: $rel"
done

# make scripts executable
chmod +x "$HOME/.config/i3/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/polybar/launch.sh" 2>/dev/null || true

[ -d "$BACKUP" ] && echo ":: Old files backed up to $BACKUP"
echo ":: Done. Log out / restart i3 (Mod+Shift+R) to apply."
