# Grantland Chew's dot files

These are my personal config files.

## Config files

* ```bash_profile```        Bash configs.
* ```inputrc```             Command prompt input configs.
* ```gitconfig```			Git configs.
* ```gitignore_global```    Global .gitignore.
* ```osx```                 Defaults for setting up a new mac.
* ```vimrc```               Vim configs.
* ```vim/```                More vim configs.

## Themes

Themes for both Terminal and TextMate in ```themes/```.

## Requirements

Set bash as your login shell:

```
chsh -s $(which bash)
```

Install brew:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Usage

```./backup``` will backup all the config files.
```./restore``` will restore all the config files.

```./osx``` will set up defaults on a new mac.

```./brew.sh``` will install brew packages
```./mas.sh``` will install Mac App Store packages

## Notes

```molokai.vim```           Mirror of vim theme from ```http://www.vim.org/scripts/script.php?script_id=2340```

