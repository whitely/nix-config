{ config, pkgs, ... }:
{
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

  home.packages = with pkgs; [
    grc
    tmux
  ];


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
