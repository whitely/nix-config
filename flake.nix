{
  description = "Ben's NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.agave-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Host-specific configuration
        ./hosts/agave-nix

        # Core modules
        ./modules/core/nix.nix
        ./modules/core/boot.nix
        ./modules/core/networking.nix
        ./modules/core/locale.nix
        ./modules/core/cli.nix
        ./modules/core/services.nix

        # Hardware modules
        ./modules/hardware/amd-gpu.nix
        ./modules/hardware/audio.nix
        ./modules/hardware/opengl.nix
        ./modules/hardware/peripherals.nix

        # Desktop modules
        ./modules/desktop/desktop.nix
        ./modules/desktop/hyprland.nix
        ./modules/desktop/xdg-portals.nix
        ./modules/desktop/screenshare.nix

        # Services
        ./modules/services/avahi.nix
        ./modules/services/flatpak.nix

        # Virtualization
        ./modules/virtualization/virtualization.nix
        ./modules/virtualization/vfio.nix

        # Gaming
        ./modules/gaming/gaming.nix

        # Development
        ./modules/development/development.nix
        ./modules/development/shell.nix

        # AI
        ./modules/ai/ollama.nix

        # Applications
        ./modules/applications/applications.nix
        ./modules/applications/multimedia.nix

        # Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.ben = import ./home-manager/profiles/ben;
        }
      ];
    };
  };
}
