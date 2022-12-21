# Installation Guide

First things first, install neovim editor [here](https://github.com/neovim/neovim/releases/). To
make neovim powerful, you need the followings.

- pyenv

    Install python using [pyenv](https://github.com/pyenv/pyenv) on Linux/Darwin or installer on Windows and then run

        pip3 install pynvim neovim neovim-remote 

    and put the following into your shell configuration (.zshrc, .bashrc or whatever) if you use
    Linux/Darwin

        # open with servername (neovim-remote)
        alias xvim="nvim --listen /tmp/nvim "

        # split open
        alias xvims="nvr --servername /tmp/nvim -o "

        # vertical split open
        alias xvimvs="nvr --servername /tmp/nvim -O "

        # tab open
        alias xvimt="nvr --servername /tmp/nvim --remote-tab "

    Now, you can use `xvim` to open file in existed neovim instance. If `:echo v:servername` is not
    `/tmp/nvim`, that may indicates a corrupted `/tmp/nvim`, remove it and try again.

- fonts and tools

    To display variable symbols, you need to install nerdfonts

        git clone https://github.com/ryanoasis/nerd-fonts.git
        cd nerd-fonts
        ./install.sh

    To do efficient searching, you may need [ripgrep](https://github.com/BurntSushi/ripgrep) and [fzf](https://github.com/junegunn/fzf) tools.

- configuration

        mkdir -p ${HOME}/.config/
        git clone https://github.com/ikey4u/nvim.git $HOME/.config/nvim

    Open nvim and run `:PlugInstall`.

# Tmux

If you use tmux, you should add the following config (tested with tmux 3.1c) into your client's
`~/.tmux.conf` 

    # 256 color
    set -sa terminal-overrides ',xterm-256color:RGB'
    set -sg escape-time 10
    set -g focus-events on
    # cursor shape
    set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'

The `xterm-256color` may be changed to the ouput of command `tset -q` on your device.

Remember to close all tmux sessions (use `tmux kill-server`) after changing `~/.tmux.conf` file to
make the change work.
