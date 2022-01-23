# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 
{ config, pkgs, options, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nix = {
    binaryCachePublicKeys = [
      "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  
      "https://cache.nixos.org/" 
      "https://mirrors.bfsu.edu.cn/nix-channels/store" 
      "https://nixos-cn.cachix.org"
      "https://nix-community.cachix.org"
    ];

    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  # boot.kernelParams = [
  #    "nvidia-drm.modeset=1"
  # ];
  # Define on which hard drive you want to install Grub.
 # boot.loader.grub.systemd-boot.enable = true;
  boot.loader.grub.device = "nodev"; # or "nodev" for efi only
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  fileSystems."/gh" =
  { 
    device = "/dev/disk/by-uuid/2e8a3786-0be3-4ab7-9733-8ccbcefeb358";
    fsType = "ext4";
  };
  fileSystems."/ah" =
  { 
    device = "/dev/disk/by-uuid/7e25d235-3d5c-4714-8cd8-24b53f01f0e7";
    fsType = "ext4";
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplican

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  # networking.useDHCP = false;
  # networking.interfaces.enp3s0.useDHCP = true;
  nix.autoOptimiseStore = true;
/* 
 systemd = {
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
      fcitx5.addons = with pkgs; [
        fcitx5-chinese-addons
      ];
    /*
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ libpinyin ];
      */
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
      symbola
      roboto # need for sddm
     # aggregator
     # ttf-wps-fonts
    ];
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
    dconf.enable = true; # gnome 环境配置
    # xwayland.enable = true; # gnome 环境配置
  };

  services.gnome.evolution-data-server.enable = true; # gnome 环境配置

  services.gnome.gnome-online-accounts.enable = true; # gnome 环境配置

  services.gnome.gnome-keyring.enable = true; # gnome 环境配置

  services.gnome.chrome-gnome-shell.enable = true; # gnome 环境配置

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;

    # packageOverrides = pkgs: {
    #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    # };
  };

  hardware = {
    opengl = {
      driSupport32Bit = true;
      extraPackages = with pkgs; [ 
        # intel-media-driver # LIBVA_DRIVER_NAME=iHD
        # vaapiIntel  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau libvdpau-va-gl 
      ]; 
      extraPackages32 = with pkgs.pkgsi686Linux; [ 
        libva 
        # vaapiIntel  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };
  };

  environment.variables = rec {
   # ahome = "/ah/prehonor";
   # ghome = "/gh/prehonor";
#    PYCHARM_JDK = "/gh/prehonor/gitproject/JetBrainsRuntime/build/linux-x86_64-normal-server-release/jdk";
#    DATAGRIP_JDK = PYCHARM_JDK;
   # IDEA_JDK = PYCHARM_JDK;
   # WEBIDE_JDK = PYCHARM_JDK;
  };


  
  nixpkgs.overlays = [ (import ./nixpkgs-overlays) ];

  nix.nixPath =
    options.nix.nixPath.default ++ 
    [ "nixpkgs-overlays=/etc/nixos/overlays-compat" ];  


  environment.systemPackages = with pkgs; [
     sudo parted finger_bsd pciutils libva-utils vdpauinfo file binutils-unwrapped bind bashInteractive.dev getconf fontconfig
     # steam-run
     graphviz dos2unix grpc dpkg unzip zip tmux ntfs3g usbutils lsof unrar # appimage-run # p7zip

     wget tsocks curl wireshark netcat tcpdump ltrace
     mcrypt thc-hydra nmap-graphical nmap john crunch
     ghidra-bin nasm fasm wineWowPackages.stable  # charles cutter winetricks
     

    # v2ray #github 手工维护 qv2ray
     ventoy-bin

     # ark yakuake libsForQt5.gwenview okular # kde 桌面
     
     gnome.adwaita-icon-theme gnomeExtensions.appindicator gnomeExtensions.vitals gnomeExtensions.dash-to-dock gnome.gnome-tweaks gnomeExtensions.gsconnect guake gnome.nautilus-python
     # gnomeExtensions.frippery-applications-menu 
     # gnomeExtensions.ddterm
 # gnome 桌面

     xournalpp sublime4  mpv # krita sigil alacritty 
     #  zathura vim风格 epub pdf 阅读器
     # foliate epub阅读器
     # vlc blender  分别为视频和3d建模软件
     tdesktop lyx microsoft-edge-stable firefox qtcreator rstudio onlyoffice-bin # tor-browser-bundle-bin
     dbeaver android-studio atom # bcompare aria  
     goldendict qv2ray 
     jetbrains_x.idea-ultimate jetbrains_x.clion #  jetbrains.rider jetbrains.webstorm jetbrains.pycharm-professional
    # vscode
     
     masterpdfeditor
      steam 
      flameshot peek 
      opencv
      jpegoptim # Optimize JPEG files
      # digikam gimp   inkscape   synfigstudio  natron  scribus 不好使，删   edraw

     podman runc conmon slirp4netns fuse-overlayfs

     electron
     qt5.full libsForQt5.qt3d libsForQt5.kproperty libsForQt5.qt5.qtsensors libsForQt5.syntax-highlighting 
     libsForQt5.qt5.qtgamepad libsForQt5.qt5.qtserialbus libsForQt5.qt5.qtspeech
     cmake gcc gcc11 llvm_x lld_x lldb_x clang_x libclang_x pkg-config gitFull mercurial nix-index patchelf jdk11 jdk go lua_x chez
     mono dotnet-sdk nodejs_x yarn perl flutter rustup autoconf julia-bin 
     (python3.withPackages(ps: with ps; [ pip urllib3 spyder eric6 ansible ]))
     streamlink you-get youtube-dl

     # boost_x.dev
     libfakeXinerama libselinux libmysqlconnectorcpp
     libmysqlclient #libmysqlclient_315
  ];


  services.udev.packages = with pkgs; [
    android-udev-rules
    gnome.gnome-settings-daemon # gnome 桌面
  ];
  services.dbus.packages = with pkgs; [ gnome2.GConf ]; # gnome 桌面
  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    user = "prehonor"; #这里不能设置root 或mysql 
    group = "users";
    dataDir = "/ah/prehonor/Programmers/mysql/data_5";
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
   

  # virtualisation.anbox.enable = true;
  virtualisation.waydroid.enable = true;
  virtualisation.docker.enable = false;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
 
  security.sudo = {
     enable = true;
     wheelNeedsPassword = false;
     extraRules = [
        {  
          users = [ "prehonor" ];
          commands = [
            { 
              command = "ALL" ;
              options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
            }
          ];
        }
     ];
  };

  nix.optimise.automatic = true;
  nix.trustedUsers = [ "root" "@wheel" ];
  #  nix.sandboxPaths = [ "/ah" "/gh" "/home" ];
  #  nix.useSandbox = false; 
  networking = {
    timeServers =  [ "ntp.aliyun.com" "time1.cloud.tencent.com" "cn.pool.ntp.org" "asia.pool.ntp.org" "time.windows.com" ]; # options.networking.timeServers.default ++ [ "ntp.example.com" ];
    hostName = "prehonor";
    networkmanager.enable = true;
 #   useDHCP = false;
 #   interfaces.enp3s0.useDHCP = true;
    nameservers = [ "::1" ];
    resolvconf.useLocalResolver = true;
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "dnsmasq";
    firewall = { 
      enable = true; # 默认值为true 不用设置，这里仅做提醒
      allowedTCPPorts = [ 1716 ];
      allowedUDPPorts = [ 1716 ];
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
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        
      };
      
      sources.relays = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v2/relays.md"
          "https://download.dnscrypt.info/resolvers-list/v2/relays.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        refresh_delay = 72;   
      };
      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v2/public-resolvers.md "alidns-doh" "cisco" "adguard-dns" "adguard-dns-doh" 
      server_names = [ "cloudflare-security" "ahadns-doh-in" "acsacsar-ams-ipv4" "cloudflare"  "circl-doh" "cisco-doh" "cloudflare-ipv6" "acsacsar-ams-ipv6" ];
      
      fallback_resolvers = ["114.114.114.114:53"];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };
  
  services.fstrim = {
    enable = true;
    interval = "tuesday";  
};
  



  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;


  # Enable the X11 windowing system.

  # boot.kernelPackages = pkgs.linuxPackages.nvidia_x11; # gnome 环境
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta; # gnome 环境

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "euro";
    xkbOptions = "esperanto:qwerty";# "caps:capslock,grp:win_space_toggle"; # win+Space switch layout
    xkbModel = "pc105";

    videoDrivers = [ "nvidia" ]; # nouveau 

    displayManager = { 
      # lightdm.enable = true;
      
      # gnome 环境
      gdm = {
        enable = true;
        # wayland = true;
        # nvidiaWayland = true;
      };

    };

    desktopManager = {
      # plasma5.enable = true;
      gnome.enable = true; # gnome 环境
      # xterm.enable = false; #  没效果   
    };

  };
  hardware.nvidia.modesetting.enable = true; # gnome 环境


  environment.gnome.excludePackages = with pkgs; [ gnome.cheese gnome-photos gnome.gnome-music  gnome.gedit epiphany evince gnome.gnome-characters gnome.totem gnome.tali gnome.iagno gnome.hitori gnome.atomix gnome-tour gnome.geary 
  # gnome.gnome-terminal
  ];


  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prehonor = {
     home = "/home/prehonor";
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "power" "users" "pulseaudio" "mysql" "wireshark" "adbusers" ]; # Enable ‘sudo’ for the user.
     subUidRanges = [{ startUid = 100000; count = 65536; }];
     subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  # services.netdata.enable = true; # kde 环境
  /*
  services.samba = {
  enable = true;
  enableNmbd = false;
  securityType = "user";
  extraConfig = ''
    workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    security = user 
    #use sendfile = yes
    #max protocol = smb2
    hosts allow = 192.168.0  localhost
    hosts deny = 0.0.0.0/0
    guest account = nobody
    map to guest = bad user
  '';
  shares = {
    public = {
      path = "/mnt/Shares/Public";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "yes";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "prehonor";
      "force group" = "samba";
    };
    private = {
      path = "/mnt/Shares/Private";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mask" = "0644";
      "directory mask" = "0755";
      "force user" = "prehonor";
      "force group" = "samba";
    };
  };
}; */
  environment.etc."containers/policy.json" = {
    mode="0644";
    text=''
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

  environment.etc."containers/registries.conf" = {
    mode="0644";
    text=''
      [registries.search]
      registries = ['docker.io', 'quay.io']
    '';
  }; 
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11";

}

