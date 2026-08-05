sudo apt install curl unzip python3 python3-pip pipx pyenv

sudo apt install flatpak

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Adding Ghostty
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc | sudo gpg --dearmor --yes -o /etc/apt/keyrings/debian.griffo.io.gpg

echo "deb [signed-by=/etc/apt/keyrings/debian.griffo.io.gpg] https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list > /dev/null

echo "deb-src https://debian.griffo.io/apt $(lsb_release -sc 2>/dev/null) main" | sudo tee -a /etc/apt/sources.list.d/debian.griffo.io.list

sudo apt update

echo "Installing ohmyposh"
curl -s https://ohmyposh.dev/install.sh | bash -s

sudo apt install ghostty
sudo apt install stow
sudo apt install zsh
sudo apt install zoxide fzf

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

rm ~/.zshrc
stow zsh
