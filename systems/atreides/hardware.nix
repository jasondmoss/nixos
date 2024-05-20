{ config, lib, pkgs, modulesPath, ... }:
{
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
        # kernelPackages = pkgs.linuxPackages_latest;
        kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_8.override {
            argsOverride = rec {
                src = pkgs.fetchurl {
                    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
                    sha256 = "0xjirg2w5fc2w2q6wr702akszq32m31lk4q5nbjq10zqhbcr5fxh";
                };
                version = "6.8.10";
                modDirVersion = "6.8.10";
            };
        });

        kernelModules = [ "kvm-amd" ];

        kernelParams = [
            "amd_iommu=on"
            "mem_sleep_default=deep"
            "nvidia-drm.modeset=1"
        ];

        initrd = {
            availableKernelModules = [
                "nvme"
                "xhci_pci"
                "ahci"
                "usbhid"
                "usb_storage"
                "sd_mod"
            ];

            kernelModules = [];
        };

        blacklistedKernelModules = [ "nouveau" ];

        extraModulePackages = [];

        kernel.sysctl = {
            "fs.inotify.max_user_watches" = 2140000000;
        };

        loader = {
            systemd-boot.enable = true;
            grub.enable = false;

            efi = {
                efiSysMountPoint = "/boot/efi";
                canTouchEfiVariables = true;
            };
        };

        swraid.enable = false;
    };

    fileSystems."/" = {
        device = "/dev/disk/by-uuid/f3e63afc-6602-4f46-845d-bd6d5bc6afe3";
        fsType = "ext4";
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-uuid/4d656a69-dc46-46b6-bec3-934e12415711";
        fsType = "btrfs";
        options = [ "compress=lzo" ];
    };

    fileSystems."/home/me/Games" = {
        device = "/dev/disk/by-uuid/2cf8ca9d-43ab-4ef5-99ff-0a909e765c5e";
        fsType = "btrfs";
        options = [ "compress=lzo" ];
    };

    fileSystems."/home/me/Mega" = {
        device = "/dev/disk/by-uuid/ccee2c99-427f-40f1-ad72-af6c81be4379";
        fsType = "ext4";
    };

    fileSystems."/home/me/Music" = {
        device = "/dev/disk/by-uuid/bf9410ed-bf55-4341-97f5-5576f80ce071";
        fsType = "ext4";
    };

    fileSystems."/home/me/Videos/Movies" = {
        device = "/dev/disk/by-uuid/52dfd9d6-7557-45fd-83c6-a6bfff2c0c83";
        fsType = "ext4";
    };

    fileSystems."/home/me/Videos/Television" = {
        device = "/dev/disk/by-uuid/629bf422-618b-44e0-8c92-736d0b9db85d";
        fsType = "ext4";
    };

    fileSystems."/boot/efi" = {
        device = "/dev/disk/by-uuid/3430-092D";
        fsType = "vfat";
    };

    swapDevices = [];

    networking = {
        useDHCP = lib.mkDefault true;

        firewall = {
            enable = true;
            allowedTCPPorts = [];
            allowedUDPPorts = [];
        };
    };

    hardware = {
        cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

        opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;

            extraPackages = with pkgs; [
                vaapiVdpau
                libvdpau-va-gl
                nvidia-vaapi-driver
            ];
        };

        nvidia = {
            forceFullCompositionPipeline = true;
            modesetting.enable = true;
            nvidiaPersistenced = true;
            nvidiaSettings = true;
            open = false;
            powerManagement.enable = false;
            powerManagement.finegrained = false;

            package = config.boot.kernelPackages.nvidiaPackages.beta;
            # package = config.boot.kernelPackages.nvidiaPackages.latest;
            # package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
        };

        pulseaudio.enable = false;
    };

    services = {
        xserver = {
           screenSection = ''
Option "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
Option "AllowIndirectGLXProtocol" "off"
Option "TripleBuffer" "on"
           '';
        };
    };

    virtualisation.docker = {
        enable = true;
        enableOnBoot = true;
        enableNvidia = true;
    };

    powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

    environment.sessionVariables = {
        XDG_MENU_PREFIX = "kde-";

        XCURSOR_THEME = "ComixCursors";
        DEFAULT_BROWSER = "/run/current-system/sw/bin/firefox-nightly";

        QT_QPA_PLATFORMTHEME = "qt6ct";

        # # NVIDIA
        # GBM_BACKEND = "nvidia-drm";
        # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        # LIBVA_DRIVER_NAME = "nvidia";
        # __GL_GSYNC_ALLOWED = "1";

        # WLR_DRM_NO_ATOMIC = "1";
        # WLR_NO_HARDWARE_CURSORS = "1";

        # # JetBrains
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # SDL_VIDEODRIVER = "wayland";

        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";

        GST_PLUGIN_SYSTEM_PATH_1_0=lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
            pkgs.gst_all_1.gst-editing-services
            pkgs.gst_all_1.gst-libav
            pkgs.gst_all_1.gst-plugins-bad
            pkgs.gst_all_1.gst-plugins-base
            pkgs.gst_all_1.gst-plugins-good
            pkgs.gst_all_1.gst-plugins-ugly
            pkgs.gst_all_1.gstreamer
        ];
    };

}
