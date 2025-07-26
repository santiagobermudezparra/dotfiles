#!/bin/bash
set -euo pipefail

# Install chezmoi if missing
if ! command -v chezmoi >/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:santiagobermudezparra/dotfiles.git
fi

exit 0
