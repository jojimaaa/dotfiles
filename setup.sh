#!/bin/bash
set -e # Aborta o script se algum comando crítico falhar

# ── 1. DETECTOR DE GERENCIADOR DE PACOTES ──────────────────────────────────
declare -A PKG_MANAGERS
PKG_MANAGERS=(
  [apt]="sudo apt install -y"
  [dnf]="sudo dnf install -y"
  [pacman]="sudo pacman -S --noconfirm"
  [zypper]="sudo zypper install -y"
)

INSTALL_CMD=""
PM_NAME=""

if command -v apt &>/dev/null; then
  INSTALL_CMD="sudo apt install -y"
  PM_NAME="apt"
elif command -v dnf &>/dev/null; then
  INSTALL_CMD="sudo dnf install -y"
  PM_NAME="dnf"
elif command -v pacman &>/dev/null; then
  INSTALL_CMD="sudo pacman -S --noconfirm"
  PM_NAME="pacman"
elif command -v zypper &>/dev/null; then
  INSTALL_CMD="sudo zypper install -y"
  PM_NAME="zypper"
else
  echo "Nenhum gerenciador de pacotes suportado encontrado (apt, dnf, pacman, zypper)."
  exit 1
fi
echo "Gerenciador detectado: $PM_NAME. Iniciando instalações..."

# ── 2. INSTALAÇÃO MULTI-DISTRO DAS DEPENDÊNCIAS ────────────────────────────
# Mapeia os nomes corretos de pacotes que variam dependendo da distribuição
case "$PM_NAME" in
apt)
  $INSTALL_CMD curl unzip python3 python3-pip pipx pyenv flatpak tmux stow zsh zoxide fzf neovim
  ;;
dnf)
  $INSTALL_CMD curl unzip python3 python3-pip pipx pyenv flatpak tmux stow zsh zoxide fzf neovim
  ;;
pacman)
  # Arch usa 'python' no lugar de 'python3' e não separa o pip em pacote isolado
  $INSTALL_CMD curl unzip python pipx pyenv flatpak tmux stow zsh zoxide fzf neovim
  ;;
zypper)
  # openSUSE usa prefixos diferentes para pacotes de desenvolvimento
  $INSTALL_CMD curl unzip python3 python3-pip pipx python3-pyenv flatpak tmux stow zsh zoxide fzf neovim
  ;;
esac

# ── 3. REPOSITÓRIO FLATPAK ─────────────────────────────────────────────────
if command -v flatpak &>/dev/null; then
  echo "Configurando Flathub..."
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
fi

# ── 4. ADICIONANDO JETBRAINSMONO FONTS ────────────────────────────────────
echo "Instalando JetBrains Mono..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

# ── 5. INSTALANDO OH-MY-POSH ───────────────────────────────────────────────
echo "Instalando Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s

# ── 6. INSTALANDO OH-MY-ZSH (SEM ABORTAR O SCRIPT) ─────────────────────────
echo "Instalando Oh My Zsh..."
sudo rm -rf ~/.oh-my-zsh
# RUNZSH=no e --unattended impedem o instalador de quebrar o script de automação
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended

echo " Configurando Zsh como Shell Padrão..."
chsh -s "$(which zsh)"

# ── 7. CLONANDO PLUGINS DO ZSH ─────────────────────────────────────────────
echo "Clonando plugins..."
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Garante que as pastas de destino existam antes do clone
mkdir -p "$ZSH_CUSTOM_DIR/plugins"

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
git clone https://github.com/jirutka/zsh-shift-select.git "$ZSH_CUSTOM_DIR/plugins/zsh-shift-select"

# Garantindo que o stow zsh vai executar sem reclamar
rm -f "$HOME/.zshrc"

# ── 8. STOW (APLICANDO SYMLINKS) ──────────────────────────────────────────
DOTFILES="$(cd "$(dirname "$0")" && pwd)"
echo "Aplicando symlinks com Stow em: $DOTFILES"
cd "$DOTFILES"

stow nvim
stow zsh
stow tmux
stow ohmyposh
stow ohmyzsh

echo "Instalação concluída com sucesso! Reinicie o seu terminal."
