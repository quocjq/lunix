# List available commands
default:
    @just --list

# Update flake inputs
update:
    nix flake update

# Build NixOS configuration
build HOST="nixos":
    nh os switch . -a -n -H #{{HOST}}

# Switch to NixOS configuration
switch HOST="nixos":
    nh os switch . -a -H {{HOST}}

# Build home-manager configuration
hbuild USER="quocjq" HOST="nixos":
    nh home switch . -a -n -c {{USER}}@{{HOST}}

# Switch to home-manager configuration
hswitch USER="quocjq" HOST="nixos":
    nh home switch . -a -c {{USER}}@{{HOST}}

# Clean old generations
clean:
    sudo nh clean all -a -k 3

# Optimize nix store
optimize:
    sudo nix store optimise

# Check flake
check:
    nix flake check

# Format nix files
fmt:
    nix fmt

# Show flake info
info:
    nix flake show
