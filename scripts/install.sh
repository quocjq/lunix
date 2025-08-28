#!/bin/sh
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix
sudo nixos-install --flake .#nixos

