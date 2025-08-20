# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
  lock-empty-string = {
    Value = "";
    Status = "locked";
  };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./iommu.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/sdc";
  # boot.loader.grub.useOSProber = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = [ "v4l2loopback" ];

  # Include the kernel modules necessary for mounting /
  boot.initrd.kernelModules = [
    "sata_nv"
    "ext4"
    "amdgpu"
  ];

  # https://astrid.tech/2022/09/22/0/nixos-gpu-vfio/
  boot.kernelParams = [ "amd_iommu=on" ];
  specialisation."VFIO".configuration = {
    system.nixos.tags = [ "with-vfio" ];
    vfio.enable = true;
  };

  networking.hostName = "agave-nix"; # Define your hostname.
  # Use networkmanager instead of wpa_supplicant
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Enables wireless via networkmanager.

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };


  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable Hyprland
  # https://wiki.hyprland.org/Nix/
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # portalPackage = inputs.xdg-desktop-portal-hyprland.packages."${pkgs.system}".xdg-desktop-portal-hyprland;
    # https://github.com/NixOS/nixpkgs/issues/277230
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber = {
      enable = true;
      configPackages = [];
    };
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vim git file
    gparted
    kate yakuake tmux
    p7zip zip

    kitty wofi

    plasma-nm connman networkmanagerapplet

    tmux grc
    jq ripgrep fd tldr fzf
    fishPlugins.fzf
    xsel xclip
    
#     firefox-bin
    # tdesktop
    signal-desktop weechat
    amarok vlc streamlink
    pavucontrol
#     gksu
    veracrypt
    
    gcc-unwrapped gnumake
    nurl nix-search-cli
    python3

    # For image-boostrap
    gnupg multipath-tools parted busybox

    deluge

    # For mounting exFAT SD cards, etc.
#     exfat fuse_exfat exfat-utils

    # For use with PulseAudio
#     gstreamer

    lm_sensors htop
    dmidecode neofetch
    glxinfo vulkan-tools

    _1password-gui _1password
    nextcloud-client

    steam-run
    # Links may not open in FF, Krisp won't work, etc.: https://nixos.wiki/wiki/Discord
    discord vesktop xwaylandvideobridge # Screen sharing on Wayland
    piper libratbag # Gaming mouse config program
    wev xorg.xev # Mouse and keyboard viewers, to see which keycode a button/key is
    mako # notification service for discord
    obs-studio

    inotify-tools # For finding those pesky config files on *nix-steam: `inotifywatch -r --event close_write ~/.local/share/Steam/steamapps/common/Elite\ Dangerous/`

    dolphin-emu
    appimage-run # For Slippi

    quickemu
    virt-manager virt-viewer
    spice spice-protocol spice-gtk
    samba4Full
    libguestfs guestfs-tools ncdu

    pciutils # How I'm getting the lspci manpage
    coolercontrol.coolercontrol-gui coolercontrol.coolercontrold coolercontrol.coolercontrol-ui-data coolercontrol.coolercontrol-liqctld

    gnome-network-displays d-spy door-knocker
    xdg-desktop-portal-gtk xdg-desktop-portal-hyprland xdg-desktop-portal-gnome xdg-desktop-portal-wlr
  ];

  xdg.portal = {
    enable = true;

    xdgOpenUsePortal = true;
    # gtkUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-hyprland
    ];

    config.common.default = "*";
  };
  networking.firewall = {
    allowedTCPPorts = [7236 7250];
    allowedUDPPorts = [7236 5353];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
        enable = true;
        userServices = true;
        addresses = true;
    };
  };
  # Does this link in the readme matter? https://gitlab.gnome.org/GNOME/gnome-network-displays
  # NetworkManager only support P2P operation together with wpa_supplicant.

  # Fish!
  programs.fish.enable = true;

  programs.firefox = {
    enable = true;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab";
      # DisablePocket = true;
      SearchBar = "unified";

      EnableTrackingProtection = {
        Value= true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Preferences = {
        # Privacy settings
        # "extensions.pocket.enabled" = lock-false;
        "browser.newtabpage.pinned" = lock-empty-string;
        # "browser.topsites.contile.enabled" = lock-false;
        "browser.newtabpage.activity-stream.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;
      };

      # Get extension IDs from about:support
      # see https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4546733/1password_x_password_manager-8.11.4.27.xpi";
          installation_mode = "force_installed";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
        "extension@tabliss.io" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
          installation_mode = "force_installed";
        };
        "{84601290-bec9-494a-b11c-1baa897a9683}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4192880/ctrl_number_to_switch_tabs-1.0.2.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # Certain features, including CLI integration and system authentication support,
    # require enabling PolKit integration on some desktop environments (e.g. Plasma).
    polkitPolicyOwners = [ "ben" ];
  };

  services.flatpak.enable = true;
  # Add a repo afterwards: `flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo`

  programs.appimage.binfmt = true; # Allow direct running of appimage; see https://nixos.wiki/wiki/Appimage
  # GameCube controller hardware support
