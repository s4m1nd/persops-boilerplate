# hosts/desktop/gpu/passthrough.nix

{ config, lib, pkgs, ... }:

let
  gpuIDs = [
    "10de:1b80" # NVIDIA GeForce GTX 1080
    "10de:10f0" # NVIDIA GP104 High Definition Audio Controller
  ];
in
{
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
    "vfio-pci.ids=${builtins.concatStringsSep "," gpuIDs}"
    "default_hugepagesz=2M"
    "hugepagesz=2M"
    "hugepages=4096"
  ];

  boot.kernel.sysctl = {
    "vm.nr_hugepages" = 4096;
  };

  boot.kernelModules = [ "kvm-intel" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];

  services.xserver.videoDrivers = [ "modesetting" ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  services.udev.extraRules = ''
    SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
  '';

  users.users.s4m1nd = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "kvm" "input" "disk" "usb" ];
  };

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
