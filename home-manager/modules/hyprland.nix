{ pkgs, lib, ... }:

let
  dotfiles = ../../dotfiles;
in
{
  # Disable XDG portal in home-manager (system-level portal is used instead)
  # This caused lots of problems and I eventually tracked it down via AI debugging:
  # https://claude.ai/chat/bc476b69-74e9-44ab-8666-4ab5fcc6f6bf
  xdg.portal.enable = lib.mkForce false;

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

  # Hyprland-related dotfiles
  home.file = {
    ".config/hypr/basic.conf".source = "${dotfiles}/hyprland_basic.conf";

    ".config/waybar" = {
      source = "${dotfiles}/waybar";
      recursive = true;
    };

    ".config/hypr/screenshots" = {
      source = "${dotfiles}/hypr/screenshots";
      recursive = true;
    };

    # Application launcher
    ".local/share/applications/Bemoji.desktop".source = "${dotfiles}/Bemoji.desktop";

    ".config/hypr/hypr_gamemode.sh".source = "${dotfiles}/hypr/hypr_gamemode.sh";
    ".config/wofi/style.css".source = "${dotfiles}/hypr/wofi.css";
    ".config/hypr/hyprpaper.conf".source = "${dotfiles}/hypr/hyprpaper.conf";
  };

  # Hyprland-related packages
  home.packages = with pkgs; [
    # Wayland utilities
    hyprpaper
    waybar
    font-awesome
    font-awesome_5
    playerctl

    # Screenshot and recording tools
    grim
    slurp
    swappy
    grimblast
    wl-clipboard
    wl-screenrec
    wf-recorder
    ffmpeg-full

    # Emoji picker
    wofi-emoji
    bemoji
  ];
}
