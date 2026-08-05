#!/usr/bin/env bash
set -e

sudo apt install curl unzip python3 python3-pip pipx pyenv

sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

sudo apt update

sudo apt install stow
DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── Stow ────────────────────────────────────────────────────────────────────
echo "→ Aplicando symlinks com stow..."

rm ~/.config/gtk-3.0/bookmarks
stow themes
stow icons
stow gtk
stow gnome

# ── dconf ───────────────────────────────────────────────────────────────────
echo "→ Restaurando configurações dconf..."
dconf load / < "$DOTFILES/gnome/.config/dconf-backup.ini"

# ── Extensões ───────────────────────────────────────────────────────────────
EXTENSIONS_FILE="$DOTFILES/gnome/extensions.txt"

if [[ ! -f "$EXTENSIONS_FILE" ]]; then
    echo "⚠ extensions.txt não encontrado, pulando extensões."
else
    if ! command -v gext &>/dev/null; then
        echo "→ Instalando gnome-extensions-cli..."
        pipx install gnome-extensions-cli
        export PATH="$HOME/.local/bin:$PATH"
    fi

    GNOME_VERSION=$(gnome-shell --version | awk '{print $3}' | cut -d. -f1)
    echo "→ GNOME $GNOME_VERSION detectado"
    echo "→ Instalando extensões..."

    while IFS= read -r uuid || [[ -n "$uuid" ]]; do
        [[ -z "$uuid" || "$uuid" == \#* ]] && continue

        echo -n "  $uuid ... "

        if gnome-extensions list | grep -q "^${uuid}$"; then
            echo "já instalada"
            continue
        fi

        if gext install "$uuid" 2>/dev/null; then
            echo "✓"
        else
            echo "✗ falhou (verifique manualmente)"
        fi
    done < "$EXTENSIONS_FILE"

    echo "→ Habilitando extensões..."
    while IFS= read -r uuid || [[ -n "$uuid" ]]; do
        [[ -z "$uuid" || "$uuid" == \#* ]] && continue
        gnome-extensions enable "$uuid" 2>/dev/null && echo "  ✓ $uuid" || true
    done < "$EXTENSIONS_FILE"
fi

# ativando sincronização do relógio com internet
sudo apt update
sudo apt install systemd-timesyncd
sudo systemctl enable --now systemd-timesyncd
sudo timedatectl set-ntp true

echo ""
echo "✓ Pronto! Reinicie a sessão GNOME (logout ou Alt+F2 → r)."
