# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, lib, nixpkgs_flake, ... }: # hyprland ,
let
  # GeForce GTX 750
  gpuIDs = [
    "10de:1381" # Graphics
    "10de:0fbc" # Audio
  ];
  my_overlays = [
    (import ./nixpkgs-overlays)
    /*
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    })) */
  ];
  addNixPath4NixTools = "nixpkgs-overlays=/etc/nixos/overlays-compat";

in
{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  /**** Use the GRUB 2 boot loader. *****
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  ***************************************/
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.systemd-boot.enable = true;
  # boot.loader.grub.device = "nodev"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.initrd.kernelModules = [ 
    "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd"  # These modules are required for PCI passthrough, and must come before early modesetting stuff
    "amdgpu" # amd
  ];

  # CHANGE: Don't forget to put your own PCI IDs here
  # boot.extraModprobeConfig ="options vfio-pci ids=1002:67b1,1002:aac8";
  boot.kernelParams = [
    # "nvidia-drm.modeset=1"
    /*** CHANGE: intel_iommu enables iommu for intel CPUs with VT-d
         use amd_iommu if you have an AMD CPU with AMD-Vi  ***/
    "amd_iommu=on" # use intel_iommu if you have an intel CPU with VT-d
  ] ++ [("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)];
  

  fileSystems = {

    "/".options = [ "compress=zstd" "discard=async" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];

    "/data" = {
      device = "/dev/disk/by-uuid/3e04a537-342d-41ff-a971-937c82043002";
      fsType = "xfs";
      options = [ "discard" ];
    };
    "/space" = {
      device = "/dev/disk/by-uuid/16a190b8-8752-4f0c-83b5-468c017da6cf";
      fsType = "ext4";
    };
    "/var" = {
      device = "/dev/disk/by-uuid/2eab9381-a119-4adc-9c67-705062e115d6";
      fsType = "ext4";
    };
    "/opt" = {
      device = "/dev/disk/by-uuid/1fd93a19-b077-49c2-87e1-3c04cb7d76dd";
      fsType = "ext4";
    };

  };

  /* systemd = {
       timers.simple-timer = {
         wantedBy = [ "timers.target" ];
         partOf = [ "simple-timer.service" ];
         timerConfig.OnCalendar = "weekly";
       };
       services.simple-timer = {
         serviceConfig.Type = "oneshot";
         script = ''
           nix-store --optimise
         '';
       };
     };
  */
  # Configure network proxy if necessary

  # networking.proxy.default = "socks5://127.0.0.1:1080/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,mirrors.tuna.tsinghua.edu.cn,download.jetbrains.com,prehonor-generic.pkg.coding.net";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
    inputMethod = {

      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-chinese-addons ];

    };
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
    # packages = with pkgs; [ hack-font kbd ];
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-han-serif
      source-han-serif-traditional-chinese
      wqy_microhei
      wqy_zenhei
      fantasque-sans-mono # A font family with a great monospaced variant for programmers
      jetbrains-mono
      iosevka # Slender monospace sans-serif and slab-serif typeface inspired by Pragmata Pro, M+ and PF DIN Mono, designed to be the ideal font for programming
      fira-code # Monospace font with programming ligatures
      fira-code-symbols # FiraCode unicode ligature glyphs in private use area
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      symbola # Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode
      
      # roboto # need for sddm
      # ttf-wps-fonts # 安装到home下
    ];
    /* fontconfig = {
         defaultFonts = {
           serif = [ "WenQuanYi Micro Hei" "FiraCode" ];
           sansSerif = [ "WenQuanYi Micro Hei" "FiraCode" ];
           monospace = [ "WenQuanYi Micro Hei" "FiraCode" ];
         };
       };
    */
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  programs = {
    bash.enableCompletion = true;
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    wireshark.enable = true;
    dconf.enable = true; # Running GNOME programs outside of GNOME
    xwayland.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };

  };

  /* services.gnome.evolution-data-server.enable = true; # gnome 环境配置
     services.gnome.gnome-online-accounts.enable = true; # gnome 环境配置
     services.gnome.gnome-keyring.enable = true; # gnome 环境配置
     services.gnome.tracker-miners.enable = false;
     services.gnome.tracker.enable = false;
     # services.gnome.core-developer-tools.enable = true;
     environment.gnome.excludePackages = with pkgs; [
       gnome.cheese gnome-photos gnome.gnome-music gnome.gedit
       epiphany # 浏览器
       # evince # pdf阅读器
       gnome.gnome-characters # 表情符号等
       gnome.totem gnome-tour gnome.geary # 媒体播放器; 旅游app ; mail客户端
       gnome.tali gnome.iagno gnome.hitori gnome.atomix # 游戏
       # gnome.gnome-terminal
     ];
  */
  services.udisks2.enable = true;
  security.pam.services.swaylock = {}; # 保证锁屏
  # services.gnome.tracker-miners.enable = true;
  # services.gnome.tracker.enable = true;

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-runtime"
      ];
      permittedInsecurePackages = [
        "qtwebkit-5.212.0-alpha4"
      ];
      /* packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      }; */
    };
    overlays = my_overlays;
  };

  nix = {
  
    nixPath = options.nix.nixPath.default
     ++ [ addNixPath4NixTools ];  # 非flake模式，home下 nix tools 可以找到系统范围的overlays
    # sandboxPaths = [ "/home" ];
    settings = {
      sandbox = true;
      nix-path = options.nix.nixPath.default ++ [ "nixpkgs=${nixpkgs_flake}" addNixPath4NixTools ];  # flake模式，home下 nix tools 可以找到系统范围的overlays
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-public-keys = [
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
        "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="  # 一个桌面项目
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];

      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://nixos-cn.cachix.org"
        "https://nix-community.cachix.org"
        "https://iohk.cachix.org"
        "https://nixcache.reflex-frp.org"
        "https://nixpkgs-wayland.cachix.org"
        "https://hyprland.cachix.org" # 一个桌面项目
        # "https://hydra.iohk.io"
      ];
      
    };

  };
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;  # amd
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk               # amd
        rocm-opencl-icd      # amd
        rocm-opencl-runtime  # amd
        # intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        # vaapiVdpau     # nvidia
        # libvdpau-va-gl # nvidia
      ];
      extraPackages32 = with pkgs; [
        # libva # intel 核显得api
        driversi686Linux.amdvlk  # amd
        # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  environment.variables = rec {
    # PYCHARM_JDK = "/gh/prehonor/gitproject/JetBrainsRuntime/build/linux-x86_64-normal-server-release/jdk";
    # DATAGRIP_JDK = PYCHARM_JDK;
    # IDEA_JDK = PYCHARM_JDK;
    # WEBIDE_JDK = PYCHARM_JDK; # 挪到 ./config/nixpkgs/config.nix中
  };

  environment.sessionVariables = {
    # WEBKIT_DISABLE_COMPOSITING_MODE = "1";  # KDE桌面中的嵌入webkit应用打开页面blank
    # WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
    # RUSTUP_HOME = "/nh/prehonor/.rustup";
    # QT_QPA_PLATFORM = "xcb";
    # Steam needs this to find Proton-GE
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  
    XDG_CACHE_HOME  = "\${HOME}/.cache";
    XDG_CONFIG_HOME = "\${HOME}/.config";
    XDG_BIN_HOME    = "\${HOME}/.local/bin";
    XDG_DATA_HOME   = "\${HOME}/.local/share";
    # note: this doesn't replace PATH, it just adds this to it
    PATH = [ 
      "\${XDG_BIN_HOME}"
    ];

  };

  environment.systemPackages = with pkgs; [
    sudo
    git
    parted
    libxfs.bin # SGI XFS utilities
    virt-manager # Desktop user interface for managing virtual machines
    dfeet # D-Feet is an easy to use D-Bus debugger
    # 已经由option启用 qemu # A generic and open source machine emulator and virtualizer
    # bsd-finger # User information lookup program
    pciutils # A collection of programs for inspecting and manipulating configuration of PCI devices
    libva-utils # A collection of utilities and examples for VA-API
    # vdpauinfo # Tool to query the Video Decode and Presentation API for Unix (VDPAU) abilities of the system # for NVIDIA
    # file # A program that shows the type of files
    # binutils-unwrapped # Tools for manipulating binaries (linker, assembler, etc.) 
    # bind         # Domain name server
    # bashInteractive.dev # GNU Bourne-Again Shell, the de facto standard shell on Linux
    # getconf
    # fontconfig # A library for font customization and configuration
    xclip # Tool to access the X clipboard from a console application
    xdotool

    dos2unix # Convert text files with DOS or Mac line breaks to Unix line breaks and vice versa
    dpkg # The Debian package manager

    unrar # Utility for RAR archives
    unzip # An extraction utility for archives compressed in .zip format
    zip # Compressor/archiver for creating and modifying zipfiles
    p7zip # A new p7zip fork with additional codecs and improvements (forked from https://sourceforge.net/projects/p7zip/)
    
    ntfs3g # FUSE-based NTFS driver with full write support
    usbutils # Tools for working with USB devices, such as lsusb
    lsof # A tool to list open files

    fd # A simple, fast and user-friendly alternative to find
    ripgrep # A utility that combines the usability of The Silver Searcher with the raw speed of grep

    rtags # C/C++ client-server indexer based on clang
    nixfmt # An opinionated formatter for Nix
    shellcheck # Shell script analysis tool
    rnix-lsp # A work-in-progress language server for Nix, with syntax checking and basic completion
    bear # Tool that generates a compilation database for clang tooling
    gnuplot # A portable command-line driven graphing utility for many platforms
    socat # Utility for bidirectional data transfer between two independent data channels
    wmctrl
    pavucontrol # PulseAudio Volume Control
  
    wget
    curl
    # wireshark  #  use nixpkgs option instead
    netcat
    tcpdump
    ltrace
    mcrypt
    thc-hydra
    nmap
    john
    crunch
    # gnome-builder
    gnome.adwaita-icon-theme # Running GNOME programs outside of GNOME

    /* # gnome 桌面 start
       # gnome-builder 包含在 gnome.core-developer-tools.enable
       ksnip peek
       guake gnome.gnome-tweaks
       # gnome.gnome-books
       gnome.seahorse # Application for managing encryption keys and passwords in the GnomeKeyring
       gnomeExtensions.appindicator
       gnomeExtensions.vitals
       gnomeExtensions.dash-to-dock
       gnomeExtensions.gsconnect
       gnomeExtensions.mpris-indicator-button
       gnomeExtensions.fildem-global-menu
       gnome.nautilus-python
       # gnomeExtensions.frippery-applications-menu
       # gnome 桌面 end
    */

    convmv # Converts filenames from one encoding to another
    jpegoptim # Optimize JPEG files


    gcc
    cachix # Command line client for Nix binary cache hosting https://cachix.org
    patchelf
   # lispPackages.quicklisp

    # haskellPackages.ghcup # 使用 curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh 安装
    # boost_x.dev

    # wofi # A launcher/menu program for wlroots based wayland compositors such as sway
    ulauncher # A fast application launcher for Linux, written in Python, using GTK
    wlogout # A wayland based logout menu
    # swaylock # Screen locker for Wayland
    swaylock-effects 
    kanshi # Dynamic display configuration tool
    grim # Grab images from a Wayland compositor
    mako # A lightweight Wayland notification daemon
    wlsunset # Day/night gamma adjustments for Wayland
    swayidle # Idle management daemon for Wayland
    slurp # Select a region in a Wayland compositor
    xdg-desktop-portal-wlr # xdg-desktop-portal backend for wlroots
    wayfire
    wcm
    wl-clipboard # Command-line copy/paste utilities for Wayland
    # hyprland
    udiskie # Removable disk automounter for udisks
    # ranger
    # tmux # Terminal multiplexer
    # i3status-rust # Very resource-friendly and feature-rich replacement for i3status

    
    # mpvpaper
    # xfce.thunar xfce.thunar-archive-plugin 
    # waybar # waylandPkgs.swaybg wl-clipboard
  ];

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command =
          # "${pkgs.greetd.tuigreet}/bin/tuigreet -t --remember --cmd ${pkgs.hyprland}/bin/Hyprland";
          "${pkgs.greetd.tuigreet}/bin/tuigreet -t --remember --cmd ${pkgs.wayfire}/bin/wayfire"; # --config /etc/greetd/wayfire.ini
        user = "prehonor";
      };
    };
  };

  services.udev.packages = with pkgs;
    [
      android-udev-rules
      # gnome.gnome-settings-daemon # gnome 桌面
    ];
  services.dbus.packages = with pkgs;
    [ gnome2.GConf ]; # Running ancient gnome applications
  services.mysql = {
    enable = false;
    package = pkgs.mysql80;
    user = "prehonor"; # 这里不能设置root 或mysql
    group = "users";
    dataDir = "/data/data_sina";
    settings = {
      mysqld = {
        # socket = "/tmp/mysql.sock"; -> our module is hard coded to expect /run/mysql/mysqld.sock
        plugin-load-add = "auth_socket.so";
        character_set_server = "utf8mb4";
        performance_schema = false;
        skip-external-locking = true;
        max_connections = 10;
        performance_schema_max_table_instances = 60;
        table_definition_cache = 60;
        table_open_cache = 16;
        innodb_buffer_pool_size = "16M";
      };
    };
  };
 services.resolved.enable = false;
  # services.dnsmasq.enable = true;
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    dataDir = "/data/psql";
  };

  virtualisation = {
    # docker.enable = false; 
    # virtualbox.host.enable = true;
    libvirtd = {
      enable = true;
      qemu.verbatimConfig = ''
        # OVMF :Sample UEFI firmware for QEMU and KVM
        nvram = [ "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd" ]
      '';
    };
    spiceUSBRedirection.enable = true;
    /**************** waydroid ***************/
    waydroid.enable = true; 
    # lxd.enable = true;
    /*****************************************/
    # anbox.enable = true;
  };
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [{
      users = [ "prehonor" ];
      commands = [{
        command = "ALL";
        options =
          [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
      }];
    }];
    extraConfig = "Defaults env_keep += \"http_proxy https_proxy\"";
  };

  networking = {
    timeServers = [
      "ntp.aliyun.com"
      "time1.cloud.tencent.com"
      "cn.pool.ntp.org"
      "asia.pool.ntp.org"
      "time.windows.com"
    ]; # options.networking.timeServers.default ++ [ "ntp.example.com" ];
    hostName = "prehonor";
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
      connectionConfig = {
        "ipv6.ip6-privacy" = 2;
      };
    };
    dhcpcd.enable = false;
    useDHCP = false;
    # interfaces.enp5s0.useDHCP = true;
    # nameservers = [ "127.0.0.1" "::1"];
    resolvconf.enable = pkgs.lib.mkForce false;
    # resolvconf.useLocalResolver = true;
    # If using dhcpcd:
    # dhcpcd.extraConfig = "nohook resolv.conf";

    firewall = {
      enable = true; # 默认值为true 不用设置，这里仅做提醒
      trustedInterfaces = [ "virbr0" ];
      allowedTCPPorts = [ 1716 5357 ];
      allowedUDPPorts = [ 1716 3702 ];
    };
    
  };

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.1:5658" "[::1]:5658" ];
      ipv4_servers = true;
      ipv6_servers = true;
      dnscrypt_servers = true;
      doh_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          "https://ipv6.download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
      };

      sources.relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md"
          "https://download.dnscrypt.info/resolvers-list/v3/relays.md"
          "https://ipv6.download.dnscrypt.info/resolvers-list/v3/relays.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;
      };
      # You can choose a specific set of servers https://dnscrypt.info/public-servers/ 
      server_names = [
        "cloudflare-security"
        "ahadns-doh-in"
        "acsacsar-ams-ipv4"
        "cloudflare"
        "circl-doh"
        "cisco-doh"
        "adguard-dns-doh"
        "cloudflare-ipv6"
        "acsacsar-ams-ipv6"
        "circl-doh-ipv6"
        "cisco-ipv6-doh"
        "adguard-dns-ipv6"
      ];

      fallback_resolvers = [ "114.114.114.114:53" ];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

