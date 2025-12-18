{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    direnv
    devenv

    # Gaming/Input utilities
    jstest-gtk
    linuxConsoleTools

    # Hyprland/Wayland utilities
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

    # Graphics editing
    gimp-with-plugins

    # Emoji picker
    wofi-emoji
    bemoji

    # Applications
    chromium
    libreoffice

    # Hardware utilities
    usbutils
    pciutils
  ];
}
