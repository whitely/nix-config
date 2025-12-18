{ pkgs, lib, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
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
}
