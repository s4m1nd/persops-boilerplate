#!/usr/bin/env bash

# hack to find the actual tmux binary from Nix store
# I like tmux to start by default when I open the terminal
TMUX_BIN=$(ls -t /nix/store/*/bin/tmux | grep -v home-manager-path | grep -v user-environment | head -n1)

if [ ! -x "$TMUX_BIN" ]; then
  echo "Could not find tmux binary in Nix store"
  exit 1
fi

# debug output
# echo "Using tmux binary: $TMUX_BIN"

# STart or attach to tmux session
$TMUX_BIN attach || $TMUX_BIN new-session
