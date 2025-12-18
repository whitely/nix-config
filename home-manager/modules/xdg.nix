{ pkgs, lib, ... }:

{
  # MIME type associations
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
    NIX_XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals";
  };
}
