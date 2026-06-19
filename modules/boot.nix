# modules/boot.nix

{ config, pkgs, lib, ... }:

{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelParams = [
        "nvidia_drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
        "loglevel=3"
    ];
    boot.kernel.sysctl = {
        "kernel.printk" = "3 4 1 3";
    };
}
