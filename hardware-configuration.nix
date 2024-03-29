# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/af7960bc-65b4-45dc-bf2b-994f49784870";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/EC33-244C";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/d58ea7fa-2ca4-4602-b94b-b57d512137cd";
      fsType = "ext4";
    };

  fileSystems."/opt" =
    { device = "/dev/disk/by-uuid/e0854cc0-c6e5-40ec-81f7-6c83f4277972";
      fsType = "ext4";
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/14b074d3-9b4e-4175-9aa4-1356f10b84f8";
      fsType = "ext4";
    };

  fileSystems."/var" =
    { device = "/dev/disk/by-uuid/9e220281-f699-4060-bb0b-d4cc265ba7fc";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
