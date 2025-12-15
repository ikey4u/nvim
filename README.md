## Installation Guide

- Install neovim editor from [here](https://github.com/neovim/neovim/releases/)

- Install python

    Install python using [pyenv](https://github.com/pyenv/pyenv) on Linux/Darwin
    or installer on Windows and then run

        python3 -m pip install --no-cache-dir --upgrade --force-reinstall pynvim neovim neovim-remote

    If you are on Windows and the `python3` command is not found when you does
    have python3 installed, you can replace `python3` with `py -3` and retry the
    command.

    Also put the following into your shell configuration (.zshrc, .bashrc or
    whatever) if you use Linux/Darwin

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
