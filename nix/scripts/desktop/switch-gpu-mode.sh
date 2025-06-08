#!/run/current-system/sw/bin/bash

NIXOS_CONFIG_DIR="/etc/nixos"
PASSTHROUGH_FLAG="$NIXOS_CONFIG_DIR/gpu-passthrough-enabled"
FLAKE_DIR="/path/to/persops/nix"

switch_to_normal() {
  echo "Switching to normal mode..."
  sudo rm -f "$PASSTHROUGH_FLAG"
  sudo nixos-rebuild switch --flake "$FLAKE_DIR#desktop"
  echo "Switched to normal mode. Please reboot for changes to take effect."
}

switch_to_passthrough() {
  echo "Switching to passthrough mode..."
  sudo touch "$PASSTHROUGH_FLAG"
  sudo nixos-rebuild switch --flake "$FLAKE_DIR#desktop"
  echo "Switched to passthrough mode. Please reboot for changes to take effect."
}

case "$1" in
normal)
  switch_to_normal
  ;;
passthrough)
  switch_to_passthrough
  ;;
*)
  echo "Usage: $0 {normal|passthrough}"
  exit 1
  ;;
esac
