# home/quisiou/programs.nix

{ config, pkgs, lib, ... }:

let
    mkFirefoxAddon = { name, addonId, url, hash }:
    pkgs.stdenv.mkDerivation {
        inherit name;
        src = pkgs.fetchurl { inherit url hash; };
        dontUnpack = true;
        installPhase = ''
            mkdir -p $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}
            cp $src $out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${addonId}.xpi
        '';
        passthru = { inherit addonId; };
        meta.description = name;
    };
in
{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
            nrs = "sudo nixos-rebuild switch    --flake /etc/nixos#chirimbolo";
            nrb = "sudo nixos-rebuild dry-build --flake /etc/nixos#chirimbolo";
        };
        history = {
            size = 10000;
            save = 10000;
            ignoreDups = true;
            findNoDups = true;
            extended = true;
            share = true; # Share history between sessions
            # append = true;
        };
        profileExtra = ''
            # Start Hyprland Automatically on TTY1 only, so if something breaks,
            # you're still able to log in without hyprland on another TTY
            if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
                exec start-hyprland
            fi
        '';
        envExtra = ''
            # LESS command formatting
            export GROFF_NO_SGR=1
            export LESS_TERMCAP_mb=$'\e[5;38;2;190;149;255m'                # blink start (text that flashes)
            export LESS_TERMCAP_md=$'\e[1;38;2;120;169;255m'                # bold start (section headers, command names...)
            export LESS_TERMCAP_me=$'\e[0m'                                 # bold/blink end (reset after bold or blink)
            export LESS_TERMCAP_mh=$'\e[2;38;2;82;82;82m'                   # dim start (faded/less important text)
            export LESS_TERMCAP_mr=$'\e[38;2;22;22;22;48;2;190;149;255m'    # reverse video start (swaps fg/bg colors)
            export LESS_TERMCAP_so=$'\e[38;2;221;225;231;48;2;38;38;38m'    # standout start (status bar, search matches)
            export LESS_TERMCAP_se=$'\e[0m'                                 # standout end (reset after standout)
            export LESS_TERMCAP_us=$'\e[4;1;38;2;186;230;255m'              # underline start (option flags, emphasized text)
            export LESS_TERMCAP_ue=$'\e[0m'                                 # underline end (reset after underline)
            export LESS_TERMCAP_ZN=$'\e[74m'                                # subscript start
            export LESS_TERMCAP_ZV=$'\e[75m'                                # subscript end
            export LESS_TERMCAP_ZO=$'\e[73m'                                # superscript start
            export LESS_TERMCAP_ZW=$'\e[75m'                                # superscript end

            # Source personal environment variables
            [ -f "$HOME/.config/zsh/user/env.zsh" ] && . "$HOME/.config/zsh/user/env.zsh"
        '';
        initContent = ''
            #!/usr/bin/env zsh
            # zsh/zshrc.zsh


            # Save and set last visited directory when closing terminal
            trap "pwd > $HOME/.last_dir" EXIT
            if [ -f "$HOME/.last_dir" ]; then
                export OLDPWD="$(cat $HOME/.last_dir)"
            fi

            # System's command completions must be enabled by user manually.
            # If you use a declarative configuration (like NixOS), do it there.
            # Otherwise, you can create this file and place the commands in it.
            [ -f "$HOME/.config/zsh/user/enable_completions.zsh" ] && . "$HOME/.config/zsh/user/enable_completions.zsh"

            # Source custom zsh files
            load_scripts() {
                if [ -d "$1" ]; then
                    for script in "$1"/*.zsh; do
                        [ -e "$script" ] || continue
                        [ "$script" = "$HOME/.config/zsh/user/env.zsh" ] && continue
                        [ -r "$script" ] && . "$script" # Source every readable file inside the directory
                    done
                fi
            }
            CONFIG_DIR="$HOME/.config/zsh"
            load_scripts "$CONFIG_DIR/default"  # Load Main Scripts (Git Tracked)
            load_scripts "$CONFIG_DIR/user"	    # Load User Scripts (Git Untracked). May be used to override
            unset -f load_scripts

            # Init starship
            if command -v starship >/dev/null 2>&1; then
                eval "$(starship init zsh)"
            fi

        '';
    };
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "QuiSioU";
                email = "marco.casteleiro@gmail.com";
            };
        };
    };
    programs.vesktop = {
        enable = true;
        vencord.settings = {
            autoUpdate = true;
            autoUpdateNotification = true;
            notifyAboutUpdates = true;
        };
    };
    programs.firefox = {
        enable = true;
        profiles."quisiou" = {
            settings."extensions.autoDisableScopes" = 0;
            extensions.packages = [
                (mkFirefoxAddon {
                    name = "vimium";
                    addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
                    url = "https://addons.mozilla.org/firefox/downloads/file/4717567/vimium_ff-2.4.2.xpi";
                    hash = "sha256-Ex4qZ1gOeukSWrGXgRWeYUCfrEe0Qfwngqq3Y5bq0ZY=";
                })
            ];
            bookmarks = {
                force = true;
                settings = [{
                    toolbar = true;
                    bookmarks = [
                        {
                            name = "NixOS";
                            bookmarks = [
                                {
                                    name = "Search";
                                    url = "https://search.nixos.org";
                                }
                                {
                                    name = "Home Manager";
                                    tags = [ "home" "manager" ];
                                    url = "https://nix-community.github.io/home-manager/options/home-manager/";
                                }
                            ];
                        }
                        "separator"
                        {
                            name = "GitHub";
                            url = "https://github.com";
                        }
                    ];
                }];
            };
        };
    };
    programs.vscodium = {
        enable = true;

        profiles.default.extensions =
        (with pkgs.vscode-extensions; [
            llvm-vs-code-extensions.vscode-clangd
            twxs.cmake
            ms-toolsai.jupyter
            ms-toolsai.jupyter-renderers
            ms-toolsai.vscode-jupyter-cell-tags
            ms-toolsai.vscode-jupyter-slideshow
            ms-toolsai.jupyter-keymap
            james-yu.latex-workshop
            sumneko.lua
            jnoortheen.nix-ide
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy
            ms-python.vscode-python-envs
            mechatroner.rainbow-csv
            tombi-toml.tombi
        ])
        ++
        (with pkgs.vscode-marketplace; [
            theqtcompany.qt-core
            theqtcompany.qt-qml
            eww-yuck.yuck
        ]);
    };
}
