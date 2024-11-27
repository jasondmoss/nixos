{ lib, pkgs, ... }: {

    # Setup.
    nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";

        config = {
            allowBroken = true;     # For 'php-packages'
            allowUnfree = true;

            packageOverrides = pkgs: {
                steam = pkgs.steam.override {
                    extraPkgs = pkgs: with pkgs; [
                        libgdiplus
                    ];
                };
            };

            allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
                "nvidia-x11"
                "nvidia-settings"
                "nvidia-persistenced"
                "nvidia-vaapi-driver"
                "vulkan-headers"
                "vulkan-loader"
                "vulkan-tool"
                "vulkan-validation-layers"
            ];

            permittedInsecurePackages = [
                "olm-3.2.16"
                "openssl-1.1.1w"
            ];
        };

        overlays = [
            #(final: prev: {
            #    # Update Ollama to the latest.
            #    ollama = prev.ollama.overrideAttrs (oldAttrs: {
            #        version = "0.4.3";
            #        src = final.fetchurl {
            #            url = "https://github.com/ollama/ollama/releases/download/v0.4.3/ollama-linux-amd64.tgz";
            #            hash = "sha256-rHIoVLiQE5uaLWcV+VGjqu+M/rxXuxr2Wc5O1pJ9AmA=";
            #        };
            #    });
            #})

            # JetBrains EAP overlays.
            (import ../overlays/jetbrains/default.nix)

            # Mozilla Firefox Nightly overlays.
            (import ../overlays/nixpkgs-mozilla/lib-overlay.nix)
            (import ../overlays/nixpkgs-mozilla/firefox-overlay.nix)
        ];
    };

    #-- Core Packages.
    environment.systemPackages = (with pkgs; [

        aha
        babl
        clinfo
        coreutils-full
        curl
        dwz
        expat
        expect
        flex
        fontconfig
        fwupd
        fwupd-efi
        gcr
        gd
        gsasl
        htop
        inetutils
        inotify-tools
        killall
        libxfs
        libxml2
        links2
        linuxquota
        lm_sensors
        lsd
        lshw
        nix-du
        nix-index
        nix-prefetch-git
        nvme-cli
        openssl
        openvpn
        optipng
        pciutils
        pcre2
        pmutils
        pngquant
        python312Full
        rar
        smartmontools
        tldr
        unar
        unixtools.script
        unrar
        unzip
        usbutils
        wget
        wirelesstools
        xclip
        xfsprogs
        zip

        #-- GRAPHICS
        egl-wayland
        eglexternalplatform
        glxinfo
        gpm
        imagemagick
        jpegoptim
        jq
        libGL
        libdrm
        libglvnd
        libva
        libva-utils
        libva1
        mesa
        nvidia-vaapi-driver
        nvtopPackages.full
        virtualgl
        vulkan-headers
        vulkan-loader
        vulkan-tools
        vulkan-validation-layers
        wayland-utils
        wmctrl
        xdg-desktop-portal
        xdg-utils
        xorg.libxcb

        #-- DESKTOP
        gtk4
        ly

        #-- DEVELOPMENT
        bison
        bisoncpp
        bun
        cargo
        cmake
        cockpit
        ddev
        desktop-file-utils
        diffutils
        docker
        docker-client
        docker-compose
        eww
        extra-cmake-modules
        gcc
        gdb
        git
        go
        jetbrains.gateway
        jetbrains.jdk
        jetbrains.writerside
        libunwind
        lua
        nodejs
        perl
        phpunit
        pre-commit
        rustc
        seer
        superhtml
        yarn

        #-- SECURITY
        certbot
        chkrootkit
        encfs
        lynis
        mkcert
        sniffnet

        #-- EDITORS
        figma-linux
        gcolor3
        inkscape
        libreoffice-qt6
        #libreoffice-qt6-fresh
        #libreoffice-qt6-fresh-unwrapped
        nomacs
        nano
        phpstorm    # Custom overlay.
        semantik
        sublime4

        #-- MULTIMEDIA
        faac
        ffmpeg-full
        ffmpegthumbnailer
        flac
        flacon
        isoimagewriter
        lame
        libcue
        mac
        mkcue
        mpg123
        mpv
        mpvScripts.thumbfast
        opusTools
        pavucontrol
        qmmp
        shntool
        sox
        speechd
        vorbis-tools
        wavpack

        #-- INTERNET
        brave
        filezilla
        megasync
        megatools
        microsoft-edge
        opera
        protonvpn-gui
        thunderbird-unwrapped
        zoom-us

        #-- THEMING
        comixcursors
        sweet-nova

        #-- MISCELLANEOUS / UTILITIES
        conky
        libportal
        ulauncher
        wezterm

        (google-chrome.override {
            commandLineArgs = [
                "--use-gl=desktop"
                "--enable-features=VaapiVideoDecodeLinuxGL"
                "--ignore-gpu-blocklist"
                "--enable-zero-copy"
            ];
        })

        (chromium.override {
            enableWideVine = true;

            commandLineArgs = [
                "--use-gl=desktop"
                "--enable-features=VaapiVideoDecodeLinuxGL"
                "--ignore-gpu-blocklist"
                "--enable-zero-copy"
            ];
        })


        #-- CUSTOM PACKAGES

        #-- Anytype
        (pkgs.callPackage ../packages/anytype {})

        # Strawberry Music Player
        (pkgs.callPackage ../packages/strawberry {})

        # Wavebox Beta
        (pkgs.callPackage ../packages/wavebox {})

    ]);

    imports = [
        ../packages/vaapi.nix
        ../packages/php83.nix
        #../packages/php84.nix
        ../packages/kdedesktop.nix
        ../packages/gimp.nix

        # Desktop Entries.
        ./desktop-entries/firefox-nightly.nix
        ./desktop-entries/firefox-stable.nix
        ./desktop-entries/thunderbird.nix
        #./desktop-entries/google-chrome-stable.nix
    ];

}
