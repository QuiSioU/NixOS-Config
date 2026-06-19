# modules/services.nix

{ config, pkgs, lib, ... }:

{
    services.blueman.enable = true;
    services.avahi.enable = true;
    services.printing.enable = true;     # CUPS

    # User-defined services
    systemd.services.dotfiles-clone = {
    	description = "Clone dotfiles repository from github";
    	after = [ "network-online.target" ];
    	wants = [ "network-online.target" ];
    	wantedBy = [ "multi-user.target" ];
        restartIfChanged = true;
        unitConfig = {
            ConditionPathExists = "!/home/quisiou/Dotfiles";
        };
    	serviceConfig = {
    	    Type = "oneshot";
    	    User = "root";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
    	};
    	script = ''
            echo "Cloning dotfiles..."
            ${pkgs.sudo}/bin/sudo -u quisiou ${pkgs.git}/bin/git clone https://github.com/QuiSioU/Dotfiles.git /home/quisiou/Dotfiles
            ${pkgs.systemd}/bin/systemctl start dotfiles-setup
    	'';
    };

    systemd.services.dotfiles-setup = {
    	description = "Set up dotfiles";
    	serviceConfig = {
    	    Type = "oneshot";
    	    User = "quisiou";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
    	};
    	script = ''
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
    };
}
