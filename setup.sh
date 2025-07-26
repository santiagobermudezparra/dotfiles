#!/bin/bash

set -euo pipefail

if ! command -v chezmoi >/dev/null; then
sh -c "$(curl -fsLS [get.chezmoi.io](http://get.chezmoi.io/))" -- init --apply [git@github.com](mailto:git@github.com):santiagobermudezparra/dotfiles.git
fi

exit 0
