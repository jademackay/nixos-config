# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/36aa7a12-cc3e-4565-8edd-17bf6c8d1029";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/9AE2-7907";
      fsType = "vfat";
    };

#  fileSystems."/home" =
  fileSystems."/mnt/home-hdd" =
    { device = "/dev/disk/by-uuid/c3fbfdf1-fd8b-404a-936a-31d07a5d3f14";
      fsType = "ext4";
    };

#  fileSystems."/mnt/home-ssd" =
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/614416f2-9a13-4617-b956-c4b36534c737";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/15cf75d6-dad6-48c3-8d8e-4ed4a0b28678"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}