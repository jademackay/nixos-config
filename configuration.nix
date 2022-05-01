# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  myemacs =  pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
    nix-mode
  ]));
  overlays = [
    # If you want to completely override the normal package
    # (prev: final: import ./pkgs { inherit pkgs; })
    # If you want to access your package as `local.emacs`
    #(prev: final: {
    # I changed to (doesn't make a difference here):
    (final: prev: {
      local = import ./pkgs { inherit pkgs; };
    })
    # `prev: final:` is my preference over `super: self:`; these are just
    # names, but I think mine are clearer about what they mean ;)
    
    # You can also use `my` instead of `local`, of course, but I dislike
    # that naming convention with a passion. At best, it should be
    # `our`.
  ];
in {
  # This will add our overlays to `pkgs`
  nixpkgs.overlays = overlays;
  
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "goldchain"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # NetworkManager
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  
  # Set your time zone.
  time.timeZone = "Pacific/Auckland";
  
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  #system.stateVersion = "20.03"; # Did you read the comment?
  # system.stateVersion = "21.05"; # Did you read the comment?
  system.stateVersion = "21.11"; # Did you read the comment?
  # system.autoUpgrade.enable = true;
  # system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;
  
  # Propriery software
  nixpkgs.config.allowUnfree = true; 
  
  nix = {
    #package = pkgs.nixUnstable;
    #package = pkgs.nixStable;
    package = pkgs.nixFlakes;
    extraOptions = ''
       experimental-features = nix-command flakes
       #autoOptimiseStore = true;  
       '';
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # or
  # nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # sys
    unzip
    zlib
    wget
    curl
    htop
    pciutils
    arandr
    zsh
    oh-my-zsh
    #lxqt.lxqt-sudo
    # rxvt_unicode-with-plugins
    local.rxvt-unicode
    gtk4
    bat
    gnome.gnome-system-monitor
    
    # email
    # protonmail-bridge
    # mutt
    # alpine
    
    # dev
    vim
    #emacs
    # (pkgs.emacs.pkgs.withPackages (epkgs: (with epkgs.melpaStablePackages; [
    #   nix-mode
    # ])))
    # myemacs
    local.emacs # Or just `emacs` if you used the first overlay

    ispell
    git
    tmux
    docker
    docker-compose
    #julia
    #    julia_12
    #julia_13
    terraform
    python39Packages.flake8
    gnome.meld

    go
    gnumake

    # aws
    awscli2
    ssm-session-manager-plugin
    aws-vault

    # desktop
    lxappearance
    i3-gaps
    rofi
    feh
    networkmanagerapplet
    xfce.thunar
    blueman
    firefox
    chromium
    ispell
    volumeicon
    tree
    killall
    xorg.xkill
    ranger
    direnv
    libreoffice
    spotify
    
    #
    restic

    # apps
    zathura
    pgf3
    tikzit
    poppler_utils
    gpicview
    #
    bat
    diff-so-fancy
    fzf # fuzzy search
    fx # json viewer
    ripgrep # recursive grep
    
    # extra
    texlive.combined.scheme-full
    postgresql

    steam

  ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.zsh = {	   
    enable = true;
    shellAliases = {
    e = "emacs -nw";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
    # z - jump around
    # source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
    export ZSH_THEME="lambda"
    plugins=(git)
    source $ZSH/oh-my-zsh.sh
    '';
    promptInit = "";
  };

  # Steam
  programs.steam.enable = true;

  # List services that you want to enable:

  # Enable locate
  services.locate.enable = true;
  services.locate.pruneNames = []; # to supress warning "findutils locate does not support pruning by directory component"
  
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable bluetooth suppoort
  hardware.bluetooth.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  
  environment.variables.EDITOR = "emacs -nw";

  # # audio jack
  #  services.jack = {
  #   jackd.enable = true;
  #   # support ALSA only programs via ALSA JACK PCM plugin
  #   alsa.enable = false;
  #   # support ALSA only programs via loopback device (supports programs like Steam)
  #   loopback = {
  #     enable = true;
  #     # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
  #     #dmixConfig = ''
  #     #  period_size 2048
  #     #'';
  #   };
  # };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jade = {
    isNormalUser = true;
    shell = pkgs.zsh;
    # extraGroups = [ "wheel" "networkmanager" "docker" "audio" ]; # Enable ‘sudo’ for the user.
    extraGroups = [ "wheel" "networkmanager" "docker" "audio" "jackaudio" ]; # Enable ‘sudo’ for the user.
  };
  # home-manager.users.eve = { pkgs, ... }: {
  #   home.packages = [ pkgs.atool pkgs.httpie ];
  #     programs.bash.enable = true;
  #     };
  

  # Enable bluetooth applet/manager
  services.blueman.enable = true;

  fonts = {
    fontDir.enable = true;
    # deprecatedenableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts
      freefont_ttf
      google-fonts
      inconsolata
      liberation_ttf
      powerline-fonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  ## systemd
  systemd.user.services."urxvtd" = {
    enable = true;
    description = "rxvt unicode daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.rxvt_unicode ];
    serviceConfig.Restart = "always";
    serviceConfig.RestartSec = 2;
    serviceConfig.ExecStart = "${pkgs.rxvt_unicode}/bin/urxvtd -q -o";
  };


  # hardware.opengl.driSupport32Bit = true; # might be useful for gpu?
  # xserver
  environment.pathsToLink = ["/libexec"];
  services.xserver = {
    enable = true;

    # Enable Nvidia
    videoDrivers = [ "nvidia" ];

    desktopManager = {
      #default = "none";
      xterm.enable = false;
      xfce.enable = true;

    };
    
    displayManager = {
            defaultSession = "none+i3";
    };
		
    # windowManager.gnome.enable = false;
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
	      i3status
	      i3lock
	      i3blocks
      ];
    };
    displayManager.sessionCommands =  ''
      xrdb "${pkgs.writeText  "xrdb.conf" ''
         URxvt.font:                 xft:Dejavu Sans Mono for Powerline:size=11
         XTerm*faceName:             xft:Dejavu Sans Mono for Powerline:size=11
         # URxvt.font:                 xft:Dejavu Sans Mono:size=11
         # XTerm*faceName:             xft:Dejavu Sans Mono:size=11
         XTerm*utf8:                 2
         URxvt.iconFile:             /usr/share/icons/elementary/apps/24/terminal.svg
#         URxvt.letterSpace:          -1
         URxvt.letterSpace:          0
         URxvt.background:           #121214
         URxvt.foreground:           #FFFFFF
         XTerm*background:           #121212
         XTerm*foreground:           #FFFFFF
         ! black
         URxvt.color0  :             #2E3436
         URxvt.color8  :             #555753
         XTerm*color0  :             #2E3436
         XTerm*color8  :             #555753
         ! red
         URxvt.color1  :             #CC0000
         URxvt.color9  :             #EF2929
         XTerm*color1  :             #CC0000
         XTerm*color9  :             #EF2929
         ! green
         URxvt.color2  :             #4E9A06
         URxvt.color10 :             #8AE234
         XTerm*color2  :             #4E9A06
         XTerm*color10 :             #8AE234
         ! yellow
         URxvt.color3  :             #C4A000
         URxvt.color11 :             #FCE94F
         XTerm*color3  :             #C4A000
         XTerm*color11 :             #FCE94F
         ! blue
         URxvt.color4  :             #3465A4
         URxvt.color12 :             #729FCF
         XTerm*color4  :             #3465A4
         XTerm*color12 :             #729FCF
         ! magenta
         URxvt.color5  :             #75507B
         URxvt.color13 :             #AD7FA8
         XTerm*color5  :             #75507B
         XTerm*color13 :             #AD7FA8
         ! cyan
         URxvt.color6  :             #06989A
         URxvt.color14 :             #34E2E2
         XTerm*color6  :             #06989A
         XTerm*color14 :             #34E2E2
         ! white
         URxvt.color7  :             #D3D7CF
         URxvt.color15 :             #EEEEEC
         XTerm*color7  :             #D3D7CF
         XTerm*color15 :             #EEEEEC
         URxvt*saveLines:            32767
         XTerm*saveLines:            32767
         URxvt.colorUL:              #AED210
         URxvt.perl-ext:             default,url-select
         URxvt.keysym.M-u:           perl:url-select:select_next
         URxvt.url-select.launcher:  /usr/bin/env firefox -new-tab
         URxvt.url-select.underline: true
         Xft*dpi:                    96
         Xft*antialias:              true
         Xft*hinting:                full
         URxvt.scrollBar:            false
         URxvt*scrollTtyKeypress:    true
         URxvt*scrollTtyOutput:      false
         URxvt*scrollWithBuffer:     false
         URxvt*scrollstyle:          plain
         URxvt*secondaryScroll:      true
         Xft.autohint: 0
         Xft.lcdfilter:  lcddefault
         Xft.hintstyle:  hintfull
         Xft.hinting: 1
         Xft.antialias: 1 
	 URxvt.keysym.Control-Up:     \033[1;5A
	 URxvt.keysym.Control-Down:   \033[1;5B
	 URxvt.keysym.Control-Left:   \033[1;5D
	 URxvt.keysym.Control-Right:  \033[1;5C
      ''}"
   '';
};

 programs.dconf.enable = true;
 services.dbus.packages = [ pkgs.gnome3.dconf ];
}
