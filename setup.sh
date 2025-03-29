#!/bin/sh

echo "Setting up Neovim configuration..."

# Install Lazy.nvim if not already installed
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
  echo "Installing Lazy.nvim..."
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
fi

echo "Neovim setup complete! Open Neovim and run :Lazy sync"
