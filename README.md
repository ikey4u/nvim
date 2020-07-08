# Quick Installation

Install pyenv, please see https://github.com/pyenv/pyenv.

- Ubuntu

    Installation

        mkdir -p $HOME/.usr/ && cd $HOME/.usr

        curl -LO https://github.com/neovim/neovim/releases/download/v0.4.3/nvim-linux64.tar.gz
        tar zxvf nvim-linux64.tar.gz  && rm nvim-linux64.tar.gz
        mv nvim-linux64 nvim
        echo 'export PATH=$HOME/.usr/nvim/bin:$PATH' >> $HOME/.zshrc
        exec $SHELL

        mkdir -p $HOME/.config/
        git clone https://github.com/ikey4u/nvim.git $HOME/.config/nvim

    Dependencies

        pip3 install neovim

        export N_PREFIX=$HOME/.usr/n
        curl -L https://git.io/n-install | bash
        source ~/.zshrc

        sudo apt install ripgrep

For more details, see man/manual.txt.

![nvim](./man/nvim.png)
