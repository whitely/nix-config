{ config, lib, pkgs, ... }:

{
  # XDG Desktop Portal configuration for KDE + Hyprland coexistence
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-hyprland  # Add it here so it's available
    ];

    # https://claude.ai/chat/bc476b69-74e9-44ab-8666-4ab5fcc6f6bf
    # config.common.default = "*"; # this caused ~/.nix-profile to include xdg-desktop-portal-hyprland, which meant our KDE fixes weren't working
    config = {
      common = {
        default = "kde";
        "org.freedesktop.impl.portal.Secret" = "kwallet";
      };
      # Configure hyprland to use its own portal when in that environment
      hyprland = {
        default = ["hyprland" "kde"];
      };
    };
  };

  # For some reason this keeps getting set to `/home/ben/.nix-profile/share/xdg-desktop-portal/portals`,
  # which contains only a Hyprland portal, even though I removed that from home-manager,
  # so just force it to be what we want here.
  environment.sessionVariables = {
    NIX_XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals";
  };
}
