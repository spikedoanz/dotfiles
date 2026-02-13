#!/bin/sh
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake .#macbook
