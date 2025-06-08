# nixos and friends

Setup instructions, notes, recommendations, and requirements

## before you start

- make sure you replaced my username from config
- make sure you replaced all `/path/to` occurrences
- desktop requires `/etc/nixos/hardware-configuration.nix` to be copied to `/path/to/persops/nix/hosts/desktop/hardware.nix`

### Replace my username (s4m1nd) from all files

#### If you're on Linux

```bash
find . -type f -exec sed -i 's/s4m1nd/YOURUSERNAME/g' {} +
```

#### If you're on macOS

```bash
find . -type f -exec sed -i '' 's/s4m1nd/YOURUSERNAME/g' {} +
```

#### Replace all occurrences of `/path/to` because I don't know where you'd like to place your config

If you have a clever way to do it automatically or via a startup script feel free to open a PR.

```bash
grep -rn "/path/to/" .
```

## macOS

### how to rebuild on macOS

```bash
nix build .#darwinConfigurations.mac.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mac
```

## NixOS

### before you start

```bash
sudo ln -s $(which bash) /bin/bash
```

For NixOS you should copy your system `/etc/nixos/hardware-configuration.nix` locally. Required at rebuild iirc.

```bash
cp /etc/nixos/hardware-configuration.nix /path/to/persops/nix-experimental/hosts/desktop/hardware.nix
```

### how to rebuild on NixOS

```bash
sudo nixos-rebuild switch --flake .#desktop
```

## notes / recommendations

- create your own github repo to keep your changes versioned
- remember to `git add .` when you see module not found errors

## in case you break your nix config on linux this is how to recover from it

### requirements

- live CD with whatever sane Linux distro

### boot and follow those steps

```bash
# lsblk to find the right disk

# Mount root partition
mount /dev/nvme0n1p2 /mnt

# Create and mount boot partition
mkdir -p /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

# Create the necessary directories for virtual filesystems
mkdir -p /mnt/dev
mkdir -p /mnt/proc
mkdir -p /mnt/sys

# Now mount the virtual filesystems
mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys

# Chroot into the system
nixos-enter

# Fix the config and rebuild

cd /home/s4m1nd/path/to/persops/nix

NIXOS_SWITCH_USE_DIRTY_ENV=1 nixos-rebuild boot --flake .#desktop --option sandbox false

# Reboot
```

## Found this template useful?

<https://coff.ee/s4m1nd>
