# s4m1nd/persops-boilerplate

Nix configuration (not my actual config I tried to make it a little bit more modular) template for managing both macOS and NixOS Linux PC.

I currently have two systems I provision with this config:

- macOS: Macbook Pro 14" M1 Pro 16GB RAM, 1TB SSD
- NixOS: 32GB RAM, i7 CPU, 2TB SSD, 1080 NVIDIA GPU (For GPU passtrough you need to update `nix/hosts/desktop/gpu/*.nix` with your actual GPU info but it should be quite similar)

## project structure

- `nix/`: nix config
- `nix/flake.nix`: nix flakes
- `nix/home/default.nix`: nix home manager
- `nix/hosts/common/default.nix`: shared config for all systems
- `nix/hosts/mac/default.nix`: macOS config
- `nix/hosts/desktop/default.nix`: nixos desktop pc config
- `nix/hosts/desktop/gpu/normal.nix`: nixos desktop pc normal gpu mode
- `nix/hosts/desktop/gpu/passtrough.nix`: nixos desktop pc gpu passtrough mode
- `nix/hosts/desktop/hardware.nix`: replace it with your own nixos hardware config
- `nix/scripts/start-with-tmux.sh`: starts tmux
- `nix/scripts/desktop/switch-gpu-mode.sh`: switches gpu modes on pc
- `nix/programs/*`: config that's going to be copied to the corresponding location as per home manager.

## macOS setup

```bash
sh <(curl -L https://nixos.org/nix/install)
git clone git@github.com:s4m1nd/persops-boilerplate.git
cd persops-boilerplate
# see ./nix README.md for more details after
```

## Replace my username (s4m1nd) from all files

### If you're on Linux

```bash
find . -type f -exec sed -i 's/s4m1nd/YOURUSERNAME/g' {} +
```

### If you're on macOS

```bash
find . -type f -exec sed -i '' 's/s4m1nd/YOURUSERNAME/g' {} +
```

### Replace all occurrences of `/path/to` because I don't know where you'd like to place your config

If you have a clever way to do it automatically or via a startup script feel free to open a PR.

```bash
grep -rn "/path/to/" .
```

## Found this template useful?

<https://coff.ee/s4m1nd>
