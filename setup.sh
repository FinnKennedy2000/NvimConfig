#!/bin/sh

echo "Setting up Neovim configuration..."

# Install Lazy.nvim if not already installed
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
  echo "Installing Lazy.nvim..."
  git clone https://github.com/folke/lazy.nvim ~/.local/share/nvim/lazy/lazy.nvim
fi

# Set up GOBIN and ensure it's in the PATH
echo "Setting up GOBIN and adding it to PATH..."
echo "export GOBIN=\$HOME/go/bin" >>~/.bashrc
echo "export PATH=\$PATH:\$GOBIN" >>~/.bashrc
source ~/.bashrc

# Install missing Go tools
echo "Installing Go development tools..."
go install golang.org/x/tools/cmd/gopls@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/cheusov/iferr@latest
go install github.com/josharian/impl@latest
go install github.com/gobuffalo/packr/v2/packr@latest
go install github.com/golang/mock/mockgen@latest
go install github.com/swaggo/swag/cmd/swag@latest
go install github.com/ramya-rao-a/go-outline@latest
go install github.com/cweill/gotests/...@latest
go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest
go install github.com/monochromegane/go-gitignore@latest
go install github.com/stretchr/testify@latest
go install github.com/rogpeppe/godef@latest
go install github.com/fatih/gomodifytags@latest
go install github.com/joshuarubin/go-enum@latest
go install github.com/gonutz/gojsonstruct@latest
go install github.com/golangci/govulncheck/cmd/govulncheck@latest
go install github.com/go-task/task/cmd/task@latest
go install github.com/tendermint/go-tools/cmd/go-vulncheck@latest

# Install LuaRocks and required modules if not installed
echo "Setting up LuaRocks..."
if
  ! command -v luarocks &
  >/dev/null
then
  echo "Installing LuaRocks..."
  # Use pacman for Arch-based systems
  sudo pacman -S --noconfirm luarocks
fi

# Install hererocks if needed
echo "Setting up hererocks (if required for Neovim plugins)..."
if [ ! -d "$HOME/.local/share/nvim/lazy-rocks/hererocks" ]; then
  echo "Installing hererocks..."
  git clone https://github.com/rocks-moon/hererocks.git ~/.local/share/nvim/lazy-rocks/hererocks
  cd ~/.local/share/nvim/lazy-rocks/hererocks
  make
fi

# Install the missing Lua module for LuaSnip
echo "Installing LuaSnip dependencies..."
luarocks install jsregexp

# Install Treesitter parsers for Go, Tailwind, and others
echo "Installing missing Treesitter parsers..."
nvim -c ":TSInstall go gowork gomod gosum sql gotmpl json comment html tsx css"

# Install Node.js neovim package
echo "Installing Node.js neovim package..."
npm install -g neovim

# Install Python neovim module
echo "Installing Python neovim module..."
pip install neovim

# Install Telescope dependency (fd)
echo "Installing Telescope dependency (fd)..."
sudo pacman -S --noconfirm fd

# Install Ruby if missing
echo "Installing Ruby..."
sudo pacman -S --noconfirm ruby

echo "Neovim setup complete! Open Neovim and run :Lazy sync"
