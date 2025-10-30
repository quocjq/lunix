# List available commands
default:
    @just --list

# Update flake inputs
update:
    nix flake update

# Build NixOS configuration (with home-manager)
build HOST="nixos":
    nh os switch . -a -n -H {{HOST}}

# Switch to NixOS configuration (with home-manager)
switch HOST="nixos":
    nh os switch . -a -H {{HOST}}

# Test NixOS configuration
test HOST="nixos":
    nh os test . -a -H {{HOST}}

# Boot into new NixOS configuration
boot HOST="nixos":
    nh os boot . -a -H {{HOST}}

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

# Show what would be built
diff HOST="nixos":
    nh os build . -a -H {{HOST}} -- --dry-run
