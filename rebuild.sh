#!/usr/bin/env bash
set -e

# Config path (flake)
FLAKE_DIR="/etc/nixos"
HOSTNAME="Nixtilus"

# cd to flake dir
pushd "$FLAKE_DIR"

# Early return if no changes
if git diff --quiet '*.nix'; then
    echo "No .nix changes detected, checking for flake updates..."
else
    echo "Formatting and committing .nix changes..."
    alejandra . || (echo "Alejandra formatting failed!" && exit 1)
    git diff -U0 '*.nix'
fi

# Optional: update flake inputs
echo "Updating flake inputs..."
nix flake update

# Rebuild flake system
echo "Rebuilding system..."
sudo nixos-rebuild switch --flake "$FLAKE_DIR#$HOSTNAME" &>nixos-switch.log \
  || (grep --color error nixos-switch.log && exit 1)

# Get current generation
current=$(nixos-rebuild list-generations | grep current)

# Commit + push
git add .
git commit -m "auto rebuild: $current"
git push origin main

popd

notify-send -e "✅ NixOS rebuilt and pushed successfully!" --icon=software-update-available

