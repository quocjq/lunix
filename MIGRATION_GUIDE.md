# Migration Guide: Standalone to NixOS Module Home-Manager

## What Changed?

Your home-manager configuration has been migrated from standalone mode to NixOS module mode. This means home-manager is now integrated directly into your NixOS system configuration.

## Benefits

1. **Unified rebuilds**: One command (`nixos-rebuild` or `nh os switch`) now rebuilds both system and home configurations
2. **Better integration**: Home-manager and system configurations share the same nixpkgs instance
3. **Simplified workflow**: No need to run separate commands for system and home rebuilds
4. **Easier to manage**: All configuration in one place

## File Changes

### Created Files
- `lib/default.nix` - Library entry point
- `lib/generators.nix` - Host generation logic with home-manager integration
- `MIGRATION_GUIDE.md` - This file

### Modified Files
- `parts/hosts.nix` - Now includes user and home-manager configuration
- `home/quocjq/common.nix` - Removed redundant home.* settings (auto-generated now)
- `parts/homes.nix` - Now optional (for standalone configs only)
- `justfile` - Updated commands

### Backup Files
All modified files have been backed up with `.backup.YYYYMMDD_HHMMSS` extension

### Can Be Deleted
- `home/quocjq/default.nix.old` - No longer needed
- All `.backup.*` files after confirming everything works

## New Workflow

### Before (Standalone)
```bash
# System rebuild
sudo nixos-rebuild switch --flake .#nixos

# Home rebuild (separate command)
home-manager switch --flake .#quocjq@nixos
```

### After (NixOS Module)
```bash
# Single command rebuilds both system AND home
sudo nixos-rebuild switch --flake .#nixos

# Or using nh
nh os switch .

# Or using just
just switch
```

## Configuration Structure

### System + Home Configuration in `parts/hosts.nix`
```nix
nixos = lib.generators.mkHost "nixos" {
  system = "x86_64-linux";
  profile = "desktop";  # NixOS profile
  
  users = {
    quocjq = {
      isMainUser = true;
      homeProfile = "development";  # Home-manager profile
    };
  };
};
```

### User Configuration Files
- `home/quocjq/common.nix` - Shared across all hosts
- `home/quocjq/nixos.nix` - Specific to the nixos host
- `profiles/home/development.nix` - Profile-specific packages

### How It Works
1. The `mkHost` function creates a NixOS configuration
2. It automatically includes home-manager as a module
3. For each user, it loads:
   - `home/{username}/common.nix`
   - `home/{username}/{hostname}.nix` (if exists)
   - `profiles/home/{homeProfile}.nix`

## Adding New Hosts

```nix
laptop = lib.generators.mkHost "laptop" {
  system = "x86_64-linux";
  profile = "desktop";
  
  users = {
    quocjq = {
      isMainUser = true;
      homeProfile = "minimal";  # Use different profile for laptop
    };
  };
};
```

## Adding New Users

```nix
nixos = lib.generators.mkHost "nixos" {
  system = "x86_64-linux";
  profile = "desktop";
  
  users = {
    quocjq = {
      isMainUser = true;
      homeProfile = "development";
    };
    guest = {
      homeProfile = "minimal";  # Guest gets minimal setup
    };
  };
};
```

## Testing

After migration, test with:
```bash
# Check flake
nix flake check

# Or using just
just check

# Dry run (see what would change)
just diff

# Build without switching
just build

# Full rebuild
just switch
```

## Common Issues

### Issue: Home-manager config not applied
**Solution**: Make sure you're using `sudo nixos-rebuild switch`, not just `nixos-rebuild switch`

### Issue: User home directory doesn't exist
**Solution**: The user must be created first by the NixOS configuration in `hosts/common/core/users.nix`

### Issue: Home-manager version mismatch
**Solution**: Both NixOS and home-manager should use the same nixpkgs input (already configured in flake.nix)

## Cleanup

After confirming everything works:
```bash
# Remove old default.nix
rm home/quocjq/default.nix.old

# Remove backup files
rm **/*.backup.*
```
