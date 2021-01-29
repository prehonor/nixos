# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  # nix.binaryCaches = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  # nix.binaryCaches = [ "https://mirrors.bfsu.edu.cn/nix-channels/store" ];

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
   
  networking.proxy.default = "socks5://127.0.0.1:1080/";
#  networking.proxy.noProxy = "127.0.0.1,localhost,mirrors.tuna.tsinghua.edu.cn,download.jetbrains.com,prehonor-generic.pkg.coding.net";

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
     packages = with pkgs; [ hack-font kbdKeymaps.dvp ];
  };

  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
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
 # vscode-with-extensions = pkgs.vscode-with-extensions.override {
 #      ms-vscode.cpptools
 # };
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
     sudo finger_bsd pciutils file binutils-unwrapped bind bashInteractive getconf fontconfig # steam-run
     graphviz dos2unix grpc dpkg unzip tmux ntfs3g usbutils lsof unrar # appimage-run # p7zip

     wget tsocks curl wireshark charles ghidra-bin radare2 radare2-cutter nasm wineWowPackages.stable # playonlinux
     parted
    # unstable.v2ray
    # v2ray #github 手工维护
    # qv2ray
     fcitx fcitx-configtool
     ark yakuake okular vim notepadqq masterpdfeditor sublime3 # sigil # zathura
     tdesktop lyx google-chrome vlc qtcreator rstudio onlyoffice #  wpsoffice
     dbeaver bcompare vscode atom # vscode-with-extensions
     goldendict  # gitkraken 
    # jetbrains.prpycharm-professional jetbrains.prwebstorm jetbrains.pridea-ultimate
    # jetbrains.prdatagrip  #  pencil
     jetbrains.pycharm-professional 
     jetbrains.webstorm 
     jetbrains.idea-ultimate
     jetbrains.rider
     android-studio
     #steam
     blender flameshot peek digikam # gimp   inkscape   synfigstudio # natron #scribus 不好使，删 
    # genymotion
    # xmind
     podman runc conmon slirp4netns fuse-overlayfs
    # mathematica # 手动安装
     qt5.full cmake gcc gdb llvm clang pkg-config gitFull nix-index patchelf jdk11 jdk go lua5_3 mono nodejs-12_x yarn perl flutter # julia # rust  nodePackages.yarn
     (python3.withPackages(ps: with ps; [ pip urllib3 ]))
     (pypy3.withPackages(ps: with ps; [ pip urllib3 ]))
     boost172_my.dev
     libfakeXinerama libselinux libmysqlclient
  ];


  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
  services.mysql = {
    user = "root";
    enable = true;
    package = pkgs.mysql;
  configFile = pkgs.writeText "my.cnf" ''
  	[mysqld]
      # basedir=/home/prehonor/Public/Program/mysql
      # datadir=/ah/prehonor/Programmers/mysql/data0
      # socket=/tmp/mysql.sock
      user=root
      port=3306
      character_set_server=utf8mb4
      # Disabling symbolic-links is recommended to prevent assorted security risks
      symbolic-links=0
        # skip-grant-tables
      [mysqld_safe]
      # log-error=/ah/prehonor/Programmers/mysql/data0/error.log
      # pid-file=/ah/prehonor/Programmers/mysql/data0/mysqld.pid
      # tmpdir=/tmp
   '';
  };
   

  # virtualisation.anbox.enable = true;
  virtualisation.docker.enable = false;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];
 
  security.sudo = {
     enable = true;
     wheelNeedsPassword = false;
  };

  nix.optimise.automatic = true;
  nix.trustedUsers = [ "root" "@wheel" ];
  #  nix.sandboxPaths = [ "/ah" "/gh" "/home" ];
  nix.useSandbox = false; 
  networking = {
    # timeServers =  [ "ntp.example.com" ]; # options.networking.timeServers.default ++ [ "ntp.example.com" ];
    hostName = "prehonor";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces.enp3s0.useDHCP = true;
    nameservers = [ "::1" ];
    resolvconf.useLocalResolver = true;
    # If using dhcpcd:
    dhcpcd.extraConfig = "nohook resolv.conf";
    # If using NetworkManager:
    networkmanager.dns = "dnsmasq";
  };
  services.ntp.enable = true;
  services.ntp.extraConfig = " NTPD_OPTS='-4 -g' \n  SYNC_HWCLOCK=yes ";
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
      # You can choose a specific set of servers from https://github.com/DNSCrypt/dnscrypt-resolvers/blob/master/v2/public-resolvers.md
      server_names = [ "cloudflare" "yandex" "google" ];
      
      fallback_resolvers = ["114.114.114.114:53"];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy2";
  };
  
  services.fstrim = {
    enable = true;
    interval = "tuesday";  
};
  
#  services.flatpak.enable = true;
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
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  
  services.xserver.videoDrivers = [ "nvidia" ];
  
  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm = { 
    enable = true;
  };
  services.xserver.displayManager.autoLogin.user = "prehonor";
  services.xserver.displayManager.autoLogin.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;
  

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.prehonor = {
     home = "/home/prehonor";
     isNormalUser = true;
     extraGroups = [ "wheel" "networkmanager" "docker" "audio" "video" "power" "users" "pulseaudio" "mysql" "wireshark" ]; # Enable ‘sudo’ for the user.
     subUidRanges = [{ startUid = 100000; count = 65536; }];
     subGidRanges = [{ startGid = 100000; count = 65536; }];
  };
  services.netdata.enable = true;
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
  system.stateVersion = "20.09"; # Did you read the comment?

}

