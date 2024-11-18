{ config, lib, pkgs, ... }: {

    boot = {
        kernelPackages = pkgs.linuxPackages_xanmod_latest;

        kernelParams = [
            "mem_sleep_default=deep"
            "nvidia_drm.modeset=1"
            "nvidia_drm.fbdev=1"
        ];

        initrd = {
            availableKernelModules = [
                "nvidia"
                "nvidia_modeset"
                "nvidia_uvm"
                "nvidia_drm"
                "vmd"
                "xhci_pci"
                "ahci"
                "nvme"
                "usbhid"
                "usb_storage"
                "sd_mod"
            ];

            kernelModules = [
                "dm-snapshot"
                "kvm-intel"
            ];

            luks.devices = {
                crypted = {
                    device = "/dev/disk/by-uuid/5e02c30a-d26f-41fb-ba83-b9f2e3b39b5e";
                    preLVM = true;
                };
            };
        };

        extraModprobeConfig = "options nvidia " + lib.concatStringsSep " " [
            "NVreg_UsePageAttributeTable=1"
            "NVreg_EnablePCIeGen3=1"
            "NVreg_PreserveVideoMemoryAllocations=1"
            "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
        ];

        blacklistedKernelModules = [
            "nouveau"
        ];

        extraModulePackages = [];

        kernel.sysctl = {
            "fs.inotify.max_user_watches" = 2140000000;
        };

        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        swraid.enable = false;
    };

    hardware = {
        cpu.intel = {
            updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        };

        nvidia = {
            # For now, only this driver works with kernel 6.11+
            #package = config.boot.kernelPackages.nvidiaPackages.stable;
            package = config.boot.kernelPackages.nvidiaPackages.beta;

            prime = {
                offload = {
                    enable = false;
                    enableOffloadCmd = false;
                };

                sync.enable = true;
                nvidiaBusId = "PCI:1:0:0";
                intelBusId = "PCI:0:2:0";
                #nvidiaBusId = "PCI:0:2:0";
                #intelBusId = "PCI:1:0:0";
            };
        };
    };

    virtualisation = {
        virtualbox.host.enable = true;
    };

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/5e7a3096-5275-4bb2-973d-b00b032438a6";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C775-BC84";
        fsType = "vfat";
    };

    swapDevices = [
        {
            device = "/dev/disk/by-uuid/8a9e0e21-ada8-4830-9836-3f9d678ac477";
        }
    ];

}
