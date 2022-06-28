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
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];
    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  
      "https://cache.nixos.org/" 
      "https://mirrors.bfsu.edu.cn/nix-channels/store" 
      "https://nixos-cn.cachix.org"
      "https://nix-community.cachix.org"
      "https://hydra.iohk.io" 
      "https://iohk.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];

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
      fantasque-sans-mono               # A font family with a great monospaced variant for programmers
      iosevka # Slender monospace sans-serif and slab-serif typeface inspired by Pragmata Pro, M+ and PF DIN Mono, designed to be the ideal font for programming
      fira-code                     # Monospace font with programming ligatures
      fira-code-symbols             # FiraCode unicode ligature glyphs in private use area
      # (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      symbola                           # Basic Latin, Greek, Cyrillic and many Symbol blocks of Unicode
      roboto # need for sddm
     # ttf-wps-fonts
    ];
    /*
    fontconfig = {
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
    # steam.enable = true;
    /*
    evolution = {
      enable = true;
      plugins = [ pkgs.evolution-ews ];
    };
    */
  };

/*
  services.gnome.evolution-data-server.enable = true; # gnome 环境配置
  services.gnome.gnome-online-accounts.enable = true; # gnome 环境配置
  services.gnome.gnome-keyring.enable = true; # gnome 环境配置
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  services.gnome.core-developer-tools.enable = true;


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

  services.emacs = {
    install = true;
    package = pkgs.emacsNativeComp;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    allowUnfree = true;

    # packageOverrides = pkgs: {
      # vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    # };
  };

  hardware = {
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ 
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau libvdpau-va-gl 
      ]; 
      extraPackages32 = with pkgs.pkgsi686Linux; [ 
        libva 
        vaapiIntel  # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
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
    # WEBIDE_JDK = PYCHARM_JDK;
  };

  environment.sessionVariables = {
    WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };



  
  nixpkgs.overlays = [ (import ./nixpkgs-overlays) ( import ./emacs-overlay ) ] ; 
  # (import "${builtins.fetchTarball "https://github.com/nix-community/nixpkgs-wayland/archive/master.tar.gz"}/overlay.nix")

  nix.nixPath =
    options.nix.nixPath.default ++ 
    [ "nixpkgs-overlays=/etc/nixos/overlays-compat" ];  

  environment.systemPackages = with pkgs; [
     sudo parted finger_bsd pciutils libva-utils vdpauinfo file binutils-unwrapped bind 
     bashInteractive.dev getconf fontconfig
     xorg.xhost

     graphviz dos2unix grpc dpkg unzip zip tmux ntfs3g usbutils lsof unrar fd ripgrep glslang rtags nixfmt sqlite texlive.combined.scheme-medium shellcheck rnix-lsp bear gnuplot socat
     wmctrl xdotool aria xorg.xprop xclip xorg.xwininfo

     wget tsocks curl wireshark netcat tcpdump ltrace
     mcrypt thc-hydra  nmap john crunch
     ghidra-bin nasm fasm wineWowPackages.stable  
     
     unityhub 
     ventoy-bin

     liferea glade 
     # gnome-builder
     gnome.adwaita-icon-theme # Running GNOME programs outside of GNOME

  /*
     # gnome 桌面 start
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

     mpv sublime4 p7zip

     #  vim风格 epub pdf 阅读器
     # foliate epub阅读器
     # vlc blender  分别为视频和3d建模软件
     # oni2  masterpdfeditor
     # krita sigil xournalpp
     # v2ray #github 手工维护 qv2ray
     #   yakuake # kde 桌面
     # mu isync msmtp w3m appimage-run  
     # steam-run
     # charles cutter winetricks
     # digikam gimp inkscape synfigstudio natron scribus 不好使，删 edraw photoflare

     tdesktop texmacs firefox qtcreator onlyoffice-bin  # tor-browser-bundle-bin rstudio
     dbeaver # bcompare zotero
     goldendict qv2ray 
     jetbrains_x.idea-ultimate jetbrains_x.rider android-studio jetbrains_x.clion 

     vscode 
     opencv convmv
     jpegoptim # Optimize JPEG files
     

     podman runc conmon slirp4netns fuse-overlayfs

     electron
     cmake gcc ccls
     llvmPackages_latest.llvm llvmPackages_latest.lld llvmPackages_latest.lldb 
     llvmPackages_latest.clang llvmPackages_latest.libclang 
     pkg-config gitFull mercurial darcs nix-index patchelf jdk11 jdk go lua_x racket chez lispPackages.quicklisp sbcl
     mono dotnet-sdk nodejs yarn perl flutter rustup autoconf julia-bin 


     # haskellPackages.ghcup # 使用 curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh 安装
     # (python3.withPackages(ps: with ps; [ pip urllib3 ansible spyder jupyter sip pyqt5 pyqtwebengine epc lxml pysocks pymupdf]))
     # boost_x.dev
     # libmysqlclient_315

     cmake-language-server

     python-with-my-packages
     streamlink you-get youtube-dl

     
     libfakeXinerama libselinux libmysqlconnectorcpp libmysqlclient 

     wofi wlogout swaylock kanshi grim mako wlsunset swayidle slurp xdg-desktop-portal-wlr 
     wayfire wcm
     kitty zathura ranger swappy 
     drawing 
     pcmanfm spaceFM
     nemiver cutter_x
     # xfce.thunar xfce.thunar-archive-plugin 
     #  waylandPkgs.waybar waylandPkgs.swaybg wl-clipboard
  ];

  services.greetd = {
    enable = true;
    vt = 7;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -t --remember --cmd ${pkgs.wayfire}/bin/wayfire"; # --config /etc/greetd/wayfire.ini
        user = "prehonor";
      };
    };
  };


  services.udev.packages = with pkgs; [
    android-udev-rules
    # gnome.gnome-settings-daemon # gnome 桌面
  ];
  services.dbus.packages = with pkgs; [ gnome2.GConf ]; # Running ancient gnome applications
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
   

  virtualisation = {
      docker.enable = false;
      virtualbox.host.enable = true;
      # waydroid.enable = true;
      # lxd.enable = true;
      # anbox.enable = true;
  };

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
  nix.useSandbox = true; 
  networking = {
    timeServers =  [ "ntp.aliyun.com" "time1.cloud.tencent.com" "cn.pool.ntp.org" "asia.pool.ntp.org" "time.windows.com" ]; # options.networking.timeServers.default ++ [ "ntp.example.com" ];
    hostName = "prehonor";
    networkmanager.enable = true;
    dhcpcd.enable = false;
 #   useDHCP = false;
 #   interfaces.enp3s0.useDHCP = true;
     nameservers = [ "::1" "127.0.0.1" ];
    # resolvconf.useLocalResolver = true;
    # If using dhcpcd:
    # dhcpcd.extraConfig = "nohook resolv.conf";
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
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;


  # Enable the X11 windowing system.


  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "euro";
    xkbOptions = "esperanto:qwerty";# "caps:capslock,grp:win_space_toggle"; # win+Space switch layout
    xkbModel = "pc105";

    videoDrivers = [ "nvidia" ]; # nouveau 

    displayManager = {

      startx.enable = true; 
      # gnome 环境
    /*
      gdm = {
        enable = true;
        wayland = false;
      };
    */
    
    };

    desktopManager = {
      # gnome.enable = true; # gnome 环境
      xterm.enable = false; #  没效果   
    };

  };
  hardware.nvidia.modesetting.enable = true; # wayland 环境


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prehonor = {
     home = "/home/prehonor";
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "power" "users" "pulseaudio" "mysql" "wireshark" ]; # Enable ‘sudo’ for the user.
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
environment.etc = {
  "containers/policy.json" = {
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

    "containers/registries.conf" = {
      mode="0644";
      text=''
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
    /*
    "NetworkManager/dnsmasq.d/foo".text =  ''
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
      interface=enp3s0
      listen-address=::1,127.0.0.1
      cache-size=966
      log-queries
      log-facility=/var/log/dnsmasq.log
      # conf-dir=/etc/nixos/dnsmasq.d/,*.conf
    '';
    */
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05";

}

