#!/bin/sh

set -e

echo "Setting up Neovim configuration..."

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

info() {
  printf "\n%s\n" "$1"
}

warn() {
  printf "Warning: %s\n" "$1" >&2
}

detect_package_manager() {
  for pm in apt-get dnf yum pacman zypper brew; do
    if command_exists "$pm"; then
      echo "$pm"
      return
    fi
  done
  echo ""
}

PKG_MANAGER=$(detect_package_manager)
SUDO=""
if [ "$(id -u)" -ne 0 ] && command_exists sudo; then
  SUDO="sudo"
fi

apt_updated=0
install_packages() {
  case "$PKG_MANAGER" in
    apt-get)
      if [ "$apt_updated" -eq 0 ]; then
        $SUDO apt-get update -y
        apt_updated=1
      fi
      $SUDO apt-get install -y "$@"
      ;;
    dnf)
      $SUDO dnf install -y "$@"
      ;;
    yum)
      $SUDO yum install -y "$@"
      ;;
    pacman)
      $SUDO pacman -Syu --noconfirm "$@"
      ;;
    zypper)
      $SUDO zypper install -y "$@"
      ;;
    brew)
      brew install "$@"
      ;;
    *)
      warn "No supported package manager found; please install $* manually."
      return 1
      ;;
  esac
}

ensure_tool() {
  # $1=command $2=apt pkg(s) $3=pacman pkg(s) $4=brew pkg(s) $5=dnf/yum/zypper pkg(s)
  cmd="$1"
  apt_pkg="$2"
  pacman_pkg="$3"
  brew_pkg="$4"
  rpm_pkg="${5:-$2}"

  if command_exists "$cmd"; then
    return 0
  fi

  if [ -z "$PKG_MANAGER" ]; then
    warn "$cmd is missing and no supported package manager was detected."
    return 1
  fi

  case "$PKG_MANAGER" in
    apt-get) pkgs="$apt_pkg" ;;
    pacman) pkgs="$pacman_pkg" ;;
    brew) pkgs="$brew_pkg" ;;
    dnf | yum | zypper) pkgs="$rpm_pkg" ;;
    *) pkgs="" ;;
  esac

  if [ -z "$pkgs" ]; then
    warn "Package name for $cmd is not defined for $PKG_MANAGER. Install it manually."
    return 1
  fi

  install_packages $pkgs
}

info "Checking prerequisites..."
ensure_tool git git git git git
ensure_tool nvim neovim neovim neovim neovim
ensure_tool go golang go go golang
ensure_tool npm "nodejs npm" "nodejs npm" node "nodejs npm"
ensure_tool python3 python3 python python3 python3
if ! command_exists pip3 && ! command_exists pip; then
  ensure_tool pip3 "python3-pip" "python-pip" "" "python3-pip"
fi
ensure_tool composer composer composer composer composer
ensure_tool rustup rustup rustup rustup rustup
ensure_tool cargo cargo cargo rust cargo
ensure_tool luarocks luarocks luarocks luarocks luarocks
ensure_tool ruby ruby ruby ruby ruby
ensure_tool fd "fd-find" fd fd "fd-find"

GOBIN=${GOBIN:-"$HOME/go/bin"}
mkdir -p "$GOBIN" "$HOME/.local/bin"

# Add useful bins to PATH and shell rc
case "${SHELL##*/}" in
  zsh) RC_FILE="$HOME/.zshrc" ;;
  fish) RC_FILE="$HOME/.config/fish/config.fish" ;; # best effort
  *) RC_FILE="$HOME/.bashrc" ;;
esac

if [ -n "$RC_FILE" ]; then
  touch "$RC_FILE"
  if ! grep -Fq "nvim setup: paths" "$RC_FILE"; then
    cat >>"$RC_FILE" <<EOF

# nvim setup: paths
export GOBIN="$GOBIN"
export PATH="\$PATH:$HOME/.local/bin:$HOME/.luarocks/bin:$GOBIN"
export NODE_PATH="\$HOME/.local/lib/node_modules:\$NODE_PATH"
# end nvim setup
EOF
  fi
fi

export PATH="$PATH:$HOME/.local/bin:$HOME/.luarocks/bin:$GOBIN"
export PATH="$PATH:$HOME/.composer/vendor/bin:$HOME/.config/composer/vendor/bin"
export GOBIN

# Install Lazy.nvim if not already installed
if [ ! -d "$HOME/.local/share/nvim/lazy/lazy.nvim" ]; then
  info "Installing Lazy.nvim..."
  git clone https://github.com/folke/lazy.nvim "$HOME/.local/share/nvim/lazy/lazy.nvim"
