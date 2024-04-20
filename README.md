# Introduction

Hello! This is my neovim/terminal config that I've started to configure and use for my personal projects. Outside of work, this is the configuration I'm most comfortable with, and a few of the keybindings and shortcuts have made it's way into my preferred at-work IDE, JetBrains suite.

# Requirements

This config requires the following to work: (mostly as a reminder to myself if I ever need to swap my dev machine)

- [Oh My Zsh](https://ohmyz.sh/)
- [powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)
- [Github Monaspace Krypton NFM](https://github.com/githubnext/monaspace) for the font (be sure to use a [nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Monaspace) if you're not using this one!)

# Setup

To get this project set up the way it should be, do the following:

1. Install Oh My Zsh using `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
2. Run the terminal to set up Oh My Zsh if it needs to be loaded.
3. Install powerlevel10k using `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
    4. Run the terminal to set up p10k and the configurations if they need to be.
5. Install Neovim using `brew install neovim` (if using Homebrew. If not, see the above link on Neovim.)
    6. Clone this repo into either a clean project folder, or into the root of the machine (recommend that you use a clean project folder).
    7. If you did not clone into root, copy all project files into the root (do this to avoid git tracking your entire machine root).
    8. Run `nvc`. This will ensure that the `.zshrc` is properly tracked by the shell.
    9. Exit Neovim.
    10. Run `nv` in a git-tracked project.
    11. Run `:checkhealth` to ensure everything is working correctly for Neovim.
    12. Play around to ensure that everything is working as intended :D

# Features

    I'm too lazy to keep the plugin list up-to-date, so please refer to the `lazy-lock.json` file for exactly what plugins Neovim is using.

    Uses [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) as the base theme, and integrates it as much as I'm willing to at any given moment.

    Happy coding!

## Troubleshooting

    1. For lazygit in floaterm, if you did not set Catppuccin Mocha correctly, it will appear really ugly (default lazygit theme). To fix this, see [here](https://github.com/catppuccin/lazygit)
