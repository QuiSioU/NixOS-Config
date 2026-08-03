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
}