#   services.udev.packages = [ pkgs.dolphinEmu ];
#   boot.extraModulePackages = [
#     config.boot.kernelPackages.gcadapter-oc-kmod
#   ];
#
#   # to autoload at boot:
#   boot.kernelModules = [
#     "gcadapter_oc"
#   ];

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Web browser addons
#  pkgs.firefox-bin = {
#    enableGoogleTalkPlugin = true;
#    enableAdobeFlash = true;
#  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.ratbagd.enable = true;
  # `ratbagctl list` to get device cute names, e.g. "singing-gundi" for my mouse
  # `ratbagctl singing-gundi button 6 action set macro KEY_F8` to set macro (can also interact with `piper` to do it via GUI)
  # In KDE settings, "Legacy X11 App Support" to allow F keys to be read globally
  # Find it: https://github.com/shalva97/kde-configuration-files

  services.hardware.openrgb.enable = true;
  # services.hardware.sensors.enable = true; # ChatGPT suggested this to me but it doesn't work

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Compromise for those juicy frames
  nixpkgs.config.allowUnfree = true;

  # Enable VirtualBox
#   virtualisation.virtualbox.host.enable = true;
#   # Disable hardening to allow 3D acceleration
#   virtualisation.virtualbox.host.enableHardening = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.ben = { pkgs, ... }: {
    programs.bash.enable = true;

    wayland.windowManager.hyprland = {
      enable = true;

      # config specified via settings is in nix lang
      # config specified via extraConfig is just hyprland raw config
      settings = {
        "$mod" = "ALT";
        "$mainMod" = "ALT";
      };

      # TODO: replace all this inline config with
      # source = ~/.config/hypr/myColors.conf

      extraConfig = ''
        source = ~/.config/hypr/basic.conf
      '';


#       "$mainMod" = "ALT";
#       bind =
#         [
#           "$mod, F, exec, firefox"
#           ", Print, exec, grimblast copy area"
#         ]
#         ++ (
#           # workspaces
#           # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
#           builtins.concatLists (builtins.genList (
#               x: let
#                 ws = let
#                   c = (x + 1) / 10;
#                 in
#                   builtins.toString (x + 1 - (c * 10));
#               in [
#                 "$mod, ${ws}, workspace, ${toString (x + 1)}"
#                 "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
#               ]
#             )
#             10)
#         );

#       plugins = [
#         inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
#       ];
    };

    programs.fish = {
      enable = true;
      plugins = [
      # Necessary when using home-manager standalone installed on e.g. Ubuntu, but probably not necessary on nixos
#         {
#           name = "_00-nix-env"; # Prefixing with _00 to ensure environment loads before other stuff; fish sources alphabetically
#           src = pkgs.fetchFromGitHub {
#             owner = "lilyball";
#             repo = "nix-env.fish";
#             rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
#             sha256 = "RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
#           };
#         }
        {
          name = "10-config";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-config";
            rev = "13c424efb73b153d9b8ad92916cf51159d44099d";
            sha256 = "23hjWq1xdFs8vTv56ebD4GdhcDtcwShaRbHIehPSOXQ=";
          };
        }
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
            sha256 = "+FUBM7CodtZrYKqU542fQD+ZDGrd2438trKM0tIESs0=";
          };
        }
        {
          name = "tmux-zen";
          src = pkgs.fetchFromGitHub {
            owner = "sagebind";
            repo = "tmux-zen";
            rev = "1162f59ebd057fd6c881b58e2bedf04bbe9ca3cf";
            hash = "sha256-Oc3IfWK+EO4TN3eU7lpz85qhqDohIL+7pS1fcl31i3s=";
          };
        }
        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
      ];

      interactiveShellInit = ''
        # Switched to using tmux-zen
        # if not set -q TMUX
        #   exec tmux
        # end

        set -gx XDG_DATA_DIRS "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"

        set PATH /home/ben/.local/bin/ $PATH

        direnv hook fish | source
      '';

      functions = {
        # Steal OMF's reload function https://github.com/oh-my-fish/oh-my-fish/blob/master/pkg/omf/functions/core/omf.reload.fish
        reload = ''
          set -q CI; and return 0

          history --save
          set -gx dirprev $dirprev
          set -gx dirnext $dirnext
          set -gx dirstack $dirstack
          set -gx fish_greeting ""

          exec fish
        '';

        nrs = ''sudo nixos-rebuild switch'';

        win = ''quickemu --vm ~/virtual_machines/windows-10.conf --display spice --width 1920 --height 1080'';

        record = ''wf-recorder -g "$(slurp)" -f "$argv[1]"'';
      };
    };

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    home.file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      ".config/hypr/basic.conf".source = dotfiles/hyprland_basic.conf;
      ".config/waybar" = {
        source = dotfiles/waybar;
        recursive = true;
      };
      ".config/hypr/screenshots" = {
        source = dotfiles/hypr/screenshots;
        recursive = true;
      };
      ".config/hypr/hypr_gamemode.sh".source = dotfiles/hypr/hypr_gamemode.sh;
      ".config/wofi/style.css".source = dotfiles/hypr/wofi.css;
      ".config/hypr/hyprpaper.conf".source = dotfiles/hypr/hyprpaper.conf;
      ".local/share/applications/Bemoji.desktop".source = dotfiles/Bemoji.desktop;

      ".tmux.conf".source = dotfiles/tmuxconf;
      # ".config/fish/config.fish".source = dotfiles/config.fish;

      ".gitconfig".source = dotfiles/gitconfig;

      ".config/autostart/org.kde.yakuake.desktop".source = dotfiles/yakuake_autostart;
      ".config/autostart/nm-applet.desktop".source = dotfiles/nm-applet_autostart;
      ".config/yakuakerc".source = dotfiles/yakuakerc;

      ".local/bin/ls-iommu".source = dotfiles/ls-iommu;
      ".local/bin/ls-usb".source = dotfiles/ls-usb;

      # virt XML is autogenerated and stored in /var/lib/libvirt/qemu/win10-vfio.xml
      # run this once the machine has been started once: `sudo virsh net-autostart default`

      ".local/share/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Local Settings/Application Data/Frontier Developments/Elite Dangerous/Options/Bindings/Custom.4.1.binds".source = dotfiles/Elite_Dangerous_4.1;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
    };

    home.packages = with pkgs; [
      direnv devenv
      jstest-gtk linuxConsoleTools
      # joystickwake # doesn't seem to work; just use `gamemoderun %command%` in steam options for E:D and other joystick apps to prevent sleep

      hyprpaper waybar font-awesome font-awesome_5 playerctl
      xdg-desktop-portal-hyprland grim slurp swappy grimblast
      wl-clipboard wl-screenrec wf-recorder ffmpeg-full

      gimp-with-plugins
      wofi-emoji bemoji

      chromium libreoffice

      ventoy-full

      usbutils pciutils
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
    };

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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      plugins = [
        pkgs.vimPlugins.vim-nix
      ];
    };

    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };

    # Looks like there's a flake here for slippi:
    # https://github.com/djanatyn/ssbm-nix
    # it's cloned in ~/code/
