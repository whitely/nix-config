{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    direnv
    devenv

    # Gaming/Input utilities
    jstest-gtk
    linuxConsoleTools

    # Graphics editing
    gimp-with-plugins

    # Applications
    chromium
    libreoffice

    # Hardware utilities
    usbutils
    pciutils
  ];
}
