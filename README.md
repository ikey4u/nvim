## Installation Guide

- Install neovim editor from [here](https://github.com/neovim/neovim/releases/)

- fonts

    To display variable symbols, you need to install [nerdfonts](https://www.nerdfonts.com/font-downloads),
    use [Symbols Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/NerdFontsSymbolsOnly.zip)
    if you do not want to install full font.

- tools

    To do efficient searching, you may need [ripgrep](https://github.com/BurntSushi/ripgrep) tool.

- setup

    If you are on Linux/Darwin

        mkdir -p ${HOME}/.config/
        git clone https://github.com/ikey4u/nvim.git $HOME/.config/nvim

    If you are on Windows

        git clone https://github.com/ikey4u/nvim.git %LocalAppData%\nvim

    Open nvim and it will install automatically.

## Tmux

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
