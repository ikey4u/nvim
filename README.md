# Installation Guide

- install dependencies 

    - pyenv: [https://github.com/pyenv/pyenv](https://github.com/pyenv/pyenv)
    - neovim: [https://github.com/neovim/neovim/releases/](https://github.com/neovim/neovim/releases/)
    - node: [https://github.com/tj/n](https://github.com/tj/n)
    - nerfonts

            git clone https://github.com/ryanoasis/nerd-fonts.git
            cd nerd-fonts
            ./install.sh

    - ripgrep: [https://github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
    - fzf: [https://github.com/junegunn/fzf](https://github.com/junegunn/fzf) 
    - neovim-remote

            pip3 install neovim-remote

    - neovim js

            npm install -g neovim

- install neovim configuration

        mkdir -p $HOME/.config/
        git clone https://github.com/ikey4u/nvim.git $HOME/.config/nvim

For more details, explore `man` directory.

# Features

- Use `<leader>man` (`\man`) to see all pre-defined shortcuts
- Use `:call Doc<tab>` to see detail about installed plugin, try `:call DocCoc()`
