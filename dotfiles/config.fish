# if status is-interactive
# and not set -q TMUX
#     exec tmux
# end

direnv hook fish | source

set -gx XDG_DATA_DIRS "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
