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

    home.activation.setupRyujinx = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        APP_FILES_DIR="${config.home.homeDirectory}/AppFiles"
        TARGET_DIR="$APP_FILES_DIR/Ryujinx"
        COMPLETION_FILE="$TARGET_DIR/.download_completed"
        TAR_GZ_FILENAME="$TARGET_DIR/ryujinx-meta-files.tar.gz"
        CONFIG_KEYS_DIR="${config.home.homeDirectory}/.config/Ryujinx/system/"
        CONFIG_FIRMWARE_DIR="${config.home.homeDirectory}/.config/Ryujinx/bis/system/Contents/registered/"
        GAMES_DIR="$TARGET_DIR/games_dir"
        MODS_DIR="$TARGET_DIR/mods_dir"
        CONFIG_FILE="${config.home.homeDirectory}/.config/Ryujinx/Config.json"

        if [ ! -f "$COMPLETION_FILE" ]; then
            export PATH="${pkgs.gnutar}/bin:${pkgs.gzip}/bin:$PATH"

            $DRY_RUN_CMD echo "Downloading Ryujinx meta files from Google Drive..."

            $DRY_RUN_CMD mkdir -p "$TARGET_DIR"
            
            $DRY_RUN_CMD ${pkgs.nix}/bin/nix-shell -p python3Packages.gdown \
                --run "gdown 'https://drive.google.com/uc?id=1UuEqxq0jaH8oW2SyNILbWh6LHyKRh645' -O '$TARGET_DIR/'" \
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

            $DRY_RUN_CMD echo "Creating games directory..."
            mkdir -p "$GAMES_DIR"
            if [ -f "$CONFIG_FILE" ]; then
                $DRY_RUN_CMD echo "Updating game_dirs in Ryujinx Config.json..."
                TMP_FILE=$(mktemp)
                ${pkgs.jq}/bin/jq --arg dir "$GAMES_DIR" '.game_dirs = [$dir]' "$CONFIG_FILE" > "$TMP_FILE" \
                    && mv "$TMP_FILE" "$CONFIG_FILE"
            fi

            $DRY_RUN_CMD echo "Creating mods directory..."
            mkdir -p "$MODS_DIR"
            ln -sf "$MODS_DIR" "${config.home.homeDirectory}/.config/Ryujinx/mods/contents"
        fi
    '';
    home.activation.setupPCSX2 = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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
