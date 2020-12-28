# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
  # boot loader timeout, null will never timeout 
    boot.loader.timeout = 120;

  # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

  # Set your time zone.
    time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Update the microCode for AMD processors 
    hardware.cpu.amd.updateMicrocode = true;
    
  # Enable bluetooth
    hardware.bluetooth = {
      enable = true;
      config = {
        # A2DP profile for Modern headsets
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

  # Enable sound
    sound.enable = true; 
    # pulseaudio
    hardware.pulseaudio = {
      enable = true;
     # NixOS allows either a lightweight build (default) 
     # or full build of PulseAudio to be installed.
     # Only the full build has Bluetooth support, so it must be selected here.
     package = pkgs.pulseaudioFull;
    };

  # Networking
    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.enp7s0.useDHCP = true;
    networking.interfaces.wlp6s0.useDHCP = true;

  # enable/disable the firewall
    networking.firewall.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Configure keymap in X11
    services.xserver.layout = "us";

  # Xserver
  services.xserver = {
    enable = true;
    autorun = true;
    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      xmonad.extraPackages = haskellPackages: [ 
          haskellPackages.xmonad-contrib      # Xmonad contrib
          haskellPackages.xmobar              # A minimalistic text based status bar
          haskellPackages.xmonad-wallpaper    # Xmonad wallpaper
      ];
    };
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
     defaultSession = "none+xmonad";
     gdm.enable = true;
    };
  };

 #  Xserver video drivers
    services.xserver.videoDrivers = [ "nvidia" ];
 
  # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
  # environment.etc sysmlinking
  environment.etc = {
    "jdk11".source = pkgs.adoptopenjdk-bin;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
     wget           # Tool for retrieving files using HTTP,HTTPS, and FTP 
     vim            # The most popular clone of the VI editor
     wpa_supplicant # A tool for connecting to WPA and WPA2-protected wireless networks
     iw             # Tool to use nl80211
     networkmanager # Network configuration and managment tool
     zsh            # The Z shell
   ];

  # Fonts
  fonts.fonts = with pkgs; [
    nerdfonts        # Nerd Iconic font aggregator
    font-awesome     # Font awesome iconic font
    noto-fonts       # Beautiful and free fonts for many languages
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Programs 
     # zsh shell
     programs.zsh.enable = true;
    
     # java development kit  11
     programs.java = {
       enable = true;
       package = pkgs.adoptopenjdk-bin;
     };

  # Location to enable day-light saving, night light functionality
  # The location provider to use for determining your location. 
  # location = "manual" or "geoclue2"
  # If set to manual you must also provide latitude/longitude.
  location = {
    provider = "manual";
    latitude = 24.4852;
    longitude = 86.69;
  };

  # List services that you want to enable:
  # ------------------------------------------------------------------------------
    # Mysql database server
    services.mysql = {
       enable = false;
       package = pkgs.mysql;
       dataDir = "/var/lib/mysql";
    };
    
    # MongoDB nosql database server
    services.mongodb = {
      enable = false;
    };

    # Network time synchronization
    services.ntp.enable = true;

    # Picom as X11 compositor
    services.picom = {
      enable = true;
      backend = "xr_glx_hybrid";
      vSync = true;
      fade = true;
      fadeDelta = 5;
      fadeSteps = [ 0.032 0.033 ]; 
      settings = {
        xrender-sync-fence = true;
      };
    };
    
    # Teamviewer
    services.teamviewer.enable = true;

    # Jellyfin media server
    services.jellyfin.enable = false;

    # Redshift blue light filter - adjust screen brightness and 
    # color temperature
    services.redshift = {
      enable = true;
      brightness.day = "0.9";
      brightness.night = "0.8";
      temperature.day = 5500;
      temperature.night = 4000;
    };

    # blueman service provides blueman-applet and blue-manager
    services.blueman.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # ------------------------------------------------------------------------------
  #
  virtualisation = {
     podman = {
       enable = true;
       # Create a `docker` alias for podman, to use it as a drop-in replacement
       dockerCompat = true;
     };
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.akhilesh = {
     name = "akhilesh";
     description = "Akhilesh";
     isNormalUser = true;
     isSystemUser = false;
     createHome = true;
     home = "/home/akhilesh";
     shell = pkgs.zsh;
     group = "users";
     extraGroups = [ "networkmanager" "audio" "video" ];
     packages = with pkgs; [
       zsh              # The Z shell
       ripgrep          # A utility that combines The Silver Searcher with grep
       silver-searcher  # A code-searching tool similar to ack, but faster
       fzf              # fuzzy finder
       fasd             # Quick command-line access to files and dirs for POSIX shells
       tmux             # Terminal multiplexer
       ranger           # Command line file manager
       nnn              # Light weight Command line file manager
       cmus             # Command line music player
       figlet           # Program for making large letters out of ordinary text
       pfetch           # A pretty system information tool written in POSIX sh
       cmatrix          # Simulates the falling characters theme from the Matrix movie
       xclip            # Tool to access the X clipboard from a console applicaiton
       killall          # Tool to kill multiple processes
       pamixer          # Pulseaudio command line mixer
       alacritty        # Terminal emulator
       git              # git version control
       st               # Terminal emulator
       guake            # Dropdown Terminal emulator
       rxvt-unicode     # urxvt Terminal emulator
       dmenu            # A generic menu for the X window System
       rofi             # Window switcher, run dialog and dmenu replacement
       albert           # Desktop agnostic launcher
       feh              # Light weight image viewer, wallpaper change
       nitrogen         # Wallpaper setter
       firefox          # Firefox web browser
       chromium         # Chromium web browser
       google-chrome    # Google chrome web browser
       brave            # Brave web browser  
       meld             # Visual diff and merge tool
       bcompare         # Beyond compare - compare files and folders
       elasticsearch    # Open Source, Distributed, RESTful Search Engine
       logstash         # A data pipeline that helps you process logs
       kibana           # Visualize logs and time-stamped data
       jetbrains.idea-community   # Intellij Idea IDE
       eclipses.eclipse-java      # Eclipse IDE for Java Developers
       sublime3         # sublime text editor
       emacs            # The extensible,customizable GNU text editor
       vscode           # Visual Studio Code text editor
       drawio           # A desktop application for creating diagrams (draw.io)
       postman          # Postman api development tool
       newman           # Postman command line colleciton runner
       maven            # Java build tool
       gradle           # Java build tool
       gradle-completion # Gradle build tool command line completion helper
       jenkins          # Jenkins CI
       apacheKafka      # Apache Kafka
       python           # Python 3
       python2          # Python 2
       nodejs           # Node js
       mysql-workbench  # Visual MySql database modelling, administration and querying tool
       joplin-desktop   # An open source note taking and To-Do application
       mupdf            # A lightweight vim inspired pdf reader
       zathura          # A lightweight pdf reader
       gnome3.evince    # Evince pdf reader
       rtorrent         # Command line torrent client  
       qbittorrent      # Torrent GUI client
       aria 
       uget             # Download manager
       scrot            # A command line screen capture utility
       dunst            # Light-Weight notification daemon
       sxhkd            # Simple X hotkey daemon
       wpsoffice        # WPS office
       mpv              # mpv video player
       mplayer          # A movie player that supports many video formats
       youtube-dl       # Command line youtube downloader
       mps-youtube
       tdesktop         # Telegram desktop client     
       gnome3.eog       # Eye-of-Gnome image viewer
       gthumb           # image viewer, organizer
       gimp             # GNU Image Manipulator - Photo editor
       jpegoptim        # Optimize JPEG files
       jpegrescan       # losslessly shring any JPEG file
       jpeginfo         # Prints information and tests integrity of JPEG/JFIF files
       imagemagick      # A software suite to create,edit,compose, or convert bitmap images
       ffmpeg           # A complete sol to record,convert and stream audio and video
       ffmpegthumbnailer   # A lightweight video thumbnailer
       jellyfin         # Jellyfin media server
       rhythmbox        # Rhythmbox GUI music player
       spotify          # Play music from the Spotify music service
       cinnamon.nemo    # Nemo GUI file manager
       gnome3.nautilus  # Nautilus GUI file manager
       teamviewer       # Teamviewer Desktop client
       teams            # Microsoft teams meetings
       skypeforlinux    # Skype Desktop client
       zoom-us          # Zoom meetings
       calibre          # e-Library manager
       xbrightness      # X11 screen brightness controller
       mtpfs            # FUSE Filesystem providing access to MTP devices
       jmtpfs           # A FUSE filesystem for MTP devices like Android phones
       gnome3.cheese    # Take photos and videos with your webcam, with effects
       webcamoid        # Webcam Capture Software
       glances          # Cross-platform curses-based monitoring tool
       filezilla        # Graphical FTP,FTPS and SFTP client
       mailspring       # A beautiful, fast and maintained fork of Nylas Mail
       haskellPackages.xmobar # A minimalistic Text Based Status Bar
       i3lock-color     # A simple screen locker like slock, enhanced version
       trayer           # A lightweight GTK2-based systray for UNIX desktop
       networkmanagerapplet # network manager applet
       pasystray        # PulseAudio system tray
     ];
   };

  # security
  security.sudo.enable = false; 

  # Automatic Upgrades
  # If allowReboot is true, then the system will automatically reboot 
  # if the new generation contains a different kernel, initrd or kernel modules
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;
   
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
