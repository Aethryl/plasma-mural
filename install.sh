#!/usr/bin/env bash
set -euo pipefail

repo="$(dirname "$(readlink -f "$0")")"
data="${XDG_DATA_HOME:-$HOME/.local/share}"

mkdir -p "$data/plasma/plasmoids" "$HOME/.local/bin"
ln -sfn "$repo/plasmoid" "$data/plasma/plasmoids/io.github.aethryl.mural"
ln -sfn "$repo/bin/mural" "$HOME/.local/bin/mural"