/*
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };
*/
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  # Enable the X11 windowing system.

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "euro";
    xkbOptions =
      "esperanto:qwerty"; # "caps:capslock,grp:win_space_toggle"; # win+Space switch layout
    xkbModel = "pc105";

    videoDrivers = [ "amdgpu" ]; # nouveau amdgpu nvidia
 
    displayManager = {

      startx.enable = true;
      # gnome 环境
      /* gdm = {
           enable = true;
           wayland = false;
         };
      */

    };

    desktopManager = {
      # gnome.enable = true; # gnome 环境
      xterm.enable = false; # 没效果
    };

  };
 # hardware.nvidia.modesetting.enable = true; # wayland 环境
 ## hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prehonor = {
    home = "/home/prehonor";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "video"
      "power"
      "users"
      "pulseaudio"
      "mysql"
      "wireshark"
      "greeter"
      "libvirtd"
      "adbusers"
    ]; # Enable ‘sudo’ for the user.
    subUidRanges = [{
      startUid = 100000;
      count = 65536;
    }];
    subGidRanges = [{
      startGid = 100000;
      count = 65536;
    }];
    shell = pkgs.zsh;
  };
  services.gvfs.enable = true;

  services.samba-wsdd.enable = true;
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/space/download";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "prehonor";
        "force group" = "users";
      };
    };
  };
  
  environment.etc = {
    "containers/policy.json" = {
      mode = "0644";
      text = ''
        {
          "default": [
            {
              "type": "insecureAcceptAnything"
            }
          ],
          "transports":
            {
              "docker-daemon":
                {
                  "": [{"type":"insecureAcceptAnything"}]
                }
            }
        }
      '';
    };

    "containers/registries.conf" = {
      mode = "0644";
      text = ''
        [registries.search]
        registries = ['docker.io', 'quay.io']
      '';
    };
    /* "greetd/environments".text = ''
           wayfire
           bash
           startxfce4
       '';
    */
    /* "NetworkManager/dnsmasq.d/foo".text =  ''
         domain-needed
         bogus-priv
         strict-order
         dnssec #为nixos新加的，不知道效果如何
         trust-anchor=.,19036,8,2,49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5
         trust-anchor=.,20326,8,2,E06D44B80B8F1D39A95C0B0D7C65D08458E880409BBC683457104237C7F8EC8D
         dnssec-check-unsigned #同上
         no-resolv
         no-poll
         server=::1#5658
         server=127.0.0.1#5658
         interface=enp5s0
         listen-address=::1,127.0.0.1
         cache-size=966
         log-queries
         log-facility=/var/log/dnsmasq.log
         conf-dir=/etc/nixos/dnsmasq.d/,*.conf
       '';
    
    "dnsmasq.conf".text =  ''
         domain-needed
         bogus-priv
         strict-order
         dnssec #为nixos新加的，不知道效果如何
         trust-anchor=.,19036,8,2,49AAC11D7B6F6446702E54A1607371607A1A41855200FD2CE1CDDE32F24E8FB5
         trust-anchor=.,20326,8,2,E06D44B80B8F1D39A95C0B0D7C65D08458E880409BBC683457104237C7F8EC8D
         dnssec-check-unsigned #同上
         no-resolv
         no-poll
         server=::1#5658
         server=127.0.0.1#5658
         interface=enp5s0
         listen-address=::1,127.0.0.1
         cache-size=966
         log-queries
         log-facility=/var/log/dnsmasq.log     
       '';
       */
  };

  system.stateVersion = "22.11";

}

