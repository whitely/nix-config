{ pkgs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    # Config specified via settings is in Nix lang
    # Config specified via extraConfig is just Hyprland raw config
    settings = {
      "$mod" = "ALT";
      "$mainMod" = "ALT";
    };

    # Source the main Hyprland configuration from dotfiles
    extraConfig = ''
      source = ~/.config/hypr/basic.conf
    '';

    # Example of Nix-based config (commented out, currently using dotfiles)
    # "$mainMod" = "ALT";
    # bind =
    #   [
    #     "$mod, F, exec, firefox"
    #     ", Print, exec, grimblast copy area"
    #   ]
    #   ++ (
    #     # workspaces
    #     # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    #     builtins.concatLists (builtins.genList (
    #         x: let
    #           ws = let
    #             c = (x + 1) / 10;
    #           in
    #             builtins.toString (x + 1 - (c * 10));
    #         in [
    #           "$mod, ${ws}, workspace, ${toString (x + 1)}"
    #           "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
    #         ]
    #       )
    #       10)
    #   );
    #
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
    # ];
  };
}
