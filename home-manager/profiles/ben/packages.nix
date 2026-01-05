{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    direnv
    devenv
    inputs.claude-code.packages.${pkgs.system}.default

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
