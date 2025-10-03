#!/bin/zsh

# get system os
os=$(uname -s)

# get linux distribution
if [ "$os" = "Linux" ]; then
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        distro=$ID
    else
        echo "Unable to determine Linux distribution."
        exit 1
    fi
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ensure required tools are installed
ensure_tool() {
    local tool="$1"
    local package="${2:-$1}"  # Use $1 as package name if $2 is not provided
    
    if ! command_exists "$tool"; then
        echo "Required tool '$tool' is not installed. Installing now..."
        
        if [ "$os" = "Darwin" ]; then
            brew install "$package"
        elif [ "$os" = "Linux" ]; then
            case "$distro" in
                fedora|rhel|centos)
                    sudo dnf install -y "$package"
                    ;;
                ubuntu|debian)
                    sudo apt-get update
                    sudo apt-get install -y "$package"
                    ;;
                arch|manjaro)
                    sudo pacman -S --noconfirm "$package"
                    ;;
                *)
                    echo "Warning: Unsupported Linux distribution. Please install '$tool' manually."
                    return 1
                    ;;
            esac
        fi
    fi
}

# Check required tools before proceeding
ensure_tool "git"
ensure_tool "curl"
ensure_tool "zsh"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# specific to each OS

# if os = macos
if [ $os = "Darwin" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install font-comic-shanns-mono-nerd-font
    brew install stow
    brew install ripgrep
    brew install fzf
    brew install fd
    brew install neovim
    brew install kitty
    brew install terminal-notifier
    brew install caarlos0/tap/timer
fi

# Linux-specific installations
if [ $os = "Linux" ]; then
    case "$distro" in
        fedora|rhel|centos)
            echo "Installing packages for Fedora/RHEL/CentOS..."
            sudo dnf update -y

            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            sudo dnf group install development-tools
            # ===============================================================================================

            brew install --cask font-comic-shanns-mono-nerd-font
            brew install --cask font-jetbrains-mono-nerd-font
            brew install --cask font-sauce-code-pro-nerd-font

            sudo dnf install stow
            sudo dnf install ripgrep
            sudo dnf install fzf
            sudo dnf install fd-find
            sudo dnf install -y neovim python3-neovim
            sudo dnf install kitty
            sudo dnf install notify-send
            sudo dnf install lolcat
            sudo dnf install timer

            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

            sudo dnf update-check -y
            sudo dnf install code -y

            sudo dnf install gh
            ;;
        arch|manjaro)
            echo "Installing packages for Arch Linux/Manjaro..."
            sudo pacman -Syu --noconfirm

            # Install AUR helper (yay) if not present
            if ! command_exists yay; then
                echo "Installing yay AUR helper..."
                sudo pacman -S --needed --noconfirm base-devel git
                cd /tmp
                git clone https://aur.archlinux.org/yay.git
                cd yay
                makepkg -si --noconfirm
                cd ~
            fi

            # Install packages via pacman
            sudo pacman -S --noconfirm stow ripgrep fzf fd neovim python-pynvim kitty github-cli lolcat

            # Install Visual Studio Code
            yay -S --noconfirm visual-studio-code-bin timer-bin

            # Optional: Install Homebrew on Linux for compatibility
            if ! command_exists brew; then
                echo "Installing Homebrew for Linux (optional)..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fi

            brew install --cask font-comic-shanns-mono-nerd-font
            brew install --cask font-jetbrains-mono-nerd-font
            brew install --cask font-sauce-code-pro-nerd-font
            
            ;;
        ubuntu|debian)
            echo "Installing packages for Ubuntu/Debian..."
            sudo apt-get update
            # Add Ubuntu/Debian specific packages here if needed
            echo "Ubuntu/Debian support can be extended here"
            ;;
        *)
            echo "Unsupported Linux distribution: $distro"
            echo "Please install the required packages manually:"
            echo "- stow, ripgrep, fzf, fd, neovim, kitty, github-cli"
            echo "- Nerd fonts (Comic Shanns Mono, JetBrains Mono, Source Code Pro)"
            echo "- Visual Studio Code"
            ;;
    esac
fi

# install nvchad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

# finally stow
if [ -x "./stow.sh" ]; then
    ./stow.sh
else
    echo "Warning: stow.sh not found or not executable"
fi
