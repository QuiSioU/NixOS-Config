# modules/video.nix

{ config, pkgs, lib, ... }:

{
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;          # needed for suspend/resume
        powerManagement.finegrained = false;    # set true if you want PRIME offload on-demand
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = {
            offload = {
                enable = true;              # GPU on-demand (saves battery)
                enableOffloadCmd = true;    # adds `nvidia-offload` helper
            };

            amdgpuBusId    = "PCI:101:0:0"; # 65:00.0 → 0x65 = 101 decimal
            nvidiaBusId    = "PCI:1:0:0";   # 01:00.0 → already decimal
        };
    };

    # amdgpu needs hardware.opengl (renamed to graphics in 24.05+)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            rocmPackages.clr.icd
        ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];   # loads both amdgpu + nvidia
}
