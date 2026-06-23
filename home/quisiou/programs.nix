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
