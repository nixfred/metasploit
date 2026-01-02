#!/bin/bash
# Metasploit Config Overlay Script
# Symlinks msf-dotfiles to ~/.msf4
# Run AFTER installing Metasploit Framework

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MSF_DOTFILES="$SCRIPT_DIR/msf-dotfiles"
MSF_HOME="$HOME/.msf4"

echo "=== Metasploit Config Overlay ==="
echo "Source: $MSF_DOTFILES"
echo "Target: $MSF_HOME"
echo ""

# Check if Metasploit is installed
if ! command -v msfconsole &> /dev/null; then
    echo "ERROR: Metasploit not found. Install it first:"
    echo "  brew install metasploit"
    exit 1
fi

# Ensure ~/.msf4 exists (run msfconsole once to create it)
if [ ! -d "$MSF_HOME" ]; then
    echo "Initializing Metasploit (first run)..."
    msfconsole -q -x "exit" 2>/dev/null
fi

# Directories to symlink
DIRS=("modules" "plugins" "scripts" "logos")

for dir in "${DIRS[@]}"; do
    src="$MSF_DOTFILES/$dir"
    dest="$MSF_HOME/$dir"

    if [ -d "$src" ] && [ "$(ls -A "$src" 2>/dev/null)" ]; then
        # Source has content, set up symlink
        if [ -L "$dest" ]; then
            echo "  [skip] $dir already symlinked"
        elif [ -d "$dest" ]; then
            # Backup existing and symlink
            echo "  [backup] $dest -> ${dest}.bak"
            mv "$dest" "${dest}.bak"
            ln -s "$src" "$dest"
            echo "  [link] $dir"
        else
            ln -s "$src" "$dest"
            echo "  [link] $dir"
        fi
    else
        echo "  [skip] $dir (empty in repo)"
    fi
done

# Handle msfconsole.rc if it exists
if [ -f "$MSF_DOTFILES/msfconsole.rc" ]; then
    if [ -L "$MSF_HOME/msfconsole.rc" ]; then
        echo "  [skip] msfconsole.rc already symlinked"
    else
        [ -f "$MSF_HOME/msfconsole.rc" ] && mv "$MSF_HOME/msfconsole.rc" "$MSF_HOME/msfconsole.rc.bak"
        ln -s "$MSF_DOTFILES/msfconsole.rc" "$MSF_HOME/msfconsole.rc"
        echo "  [link] msfconsole.rc"
    fi
fi

echo ""
echo "Done! Your Metasploit configs are now linked."
echo "Run 'msfconsole' to verify."
