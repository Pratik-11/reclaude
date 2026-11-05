#!/usr/bin/env bash
# curl -fsSL https://raw.githubusercontent.com/Pratik-11/reclaude/main/install.sh | bash
set -euo pipefail
command -v jq >/dev/null || { echo "reclaude needs jq: sudo apt install jq"; exit 1; }
command -v crontab >/dev/null || { echo "reclaude needs cron (Debian/Ubuntu: sudo apt install cron, Fedora/Arch: install and enable cronie)"; exit 1; }

BIN="$HOME/.local/bin/reclaude"
mkdir -p "$(dirname "$BIN")"
curl -fsSL https://raw.githubusercontent.com/Pratik-11/reclaude/main/reclaude -o "$BIN"
chmod +x "$BIN"

# snapshot running sessions every minute
(crontab -l 2>/dev/null | grep -v reclaude || true; echo "* * * * * PATH=/usr/local/bin:/usr/bin:/bin $BIN save") | crontab -

echo "Installed $BIN. After a reboot, run: reclaude"
[[ ":$PATH:" == *":$HOME/.local/bin:"* ]] || echo "Add ~/.local/bin to your PATH."
