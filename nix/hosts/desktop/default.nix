# hosts/desktop/default.nix

{ config, pkgs, lib, inputs, ... }:

let
  gpuConfig =
    if builtins.pathExists /etc/nixos/gpu-passthrough-enabled
    then ./gpu/passthrough.nix
    else ./gpu/normal.nix;
in
{
  imports = [
    ../common
    ./hardware.nix # /etc/nixos/hardware-configuration.nix
    gpuConfig
  ];

  system.stateVersion = "25.05";

  programs.fish.enable = true;
  programs.dconf.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.ghostty.packages."${pkgs.system}".ghostty
    _1password-gui
    os-prober
    usbutils
    xclip
    wl-clipboard
    unzip
    xorg.xmodmap
    pciutils
    numactl
    nvme-cli
    fontconfig
    imv
    p7zip
    xarchiver
    zip
    networkmanagerapplet
    vlc
    pkg-config
    dmidecode
    dnsmasq
    pavucontrol
    file
    dig
    traceroute
    gnome-tweaks
    adwaita-icon-theme
    papirus-icon-theme
    gnomeExtensions.pop-shell
    virt-manager
    qemu
    OVMF
    vmfs-tools
    docker-compose
    kubectx
    kubectl
    kubernetes-helm
    colima
    vagrant
    postman
    cmake
    binutils
    gcc
    gnumake
    viu
    nemo
    deno
    python3
    bun
    ghidra-bin
    wireshark
    tshark
    tcpdump
    nasm
    dhcpdump
    discord
    slack
    code-cursor
    delta
    sad
    (pkgs.writeShellScriptBin "clipboard-provider" ''
      #!${pkgs.bash}/bin/bash
      if [ -n "$WAYLAND_DISPLAY" ]; then
        if [ "$1" = "copy" ]; then
          ${pkgs.wl-clipboard}/bin/wl-copy
        else
          ${pkgs.wl-clipboard}/bin/wl-paste
        fi
      else
        if [ "$1" = "copy" ]; then
          ${pkgs.xclip}/bin/xclip -in -selection clipboard
        else
          ${pkgs.xclip}/bin/xclip -out -selection clipboard
        fi
      fi
    '')
  ];

  users.extraGroups.docker.members = [ "s4m1nd" ];

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.daemon.settings = {
    data-root = "/home/path/to/docker-data/";
  };

  virtualisation.libvirtd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  services.flatpak.enable = true;

  services.autorandr.enable = true;

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 5;
      gfxmodeEfi = "1920x1080";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  hardware.nvidia.modesetting.enable = true;

  hardware.graphics = {
    enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  environment.shellAliases = {
    pbcopy = "clipboard-provider copy";
    pbpaste = "clipboard-provider paste";
  };

  time.timeZone = "Europe/Bucharest";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  users.users.s4m1nd = {
    isNormalUser = true;
    description = "s4m1nd";
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" "kvm" "usb" "disk" "docker" "graphics" ];
    shell = pkgs.fish;
  };
}
