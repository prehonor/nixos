# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
 
{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
 nix = {
  binaryCaches = [  
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"  
    "https://cache.nixos.org/" 
    "https://nix-community.cachix.org"
    "https://mirrors.bfsu.edu.cn/nix-channels/store" 
  ];
  binaryCachePublicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  };

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
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

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ libpinyin cloudpinyin ];
  };


  console = {
     font = "Hack-11";
     keyMap = "dvorak-programmer";
     packages = with pkgs; [ hack-font kbd ];
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      wqy_microhei
      wqy_zenhei
      symbola
     # ttf-wps-fonts
    ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  
  programs.bash.enableCompletion = true;  

  nix.extraOptions = ''
      experimental-features = nix-command
   '';
   # this is required until nix 2.4 is released
  nix.package = pkgs.nixUnstable;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config = {
    # Allow proprietary packages
    allowUnfree = true;


    # Create an alias for the unstable channel

   # packageOverrides = pkgs: {
   #   unstable = import <nixos-unstable> { # pass the nixpkgs config to the unstable alias # to ensure `allowUnfree = true;` is propagated:
   #     config = config.nixpkgs.config;
   #   };
   # };
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
     sudo parted finger_bsd pciutils file binutils-unwrapped bind bashInteractive.dev getconf fontconfig # steam-run
     graphviz dos2unix grpc dpkg unzip zip tmux ntfs3g usbutils lsof unrar # appimage-run # p7zip

     wget tsocks curl wireshark netcat tcpdump
     mcrypt thc-hydra nmap-graphical john crunch
     ghidra-bin nasm fasm wineWowPackages.stable  # charles cutter winetricks
     

    # v2ray #github 手工维护 qv2ray
    # ventoy-bin

     fcitx5 fcitx5-configtool
     ark yakuake okular neovim xournalpp sublime4 # krita sigil #  zathura vlc blender alacritty
     tdesktop lyx google-chrome qtcreator rstudio onlyoffice-bin # tor-browser-bundle-bin
     dbeaver android-studio atom # bcompare aria  
     goldendict qv2ray 

     jetbrains.idea-ultimate jetbrains_x.clion #  jetbrains.rider jetbrains.webstorm jetbrains.pycharm-professional
    # vscode
     nmap

     # steam genymotion
      flameshot peek gimp libsForQt5.gwenview  opencv
      jpegoptim
      # digikam gimp   inkscape   synfigstudio  natron  scribus 不好使，删   edraw

     podman runc conmon slirp4netns fuse-overlayfs

     electron
     qt5.full libsForQt5.qt3d libsForQt5.kproperty libsForQt5.qt5.qtsensors libsForQt5.syntax-highlighting 
     libsForQt5.qt5.qtgamepad libsForQt5.qt5.qtserialbus
     cmake gcc gcc11 llvm_x lld_x lldb_x clang_x libclang_x pkg-config gitFull nix-index patchelf jdk11 jdk go lua_x chez
     mono dotnet-sdk nodejs_x yarn perl flutter rustup autoconf julia-bin 
     # spyder
     (python3.withPackages(ps: with ps; [ pip urllib3 ]))
     # boost_x.dev
     libfakeXinerama libselinux libmysqlconnectorcpp
     libmysqlclient #libmysqlclient_315
  ];


  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
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
  };
  # services.ntp.enable = true;
  # services.ntp.extraConfig = " NTPD_OPTS='-4 -g' \n  SYNC_HWCLOCK=yes ";
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.1:5353" "[::1]:5353" ];
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
  
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  programs.wireshark.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "nvidia" ];
    displayManager.sddm = { 
      enable = true;
    };
    desktopManager.plasma5.enable = true;
  };

  # services.xserver.xkbOptions = "eurosign:e";

  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prehonor = {
     home = "/home/prehonor";
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "power" "users" "pulseaudio" "mysql" "wireshark" ]; # Enable ‘sudo’ for the user.
     subUidRanges = [{ startUid = 100000; count = 65536; }];
     subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  services.netdata.enable = true;
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

