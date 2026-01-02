#!/bin/bash
# Remove symlinks and restore backups

MSF_HOME="$HOME/.msf4"
DIRS=("modules" "plugins" "scripts" "logos")

echo "=== Removing Metasploit Config Overlay ==="

for dir in "${DIRS[@]}"; do
    dest="$MSF_HOME/$dir"

    if [ -L "$dest" ]; then
        rm "$dest"
        echo "  [removed] $dir symlink"

        # Restore backup if exists
        if [ -d "${dest}.bak" ]; then
            mv "${dest}.bak" "$dest"
            echo "  [restored] $dir from backup"
        else
            mkdir -p "$dest"
            echo "  [created] empty $dir"
        fi
    fi
done

# Handle msfconsole.rc
if [ -L "$MSF_HOME/msfconsole.rc" ]; then
    rm "$MSF_HOME/msfconsole.rc"
    echo "  [removed] msfconsole.rc symlink"
    [ -f "$MSF_HOME/msfconsole.rc.bak" ] && mv "$MSF_HOME/msfconsole.rc.bak" "$MSF_HOME/msfconsole.rc"
fi

echo ""
echo "Done! Symlinks removed."
