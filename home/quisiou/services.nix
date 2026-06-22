# home/quisiou/services.nix


{ config, pkgs, lib, ... }:

{
    systemd.user.services.dotfiles-clone = {
        Unit = {
            Description = "Clone dotfiles repository from github";
            ConditionPathExists = "!/home/quisiou/Dotfiles";
        };
        Service = {
            Type = "oneshot";
            ExecStart = "${pkgs.git}/bin/git clone https://github.com/QuiSioU/Dotfiles.git /home/quisiou/Dotfiles";
            ExecStartPost = "${pkgs.systemd}/bin/systemctl --user start dotfiles-setup.service";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
        };
        Install.WantedBy = [ "default.target" ];
    };

    systemd.user.services.dotfiles-setup = {
        Unit = {
            Description = "Set up dotfiles";
        };
        Service = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "dotfiles-setup" ''
                if [ ! -d "/home/quisiou/Dotfiles" ]; then
                    echo "Dotfiles directory not found, skipping..."
                    exit 0
                fi

                if [ ! -f "/home/quisiou/Dotfiles/setup.sh" ]; then
                    echo "Setup script not found, skipping..."
                    exit 0
                fi

                echo "Running dotfiles setup..."
                ${pkgs.nix}/bin/nix-shell -I nixpkgs=${pkgs.path} \
                    -p cmake glib pkg-config networkmanager alsa-lib ninja qt6.qtbase qt6.qtdeclarative spirv-tools \
                    --run "export PATH=\$PATH:/run/current-system/sw/bin && ${pkgs.bash}/bin/bash /home/quisiou/Dotfiles/setup.sh -f"
            '';
            StandardOutput = "journal+console";
            StandardError = "journal+console";
        };
    };
}
