# Neovim Configuration

This repository contains a custom configuration for Neovim, aimed at enhancing the development experience with various plugins and settings tailored for different programming languages.

## Overview

The configuration includes:

- **Basic Settings**: Configurations for line numbers, tab sizes, and clipboard integration.
- **Plugin Management**: Utilizes `lazy.nvim` for efficient plugin loading and management.
- **Key Mappings**: Custom key mappings for various functionalities, including file navigation, buffer management, and more.
- **Language Server Protocol (LSP)**: Configurations for TypeScript, PHP, Go, and Tailwind CSS, enabling features like autocompletion and linting.
- **User Interface Enhancements**: Integration of themes and file explorers to improve the visual experience.

## Key Components

### Basic Settings

- **Line Numbers**: Displays absolute and relative line numbers.
- **Tab and Indentation**: Configured to use tabs and spaces effectively.
- **Clipboard Integration**: Allows seamless copy-pasting with the system clipboard.

### Plugin Management

- **lazy.nvim**: A plugin manager that loads plugins on demand, improving startup time.
- **Plugins Included**:
  - **nvim-treesitter**: For syntax highlighting and code parsing.
  - **nvim-telescope**: A fuzzy finder for files and content.
  - **nvim-tree**: A file explorer for easy navigation.
  - **nvim-cmp**: Autocompletion framework with support for snippets.
  - **LSP Configurations**: For TypeScript, PHP, Go, and Tailwind CSS.

### Key Mappings

Custom key mappings are defined for quick access to various commands, such as:

- Quick quit (`<leader>q`)
- Save file (`<leader>w`)
- Toggle file explorer (`<C-n>`)

### Language Server Protocol (LSP)

Configured LSPs for:

- **TypeScript/JavaScript**: Using `ts_ls` for enhanced development.
- **PHP**: Integrated with `phpactor`.
- **Go**: Using `gopls`.
- **Tailwind CSS**: For utility-first CSS framework support.

### Theme and UI

- **Tokyonight Theme**: A beautiful theme for Neovim, with options for different styles.
- **Floating Windows**: Configured for file explorer and other UI elements.

## Setup Instructions

1. **Clone the Repository**:

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Run the Setup Script**:

   ```bash
   sh setup.sh
   ```

3. **Open Neovim**:

   ```bash
   nvim
   ```

4. **Sync Plugins**:
   Run `:Lazy sync` in Neovim to install and configure all plugins.

## Conclusion

This Neovim configuration is designed to provide a robust development environment with essential tools and features. Feel free to customize it further to suit your workflow!
