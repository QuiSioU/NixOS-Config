# home/quisiou/variables.nix


{ config, pkgs, lib, ... }:

{
    home.sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
        MOZ_ENABLE_WAYLAND = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        # Set these for xwayland apps, even though already defined in gtk3
        XCURSOR_SIZE = "24";
        XCURSOR_THEME = "Adwaita";

        # Possible optimizations
        # QT_QPA_PLATFORM = "wayland;xcb";
        # QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        # LIBVA_DRIVER_NAME = "radeonsi";
    };
}