#     ssbm.slippi-launcher= {
#       enable = true;
#       # Replace with the path to your Melee ISO
#       isoPath = "Path/To/SSBM.ciso";
#     };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "24.05";
  };

  # user Ben
  users.users.ben = {
    isNormalUser = true;
    shell = pkgs.fish;
    description = "Ben";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "gamemode" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.java.enable = true;

  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers

#     package = pkgs.steam.override { withJava = true; };
    gamescopeSession.enable = true; # Display upscaling

    # If all the text is tiny, run steam this way:
    # GDK_SCALE=2 steam

    # See https://nixos.wiki/wiki/Steam#Changing_the_driver_on_AMD_GPUs

    # Gamemode settings
    # Make sure you edit each game's launch command to be `gamemoderun %command%`!
    # https://nixos.wiki/wiki/Gamemode
    package = pkgs.steam.override {
      extraPkgs = (pkgs: with pkgs; [
        gamemode
        # additional packages...
        # e.g. some games require python3
      ]);
      # extraLibraries = pkgs: [ pkgs.gperftools ];
      # - Automatically enable gamemode whenever Steam is running
      # -- NOTE: Assumes that a working system install of gamemode already exists!
      extraProfile = let gmLib = "${lib.getLib(pkgs.gamemode)}/lib"; in ''
        export LD_LIBRARY_PATH="${gmLib}:$LD_LIBRARY_PATH"
      '';
    };
  };

  programs.dconf.enable = true; # virt-manager requires dconf to remember settings
  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [(pkgs.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        }).fd];
      };
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];

    ## radv: an open-source Vulkan driver from freedesktop
    driSupport = true;
    driSupport32Bit = true;

    ## amdvlk: an open-source Vulkan driver from AMD
#     extraPackages = [ pkgs.amdvlk ];
#     extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
  };


  # Define the systemd containers
  # Arch - gaming:
#   systemd.nspawn.arch = {
#     enable = true;
#     execConfig = { Boot = true; };
#     filesConfig = {
#       Volatile = true; # Will make the OS stateless.
#     };
#     networkConfig = { VirtualEthernet = true; Port = "tcp:2200:22"; }; # Map localhost:2200 to container:22
#
#   };



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
