################################################################################
##                              ·: ATREIDES :·                                ##
################################################################################

{ config, lib, pkgs, ... }: {
    nix.settings.system-features = [
        "benchmark"
        "big-parallel"
        "kvm"
        "nixos-test"
        "gccarch-znver2"
    ];

    boot = {
        consoleLogLevel = 0;

        loader = {
            grub.enable = false;
            timeout = 0;
            #verbose = false;

            systemd-boot = {
                enable = true;
                memtest86.enable = true;
                consoleMode = "auto";
            };

            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
        };

        plymouth = {
            enable = true;
            theme = "breeze";

            #themePackages = with pkgs; [
            #    (adi1090x-plymouth-themes.override {
            #        selected_themes = [ "rings" ];
            #    })
            #];
        };

        kernelModules = [
            "kvm-amd"
        ];

        initrd = {
            systemd.enable = true;

            kernelModules = [
                "i2c-nvidia_gpu"
                "nvidia"
                "nvidia_drm"
                "nvidia_modeset"
                "nvidia_uvm"
            ];

            availableKernelModules = [
                "ahci"
                "nvme"
                "sd_mod"
                "usb_storage"
                "usbhid"
                "xhci_pci"
            ];
        };

        kernelParams = [
            "amd_iommu=on"
            "amd_pstate=active"
            "boot.shell_on_fail"
            "loglevel=3"
            "mem_sleep_default=deep"
            "nvidia-drm.fbdev=1"
            "nvidia-drm.modeset=1"
            "quiet"
            "rd.systemd.show_status=false"
            "rd.udev.log_level=3"
            "splash"
            "udev.log_priority=3"
        ];

        extraModprobeConfig = "options nvidia " + lib.concatStringsSep " " [
            "NVreg_EnablePCIeGen3=1"
            "NVreg_PreserveVideoMemoryAllocations=1"
            "NVreg_RegistryDwords=RMUseSwI2c=0x01;RMI2cSpeed=100"
            "NVreg_UsePageAttributeTable=1"
        ];

        blacklistedKernelModules = [ "nouveau" ];

        #extraModulePackages = [];

        kernelPackages = pkgs.linuxPackages_xanmod_latest;

        kernel.sysctl = {
            "fs.inotify.max_user_watches" = 2140000000;
        };

        swraid.enable = false;
    };

    hardware = {
        cpu.amd = {
            ryzen-smu.enable = true;

            sev = {
                enable = true;
                mode = "0660";
                group = "sev";
                user = "root";
            };

            updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        };

        nvidia = {
            package = config.boot.kernelPackages.nvidiaPackages.beta;

            # New feature branch.
            #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            #    version = "560.35.03";
            #    sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
            #    openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
            #    settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
            #    persistencedSha256 = "sha256-E2J2wYYyRu7Kc3MMZz/8ZIemcZg68rkzvqEwFAL3fFs=";
            #};
        };
    };

    virtualisation = {
        virtualbox.host.enable = true;
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

    services = {
        power-profiles-daemon.enable = false;
        xserver.dpi = 162;

        tlp = {
            enable = true;
            settings = {
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
                CPU_MIN_PERF_ON_AC = 0;
                CPU_MAX_PERF_ON_AC = 100;
            };
        };

        printing = {
            browsing = false;
            cups-pdf.enable = true;
            startWhenNeeded = true;
        };
    };

    programs = {
        steam = {
            enable = true;
            remotePlay.openFirewall = true;
            dedicatedServer.openFirewall = true;
        };
    };

    system.stateVersion = "24.05";
    time.timeZone = "America/Toronto";
    networking.hostName = "atreides";

    nixpkgs = {
        hostPlatform = {
            gcc.arch = "znver2";
            gcc.tune = "znver2";
            system = "x86_64-linux";
        };
        #hostPlatform = lib.mkDefault "x86_64-linux";

        config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
            "steam"
            "steam-run"
            "steam-original"
        ];
    };

    environment.systemPackages = (with pkgs; [
        audacity
        audible-cli
        cuetools
        easytag
        #flacon
        haruna
        kdePackages.phonon-vlc
        mkvtoolnix
        taglib-sharp
        taglib_extras
        tor-browser-bundle-bin
        vlc
    ]);


    #
    # Shared configurations.
    #
    imports = [
        ../shared/hardware.nix
        ../shared/configuration.nix
        ../shared/packages.nix
        ../packages/desktop-entries/mkvtoolnix.nix
    ];
}

# <> #