fi

# Lazygit (fallback to Go install if package manager cannot provide it)
if ! command_exists lazygit; then
  case "$PKG_MANAGER" in
    pacman | brew)
      install_packages lazygit || true
      ;;
  esac
fi
if ! command_exists lazygit && command_exists go; then
  info "Installing lazygit via Go..."
  go install github.com/jesseduffield/lazygit@latest
fi

# fd-find installs the binary as fdfind on Debian/Ubuntu
if ! command_exists fd && command_exists fdfind; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

info "Installing Go development tools..."
GO_TOOLS="
golang.org/x/tools/gopls
golang.org/x/tools/cmd/goimports
github.com/golangci/golangci-lint/cmd/golangci-lint
github.com/go-delve/delve/cmd/dlv
github.com/josharian/impl
github.com/golang/mock/mockgen
github.com/ramya-rao-a/go-outline
github.com/cweill/gotests/...
github.com/fatih/gomodifytags
"

for tool in $GO_TOOLS; do
  if ! GOBIN="$GOBIN" go install "${tool}@latest"; then
    warn "Failed to install $tool (continuing)."
  fi
done

# LuaRocks module for LuaSnip
info "Installing LuaSnip dependency (jsregexp)..."
if command_exists luarocks; then
  luarocks --local install jsregexp || warn "luarocks jsregexp install failed."
else
  warn "luarocks not available; skipping jsregexp install."
fi

# Node / Python bindings for Neovim
info "Installing Node.js neovim package..."
if command_exists npm; then
  npm config set prefix "$HOME/.local" >/dev/null 2>&1 || true
  npm install -g --prefix "$HOME/.local" neovim || warn "npm neovim install failed."
  info "Installing formatter npm packages (prettier, php plugin, prettierd, sql-formatter)..."
  npm install -g --prefix "$HOME/.local" prettier @prettier/plugin-php @fsouza/prettierd sql-formatter || warn "npm formatter install failed."
else
  warn "npm not available; skipping Node.js neovim package."
fi

info "Creating isolated Python host (venv) for Neovim..."
VENV_DIR="$HOME/.local/share/nvim/venv"
if command_exists python3; then
  if [ ! -x "$VENV_DIR/bin/python" ]; then
    python3 -m venv "$VENV_DIR" || warn "venv creation failed."
  fi
  if [ -x "$VENV_DIR/bin/python" ]; then
    "$VENV_DIR/bin/python" -m pip install --upgrade pip pynvim >/dev/null 2>&1 || warn "venv pynvim install failed."
  fi
fi

info "Installing Ruby neovim gem..."
if command_exists gem; then
  gem install --user-install neovim || warn "Ruby neovim gem install failed."
else
  warn "gem not available; skipping Ruby provider install."
fi

info "Installing PHP formatters..."
# Prefer package manager php-cs-fixer if available
if ! command_exists php-cs-fixer; then
  case "$PKG_MANAGER" in
    pacman) install_packages php-cs-fixer || true ;;
    apt-get) install_packages php-cs-fixer || true ;;
    dnf|yum|zypper) install_packages php-cs-fixer || true ;;
    brew) brew install php-cs-fixer || true ;;
  esac
fi

# Composer fallbacks for php-cs-fixer and pint
if command_exists composer; then
  if ! command_exists php-cs-fixer; then
    composer global require --no-progress friendsofphp/php-cs-fixer || warn "composer php-cs-fixer install failed."
  fi
  if ! command_exists pint; then
    composer global require --no-progress laravel/pint || warn "composer pint install failed."
  fi
else
  warn "composer not available; skipping composer-based PHP formatters."
fi

# Treesitter parsers and plugin sync
if command_exists nvim; then
  info "Syncing Lazy plugins..."
  nvim --headless "+Lazy! sync" +qa || warn "Lazy sync failed."

  info "Building blink.cmp native components (using nightly if available)..."
  if command_exists rustup; then
    rustup toolchain install nightly --profile minimal --quiet || warn "Unable to install Rust nightly."
    RUSTUP_TOOLCHAIN=nightly nvim --headless "+Lazy! build blink.cmp" +qa || warn "blink.cmp build failed."
  else
    nvim --headless "+Lazy! build blink.cmp" +qa || warn "blink.cmp build failed."
  fi

  info "Installing Treesitter parsers..."
  nvim --headless "+TSInstallSync! go gomod gowork gosum sql gotmpl json comment html tsx css" +qa ||
    warn "Treesitter install failed."
else
  warn "Neovim is not available on PATH; skipping plugin setup."
fi

echo "Neovim setup complete! Restart your shell to pick up PATH changes."
