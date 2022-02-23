#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Install some apps
brew install bitwarden-cli
brew install --cask alfred
brew install rectangle
brew install --cask dozer
brew install --cask monitorcontrol
#brew install unclack
brew install --cask krisp
brew install --cask sublime-text
brew install --cask discord
brew install mas
brew install scrcpy
brew install --cask vysor
brew install --cask syncthing
brew install --cask qlvideo
brew install ncdu
