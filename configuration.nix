# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
imports =
    [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];


    # --- Boot -----------------------------------------------------------
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelParams = [
	"nvidia_drm.modeset=1"
    	"nvidia.NVreg_PreserveVideoMemoryAllocations=1"
	"loglevel=3"
    ];
    boot.kernel.sysctl = {
	"kernel.printk" = "3 4 1 3";
    };


    # --- NVIDIA (hybrid offload) ----------------------------------------
    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;          # needed for suspend/resume
        powerManagement.finegrained = false;    # set true if you want PRIME offload on-demand
        open = true;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;

        prime = {
            offload = {
                enable = true;              # GPU on-demand (saves battery)
                enableOffloadCmd = true;    # adds `nvidia-offload` helper
            };

            amdgpuBusId    = "PCI:101:0:0"; # 65:00.0 → 0x65 = 101 decimal
            nvidiaBusId    = "PCI:1:0:0";   # 01:00.0 → already decimal
        };
    };

    # amdgpu needs hardware.opengl (renamed to graphics in 24.05+)
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
            rocmPackages.clr.icd
        ];
    };

    services.xserver.videoDrivers = [ "nvidia" ];   # loads both amdgpu + nvidia

    # --- Networking -----------------------------------------------------
    networking.hostName = "chirimbolo";
    networking.wireless.iwd.enable = true;
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";

    # --- Locale/timezone ------------------------------------------------
    console.keyMap = "es";

    time.timeZone = "Europe/Madrid";
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "es_ES.UTF-8";
        LC_IDENTIFICATION = "es_ES.UTF-8";
        LC_MEASUREMENT = "es_ES.UTF-8";
        LC_MONETARY = "es_ES.UTF-8";
        LC_NAME = "es_ES.UTF-8";
        LC_NUMERIC = "es_ES.UTF-8";
        LC_PAPER = "es_ES.UTF-8";
        LC_TELEPHONE = "es_ES.UTF-8";
        LC_TIME = "es_ES.UTF-8";
    };


    # --- Audio ----------------------------------------------------------
    hardware.alsa.enablePersistence = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };
    security.rtkit.enable = true;


    # --- Bluetooth ------------------------------------------------------
    hardware.bluetooth.enable = true;


    # --- Services -------------------------------------------------------
    services.blueman.enable = true;
    services.avahi.enable = true;
    services.printing.enable = true;     # CUPS


    # --- User -----------------------------------------------------------
    users.users."quisiou" = {
        isNormalUser = true;
        description = "quisiou";
        extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
        shell = pkgs.bash;
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    # --- Programs -------------------------------------------------------
    programs.hyprland = {           		# Default window manager
        enable = true;
        xwayland.enable = true;
    };
    programs.neovim.enable = true;      	# Texterminal text editor
    programs.bash.completion.enable = true;	# Self-explanatory, innit?
    programs.firefox.enable = true;     	# Web browser
    programs.steam = {                  	# Gaming platform
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true; 	# better gaming performance
    };
    programs.git = {
	enable = true;
	config = {
	    user = {
		name = "QuiSioU";
		email = "marco.casteleiro@gmail.com";
	    };
	};
    };


    # --- System Fonts ---------------------------------------------------
    fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	nerd-fonts.fira-code
    ];


    # --- System packages ------------------------------------------------
    # To expose a single binary from a package without installing the whole thing,
    # use runCommand (for one binary) or linkFarm (for multiple):

    # (pkgs.runCommand "name" { } ''
    #     mkdir -p $out/bin
    #     ln -s ${pkgs.some-package}/bin/binary $out/bin/binary
    # '')

    # (pkgs.linkFarm "name" [
    #     { name = "bin/binary"; path = "${pkgs.some-package}/bin/binary"; }
    # ])

    environment.systemPackages = with pkgs; [
        # Basic utilities
        bash
	wget curl bat

	(python3.withPackages (ps: with ps; [
	    jinja2
	]))

	ffmpeg _7zz-rar jq poppler fd ripgrep fzf zoxide resvg imagemagick

        # Text editors
        vscodium

        # Terminal (and tools)
        kitty starship fastfetch

	# Terminal text editor
	(yazi.override {
	    _7zz = _7zz-rar;  # Support for RAR extraction
	})

        # System monitors
        btop brightnessctl

        # Hyprland ecosystem
        hyprshot wl-clipboard cliphist

	# Language servers
	clang-tools
	(runCommand "qmlls" { } ''
	    mkdir -p $out/bin
	    ln -s ${qt6.qtdeclarative}/bin/qmlls $out/bin/qmlls
	'')

        # Desktop GUI
        awww eww quickshell

	# Other stuff
	gpu-screen-recorder
	mpv
	imv
    ];


    # --- Scripts --------------------------------------------------------
    # Clone dotfiles
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

    # Setup dotfiles
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

    # --- Security -------------------------------------------------------
    security.polkit.enable = true;

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "26.05"; # Did you read the comment?

}
