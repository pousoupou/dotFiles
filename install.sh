#!bin/bash

# get system os
os=$(uname -s)

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
fi

# if os = fedora
if [ $os = "Linux" ]; then
    sudo dnf install stow
    sudo dnf install ripgrep
    sudo dnf install fzf
    sudo dnf install fd-find
    sudo dnf install -y neovim python3-neovim

    # install font
    git clone --depth=1 https://github.com/ryanoasis/nerd-fonts.git
    cd nerd-fonts
    ./install.sh "ComicShannsMono Nerd Font"
    cd ..

    
fi

# install nvchad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1


