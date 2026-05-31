#!/usr/bin/env bash
set -e

sudo apt install curl unzip python3 python3-pip pipx pyenv

sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Adding Ghostty
curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/debian.griffo.io.gpg

echo "deb https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list

echo "Installing ohmyposh"
curl -s https://ohmyposh.dev/install.sh | bash -s

sudo apt install ghostty
sudo apt install stow
sudo apt install zsh
sudo apt install zoxide fzf

# setup zsh as default shell
chsh -s $(which zsh)

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# zsh-shift-select
git clone https://github.com/jirutka/zsh-shift-select.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-shift-select

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# ── Stow ────────────────────────────────────────────────────────────────────
echo "→ Aplicando symlinks com stow..."
cd "$DOTFILES"
stow gnome
stow ghostty

rm ~/.config/gtk-3.0/bookmarks
stow gtk
stow icons
stow ohmyposh
stow ohmyzsh
stow themes

rm ~/.zshrc
stow zsh

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

# ohmyzsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh

echo ""
echo "✓ Pronto! Reinicie a sessão GNOME (logout ou Alt+F2 → r)."
