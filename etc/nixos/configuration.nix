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

  # Kernel modules for hardware devices are generally loaded automatically by udev
  # You can force a module to be loaded via boot.kernelModules
    boot.kernelModules = [ "fuse" ];

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
     # NixOS allows either a lightweight build (default) or full build
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
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [ 
            haskellPackages.xmonad-contrib      # Xmonad contrib
            haskellPackages.xmobar              # A minimalistic text based status bar
            haskellPackages.xmonad-wallpaper    # Xmonad wallpaper
        ];
      };
    };
    desktopManager = {
      xterm.enable = false;
      plasma5.enable = false;
      gnome3.enable = false;
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
     mtpfs          # FUSE Filesystem providing access to MTP devices
     jmtpfs         # A FUSE filesystem for MTP devices like Android phones
     fuse3          # Library that allows filesystems to be implemented in user space
     ntfs3g         # FUSE-based NTFS driver with full write support
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

    # Running GNOME programs outside of gnome
    programs.dconf.enable = true;

  # Location to enable day-light saving, night light functionality
  # The location provider to use for determining your location. 
  # location = "manual" or "geoclue2"
  # If set to manual you must also provide latitude/longitude.
  location = {
    provider = "manual";
    latitude = 24.4852;
    longitude = 86.69;
  };

  # udev rules
  services.udev.packages = with pkgs; [ 
    android-udev-rules
    gnome3.gnome-settings-daemon
  ];

  # Services
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

    services.postgresql = {
      enable = false;
      package = pkgs.postgresql;
    };

    # Network time synchronization
    services.chrony.enable = true;
    # Teamviewer
    services.teamviewer.enable = true;
    # Jellyfin media server
    services.jellyfin.enable = false;
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
     extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
     packages = with pkgs; [
       zsh              # The Z shell
       starship         # A minimal, blazing fast, and extremely customizable prompt for any shell
       ripgrep          # A utility that combines The Silver Searcher with grep
       silver-searcher  # A code-searching tool similar to ack, but faster
       fzf              # fuzzy finder
       fasd             # Quick command-line access to files and dirs for POSIX shells
       tmux             # Terminal multiplexer
       tree             # Command to produce a depth indented directory listing
       ranger           # Command line file manager
       nnn              # Light weight Command line file manager
       cmus             # Command line music player
       figlet           # Program for making large letters out of ordinary text
       pfetch           # A pretty system information tool written in POSIX sh
       cmatrix          # Simulates the falling characters theme from the Matrix movie
       lolcat           # A rainbow version of cat 
       bc
       vivid            # A generator for LS_COLORS with support for multi color themes
       pywal            # Generate and change colorschemes on the fly
       xclip            # Tool to access the X clipboard from a console applicaiton
       killall          # Tool to kill multiple processes
       pamixer          # Pulseaudio command line mixer
       alacritty        # Terminal emulator
       git              # git version control
       st               # Terminal emulator
       gparted          # Graphical disk partitioning tool
       rxvt-unicode     # urxvt Terminal emulator
       dmenu            # A generic menu for the X window System
       rofi             # Window switcher, run dialog and dmenu replacement
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
       zipkin           # Zipkin distributed tracing system
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
       mysql-client     # MySql client ( mariadb-client )
       dbeaver          # Universal SQL client, Supports MySQL, PostgreSQL, Oracle and more
       joplin-desktop   # An open source note taking and To-Do application
       mupdf            # A lightweight vim inspired pdf reader
       zathura          # A lightweight pdf reader
       gnome3.evince    # Evince pdf reader
       gnome3.adwaita-icon-theme   # Many programs rely heavily on having an icon theme available
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
       mps-youtube      # Terminal based Youtube player and helper
       smtube           # Play and download Youtube videos
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
       handbrake        # A tool for converting video files and ripping DVDs
       playerctl        # Command-line utility for controlling media players implementing MPRIS
       jellyfin         # Jellyfin media server
       rhythmbox        # Rhythmbox GUI music player
       spotify          # Play music from the Spotify music service
       cinnamon.nemo    # Nemo GUI file manager
       gnome3.nautilus  # Nautilus GUI file manager
       gnome3.sushi     # A quick previewer for Nautilus
       teamviewer       # Teamviewer Desktop client
       teams            # Microsoft teams meetings
       skypeforlinux    # Skype Desktop client
       zoom-us          # Zoom meetings
       calibre          # e-Library manager
       picom            # X11 compositor
       xbrightness      # X11 screen brightness controller
       redshift         # Control screen color temperature
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
       xorg.xkill       # xorg xkill utility 
       lxappearance     # Utility to set fonts, icon themes, cursor themes, etc
       # Themes
       # Icon themes
       hicolor-icon-theme          # Default fallback theme
       arc-icon-theme
       moka-icon-theme
       numix-icon-theme
       numix-icon-theme-circle
       numix-icon-theme-square
       maia-icon-theme
       papirus-icon-theme
       pop-icon-theme
       # gtk themes
       zuki-themes
       vimix-gtk-themes
       stilo-themes
       # cursor themes
       numix-cursor-theme
       bibata-cursors
       bibata-extra-cursors
       bibata-cursors-translucent
       capitaine-cursors
       # Security and sandboxing
       firejail
     ];
   };

  # security
  security.sudo.enable = true; 

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

