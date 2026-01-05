{
  description = "Ben's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # claude = ""
    #  nix run github:sadjow/claude-code-nix --extra-experimental-features nix-command --extra-experimental-features flakes
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      agave-nix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Virtualization - imported early to ensure correct initrd module load order
          # VFIO modules must load before amdgpu (see vfio.nix:18)
          ./modules/virtualization/virtualization.nix
          ./modules/virtualization/vfio.nix

          # Core modules
          ./modules/system/audio.nix
          ./modules/system/boot.nix
          ./modules/system/cli.nix
          ./modules/system/locale.nix
          ./modules/system/nix.nix
          ./modules/system/services.nix

          # Desktop modules
          ./modules/desktop/desktop.nix
          ./modules/desktop/hyprland.nix
          ./modules/desktop/screenshare.nix
          ./modules/desktop/xdg-portals.nix

          # Applications
          ./modules/applications/appcompat.nix
          ./modules/applications/applications.nix
          ./modules/applications/development.nix
          ./modules/applications/gaming.nix
          ./modules/applications/multimedia.nix
          ./modules/applications/ollama.nix

          # Host-specific configuration
          ./hosts/agave-nix

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.ben = import ./home-manager/profiles/ben;
          }
        ];
      };
      shrub-nix = nixpkgs.lib.nixosSystem {
        # This entire block taken from old/other branch
        ### Claude rewrite starting here
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          # Host-specific configuration
          ./hosts/shrub-nix

          # Core modules
          ./modules/core/nix.nix
          ./modules/core/boot.nix
          ./modules/core/networking.nix
          ./modules/core/locale.nix
          ./modules/core/cli.nix
          ./modules/core/services.nix

          # Hardware modules (excluding peripherals)
          ./modules/hardware/amd-gpu.nix
          ./modules/hardware/audio.nix
          ./modules/hardware/opengl.nix

          # Desktop modules
          ./modules/desktop/desktop.nix
          ./modules/desktop/hyprland.nix
          ./modules/desktop/xdg-portals.nix
          ./modules/desktop/screenshare.nix

          # Services
          ./modules/services/avahi.nix
          ./modules/services/flatpak.nix

          # Virtualization (VFIO only, no virt-manager)
          ./modules/virtualization/vfio.nix

          # Gaming
          ./modules/gaming/gaming.nix

          # Development
          ./modules/development/development.nix
          ./modules/development/shell.nix

          # Applications
          ./modules/applications/applications.nix
          ./modules/applications/multimedia.nix

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.ben = import ./home-manager/profiles/shrub-nix;
          }
        ];
        ### Claude rewrite stopping here
      };
    };


  };
}
