{ pkgs, ... }: {
    environment.systemPackages = (with pkgs; [

        # Klassy KDE Theme
        (pkgs.callPackage ./kde-klassy.nix {})

        kphotoalbum
        materia-kde-theme

    ]) ++ (with pkgs.kdePackages; [

        full
        qt6ct
        accounts-qt
        ark
        baloo
        baloo-widgets
        bluedevil
        dolphin
        dolphin-plugins
        ffmpegthumbs
        frameworkintegration
        itinerary
        kajongg
        kate
        karchive
        kbreakout
        kcalc
        kcmutils
        kcolorchooser
        kcolorpicker
        kconfigwidgets
        kcoreaddons
        kde-cli-tools
        kdeconnect-kde
        kdecoration
        kdegraphics-thumbnailers
        kdenlive
        kdeplasma-addons
        kdesdk-thumbnailers
        kglobalaccel
        kglobalacceld
        kguiaddons
        kiconthemes
        kio
        kio-admin
        kio-extras
        kio-extras-kf5
        kio-fuse
        kio-gdrive
        kio-zeroconf
        kitinerary
        ksshaskpass
        ksvg
        ktorrent
        kwallet
        kwallet-pam
        kwayland
        kwindowsystem
        layer-shell-qt
        modemmanager-qt
        networkmanager-qt
        okular
        partitionmanager
        plasma-browser-integration
        plasma-desktop
        plasma-disks
        plasma-integration
        plasma-wayland-protocols
        plasma-workspace
        qtsvg
        qttools
        taglib
        wayland
        wayland-protocols
        wayqt
        wrapQtAppsHook
        xdg-desktop-portal-kde

        akonadi
        akonadi-calendar
        akonadi-calendar-tools
        akonadi-contacts
        akonadi-import-wizard
        akonadi-mime
        akonadi-search
        calendarsupport
        kdepim-addons
        kdepim-runtime
        kontact
        kmail
        kmail-account-wizard
        kmailtransport
        libkdepim
        pim-data-exporter
        pim-sieve-editor
        pimcommon

        breeze
        breeze-icons
        qtstyleplugin-kvantum
        sierra-breeze-enhanced

    ]);
}
