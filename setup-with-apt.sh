sudo apt install curl unzip python3 python3-pip pipx pyenv -y

sudo apt install flatpak -y

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Adding OhMyPosh

echo "Installing ohmyposh"
curl -s https://ohmyposh.dev/install.sh | bash -s

sudo apt install tmux -y
sudo apt install stow -y
sudo apt install zsh -y
sudo apt install zoxide fzf -y

# adding Oh-My-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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
stow ghostty

stow ohmyposh
stow ohmyzsh
stow tmux

rm ~/.zshrc
stow zsh
