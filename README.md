# NixOS Flake Configuration

Ben's modular NixOS configuration using flakes and home-manager.

## Structure

```
nix-config/
├── flake.nix                 # Main flake entry point
├── flake.lock                # Locked dependency versions
│
├── hosts/
│   └── agave-nix/
│       ├── default.nix       # Host-specific configuration
│       └── hardware-configuration.nix
│
├── modules/                  # NixOS system modules
│   ├── core/                 # Essential system configuration
│   ├── hardware/             # Hardware-specific modules
│   ├── desktop/              # Desktop environments & utilities
│   ├── services/             # System services
│   ├── virtualization/       # VM and VFIO configuration
│   ├── gaming/               # Gaming-related modules
│   ├── development/          # Development tools
│   ├── ai/                   # AI/ML services
│   └── applications/         # Application bundles
│
├── home-manager/
│   ├── profiles/
│   │   └── ben/              # User-specific configuration
│   │       ├── default.nix   # Main user config
│   │       └── packages.nix  # User packages
│   └── modules/              # HM feature modules
│       ├── fish.nix          # Fish shell with plugins
│       ├── hyprland.nix      # Hyprland user config
│       ├── neovim.nix        # Neovim configuration
│       ├── dotfiles.nix      # Dotfile management
│       └── xdg.nix           # XDG configuration
│
└── dotfiles/                 # Configuration files (unchanged)
```

## Usage

### Building the Configuration

Test build without switching:
```bash
nixos-rebuild build --flake .#agave-nix
```

### Switching to the New Configuration

Apply the configuration:
```bash
sudo nixos-rebuild switch --flake .#agave-nix
```

### Testing in a VM

Build and test in a virtual machine:
```bash
nixos-rebuild build-vm --flake .#agave-nix
./result/bin/run-*-vm
```

### Updating Dependencies

Update flake inputs:
```bash
nix flake update
```

Update specific input:
```bash
nix flake update nixpkgs
```

### Managing Flake

Show flake outputs:
```bash
nix flake show
```

Check flake:
```bash
nix flake check
```

## Adding a New Host

1. Create a new directory in `hosts/`:
```bash
mkdir -p hosts/new-host
```

2. Create `hosts/new-host/default.nix`:
```nix
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "new-host";

  # User configuration
  users.users.username = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "24.05";
}
```

3. Generate hardware configuration:
```bash
nixos-generate-config --show-hardware-config > hosts/new-host/hardware-configuration.nix
```

4. Add to `flake.nix`:
```nix
nixosConfigurations.new-host = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./hosts/new-host
    # ... add desired modules
  ];
};
```

## Module Organization

### Core Modules
- **boot.nix**: Bootloader, kernel modules, VFIO specialisation
- **networking.nix**: NetworkManager, firewall
- **locale.nix**: Timezone, internationalization
- **nix.nix**: Nix settings, flakes, allowUnfree

### Desktop Modules
- **plasma.nix**: KDE Plasma 6 + SDDM
- **hyprland.nix**: Hyprland Wayland compositor
- **xdg-portals.nix**: XDG portal configuration (critical for KDE/Hyprland coexistence)
- **utilities.nix**: Desktop utilities and tools

### Important Notes

#### XDG Portals
The `xdg-portals.nix` module includes a critical workaround for KDE/Hyprland coexistence. The `NIX_XDG_DESKTOP_PORTAL_DIR` environment variable must be set to prevent conflicts.

#### VFIO Specialisation
Boot into VFIO mode for GPU passthrough:
```bash
# At bootloader, select "NixOS (with-vfio)"
```

#### Fish Shell Functions
- `reload` - Reload Fish shell
- `nrs` - nixos-rebuild switch
- `win` - Launch Windows VM with quickemu
- `record` - Record screen with wf-recorder

## Backup

The original monolithic configuration is backed up as `configuration.nix.bak`.

To revert to the old configuration:
```bash
mv configuration.nix.bak configuration.nix
sudo nixos-rebuild switch
```

## Tips

### Enabling/Disabling Modules

Modules can be selectively enabled per-host by importing them in the host's `default.nix` or in `flake.nix`.

### Adding New Modules

1. Create module file in appropriate directory
2. Add to `flake.nix` imports list
3. Rebuild to test

### Using with direnv

Add to your project's `.envrc`:
```bash
use flake .#agave-nix
```

## Troubleshooting

### Flake Not Found
Ensure all files are tracked in git:
```bash
git add <new-file>
```

### Evaluation Errors
Check syntax with:
```bash
nix flake check
```

### Build Errors
Use `--show-trace` for detailed error messages:
```bash
nixos-rebuild build --flake .#agave-nix --show-trace
```

## Resources

- [NixOS Flakes Manual](https://nixos.wiki/wiki/Flakes)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Hyprland on Nix](https://wiki.hyprland.org/Nix/)
