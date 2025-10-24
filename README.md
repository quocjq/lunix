# Lunixose NixOS Configuration

A modular and scalable NixOS configuration using flakes and home-manager.

## Structure

```
.
├── lib/              # Helper functions and generators
├── hosts/            # NixOS host configurations
├── home/             # Home-manager configurations
├── modules/          # NixOS and home-manager modules
├── overlays/         # Package overlays
├── profiles/         # Reusable configuration profiles
└── parts/            # Flake parts
```

## Quick Start

### Build system configuration
```bash
just build nixos
```

### Apply system configuration
```bash
just switch nixos
```

### Build home configuration
```bash
just build-home quocjq nixos
```

### Apply home configuration
```bash
just switch-home quocjq nixos
```

## Adding a New Host

1. Create host directory: `mkdir -p hosts/newhostname`
2. Add configuration in `hosts/newhostname/default.nix`
3. Add to `parts/hosts.nix`:
```nix
newhostname = lib.generators.mkHost "newhostname" {
  users.quocjq = {};
  profile = "desktop";
};
```

## Adding a New User

1. Create user directory: `mkdir -p home/newuser`
2. Add configurations in `home/newuser/{default.nix,common.nix,hostname.nix}`
3. Add to `parts/homes.nix`:
```nix
"newuser@hostname" = lib.generators.mkHome "newuser" "hostname" {
  profile = "development";
};
```

## Profiles

- **NixOS Profiles** (`profiles/nixos/`):
  - `desktop.nix` - Desktop workstation setup
  - `laptop.nix` - Laptop-specific configurations
  - `server.nix` - Server configurations

- **Home Profiles** (`profiles/home/`):
  - `development.nix` - Development tools
  - `media.nix` - Media production tools
  - `minimal.nix` - Minimal setup

## Useful Commands

```bash
# Update all inputs
just update

# Check flake validity
just check

# Format all nix files
just fmt

# Clean old generations
just clean

# Optimize nix store
just optimize
```
