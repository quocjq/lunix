# Build automation for NixOS multi-host configuration

# Default recipe - show available commands
default:
    @just --list


# NixOS command

# Build and switch to a specific host configuration
rebuild HOST="nixos":
     nh os switch . -H {{HOST}}

# Build configuration without switching (test)
build HOST="nixos":
     nh os build . -H {{HOST}}

# Check flake and show what would be built
check HOST="nixos":
	nh os build --dry . -H {{HOST}}

# Build and switch home-manager configuration
home HOST="quocjq@nixos":
     nh home switch . -c {{HOST}}

# Update all flake inputs
update:
    nix flake update

# Check flake for issues
check-flake:
    nix flake check

# Show system generations
gen:
		nh os info

# Show disk usage of nix store
du:
    du -sh /nix/store

# Clean build artifacts and temporary files
clean:
		sudo nh clean all --ask --keep 5

# # Bootstrap a new host (run on target machine)
# bootstrap HOST:
#     sudo nixos-rebuild switch --flake github:yourusername/nix-config#{{HOST}}

# Show differences between current and new system
diff HOST="nixos":
    nvd diff /run/current-system $(nix build .#nixosConfigurations.{{HOST}}.config.system.build.toplevel --no-link --print-out-paths)

# Show flake info
info:
    nix flake show

# Enter development shell
dev:
    nix develop

# Quick rebuild current host (assumes hostname matches configuration)
quick:
    #!/usr/bin/env bash
    HOST=$(hostname)
    echo "Rebuilding for host: $HOST"
    sudo nh os switch . -H $HOST

# Backup current system configuration
backup:
    #!/usr/bin/env bash
    BACKUP_DIR="$HOME/nix-config-backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    cp -r $HOME/Lunix/* "$BACKUP_DIR/" 2>/dev/null || true
    echo "Backup created at: $BACKUP_DIR"

# Show available hosts
hosts:
    @echo "Available hosts:"
    @ls hosts/ | grep -v default.nix | grep -v common

# Validate configuration syntax
validate:
    find . -name "*.nix" -exec nix-instantiate --parse {} \; > /dev/null
    echo "All Nix files have valid syntax"

# Install in minimal image
nixos-install:
		sudo nixos-install --flake .#nixos
