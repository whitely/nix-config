{ pkgs, lib, config, ... }:

let
  # Define dotfiles directory relative to the flake root
  dotfiles = ../../dotfiles;
in
{
  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    plugins = [
      pkgs.vimPlugins.vim-nix
    ];
  };

  # Home Manager dotfile management
  # The primary way to manage plain files is through 'home.file'.
  home.file = {
    # Git configuration
    ".gitconfig".source = "${dotfiles}/gitconfig";

    # KDE/Yakuake configuration
    ".config/autostart/org.kde.yakuake.desktop".source = "${dotfiles}/yakuake_autostart";
    ".config/autostart/nm-applet.desktop".source = "${dotfiles}/nm-applet_autostart";
    ".config/yakuakerc".source = "${dotfiles}/yakuakerc";

    # Game configuration (Elite Dangerous bindings)
    ".local/share/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Local Settings/Application Data/Frontier Developments/Elite Dangerous/Options/Bindings/Custom.4.1.binds".source = "${dotfiles}/Elite_Dangerous_4.1";
  };
}
