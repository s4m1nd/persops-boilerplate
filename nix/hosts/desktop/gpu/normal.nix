# hosts/desktop/gpu/normal.nix

{ config, lib, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    powerManagement.enable = true;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true;
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
      allowExternalGpu = true;
    };
  };

  boot.blacklistedKernelModules = [ "nouveau" ];

  hardware.graphics = {
    enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  environment.systemPackages = with pkgs; [
    virt-manager
    qemu
    OVMF
    pciutils
    libvirt
    looking-glass-client
    spice-gtk
    win-virtio
    swtpm
  ];

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    cgroup_device_acl = [
      "/dev/null", "/dev/full", "/dev/zero",
      "/dev/random", "/dev/urandom",
      "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
      "/dev/rtc","/dev/hpet"
    ]
    namespaces = []
  '';

  environment.variables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
}
