# home/quisiou/scripts.nix

{ config, pkgs, lib, ... }:


let
    rocketLeagueReplay = pkgs.writeShellScriptBin "rl-replay" ''
        mkdir -p ${config.home.homeDirectory}/Videos/RocketLeague

        gpu-screen-recorder \
            -w eDP-1 \
            -a default_output -ac opus \
            -q very_high -k av1_10bit -cr limited -f 120 -fm cfr \
            -o ${config.home.homeDirectory}/Videos/RocketLeague/ -c mp4 -r 30 \
            &
        GSR_PID=$!

        "$@"

        kill -SIGINT "$GSR_PID"
        wait "$GSR_PID"
    '';
in
{
    home.packages = [
        rocketLeagueReplay
    ];

    home.activation.fetchRyujinxMetaFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/Ryujinx"
        COMPLETION_FILE="$TARGET_DIR/.download_completed"
        TAR_GZ_FILENAME="$TARGET_DIR/ryujinx-meta-files.tar.gz"
        CONFIG_KEYS_DIR="${config.home.homeDirectory}/.config/Ryujinx/system/"
        CONFIG_FIRMWARE_DIR="${config.home.homeDirectory}/.config/Ryujinx/bis/system/Contents/registered/"

        if [ ! -f "$COMPLETION_FILE" ]; then
            export PATH="${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"

            $DRY_RUN_CMD echo "Downloading Ryujinx meta files from Google Drive..."

            $DRY_RUN_CMD mkdir -p "$TARGET_DIR"
            
            $DRY_RUN_CMD ${pkgs.nix}/bin/nix-shell -p python3Packages.gdown \
                --run "gdown 'https://drive.google.com/uc?id=1HrM-AxlxAxpNY32RcGXGboQLJzQOLXMT' -O '$TARGET_DIR/'" \
                && tar -xzf "$TAR_GZ_FILENAME" -C "$TARGET_DIR" \
                && rm "$TAR_GZ_FILENAME" \
                && touch "$COMPLETION_FILE"
        fi

        if [ -f "$COMPLETION_FILE" ]; then
            $DRY_RUN_CMD echo "Linking keys..."
            mkdir -p "$CONFIG_KEYS_DIR"
            $DRY_RUN_CMD ln -sf \
                "$TARGET_DIR"/keys_dir/* \
                "$CONFIG_KEYS_DIR"

            $DRY_RUN_CMD echo "Linking firmware..."
            mkdir -p "$CONFIG_FIRMWARE_DIR"
            $DRY_RUN_CMD ln -sf \
                "$TARGET_DIR"/firmware_dir/* \
                "$CONFIG_FIRMWARE_DIR"
        fi
    '';
    home.activation.fetchPCSX2MetaFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/PCSX2"
        BIOS_DIR="$TARGET_DIR/bios_dir"
        COMPLETION_FILE="$TARGET_DIR/.download_completed"
        TAR_GZ_FILENAME="$TARGET_DIR/pcsx2-meta-files.tar.gz"
        CONFIG_BIOS_DIR="${config.home.homeDirectory}/.config/PCSX2/bios/"

        if [ ! -f "$COMPLETION_FILE" ]; then
            export PATH="${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"

            $DRY_RUN_CMD echo "Downloading PCSX2 meta files from Google Drive..."

            $DRY_RUN_CMD mkdir -p "$TARGET_DIR"
            
            $DRY_RUN_CMD ${pkgs.nix}/bin/nix-shell -p python3Packages.gdown \
                --run "gdown 'https://drive.google.com/uc?id=1th7MY7cNvm2pxHwY2q1hFcbLLOI878xN' -O '$TARGET_DIR/'" \
                && mkdir -p "$BIOS_DIR" \
                && tar -xzf "$TAR_GZ_FILENAME" -C "$BIOS_DIR" \
                && rm "$TAR_GZ_FILENAME" \
                && touch "$COMPLETION_FILE"
        fi

        if [ -f "$COMPLETION_FILE" ]; then
            $DRY_RUN_CMD echo "Linking bios files..."
            mkdir -p "$CONFIG_BIOS_DIR"
            $DRY_RUN_CMD ln -sf \
                "$BIOS_DIR"/* \
                "$CONFIG_BIOS_DIR"
        fi
    '';
}
