# Installation Guide

First things first, install neovim editor [here](https://github.com/neovim/neovim/releases/), to
make neovim powerful, you need the followings.

- pyenv

    Install python using [pyenv](https://github.com/pyenv/pyenv) and then run

        pip3 install pynvim neovim neovim-remote 

    and put the following into your shell configuration (.zshrc, .bashrc or whatever)

        # neovim {
            # open with servername (neovim-remote)
            alias xvim="nvim --listen /tmp/nvim "

            # split open
            alias xvims="nvr --servername /tmp/nvim -o "

            # vertical split open
            alias xvimvs="nvr --servername /tmp/nvim -O "

            # tab open
            alias xvimt="nvr --servername /tmp/nvim --remote-tab "
        # }

    Now, you can use `xvim` to open file in existed neovim instance. If `:echo v:servername` is not
    `/tmp/nvim`, that may indicates a corrupted `/tmp/nvim`, remove it and try again.

- node

    Install node using

        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        nvm install node

    then install neovim nodejs client

        npm install -g neovim

- fonts and tools

    To display variable symbols, you need to install nerdfonts

        git clone https://github.com/ryanoasis/nerd-fonts.git
        cd nerd-fonts
        ./install.sh

    To do efficient searching, you may need [ripgrep](https://github.com/BurntSushi/ripgrep) and [fzf](https://github.com/junegunn/fzf) tools.

- configuration

        mkdir -p ${HOME}/.config/
        git clone https://github.com/ikey4u/nvim.git $HOME/.config/nvim
