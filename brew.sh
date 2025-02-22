#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install a modern version of Bash.
brew install bash
brew install bash-completion2
brew install bash-git-prompt

# Install some apps
brew install mas
brew install --cask the-unarchiver

brew install bitwarden-cli

brew install --cask syncthing
brew install --cask google-drive

brew install --cask alfred
brew install jordanbaird-ice
brew install --cask monitorcontrol
#brew install unclack
brew install --cask krisp

brew install --cask sublime-text

brew install --cask signal
brew install --cask whatsapp
brew install --cask discord

brew install --cask android-file-transfer
brew install scrcpy
brew install --cask vysor

brew install --cask orcaslicer
brew install --cask autodesk-fusion360
brew install openscad

brew install --cask qlvideo
brew install ncdu
brew install --cask calibre
brew install --cask via

brew tap homebrew/cask-drivers
brew install --cask logitech-options

brew install --cask qmk-toolbox
brew install --cask duet

brew install fzf
