{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];  # add hardware configuration

  # boot loader config
  boot.loader.systemd-boot.enable = true;  # Enable systemd-boot
  boot.loader.efi.canTouchEfiVariables = false;  # Enable modify EFI variables，support UEFI
  boot.loader.systemd-boot.configurationLimit = 2;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ntfs" ];
  # boot.kernelParams = [];
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "0";
    
    # WLR_DRM_DEVICES = "/dev/dri/card0";
    GIO_EXTRA_MODULES = [ "${pkgs.gvfs}/lib/gio/modules" ];
   
    # icon fix
    XDG_DATA_DIRS = [
      "${pkgs.adwaita-icon-theme}/share"
      "${pkgs.hicolor-icon-theme}/share"
    ];
    /*
    # Nvidia variable
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    */
  };
  # boot.blacklistedKernelModules = [ "amdgpu" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  
  # network config
  networking.hostName = "nixos";  # set machine name
  networking.networkmanager.enable = true;  # Enable NetworkManager ,support wireless network

  # Time Zone
  time.timeZone = "Asia/Shanghai"; 
  
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  # Enable Fcitx5 Input Method for Chinese support
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      qt6Packages.fcitx5-qt # Proper QT support for fcitx5 (now qt6 based)
    ];
  };
  
  # Font pkgs
  fonts.packages = with pkgs; [
    corefonts       # microsoft
    jetbrains-mono  # JetBrains Mono
    fira-code       # Fira Code
    noto-fonts      # Noto
    sarasa-gothic
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    wqy_zenhei
    source-code-pro 
  ];

  # Nixpkgs manage config 
  nix.settings = {
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"  # add sjtu mirror
      "https://mirror.nju.edu.cn/nix-channels/store" # add nju mirror
      "https://cache.nixos.org/"  # default official cache
    ];
    experimental-features = [ "nix-command" "flakes" ];  # Enable experimental fetures：nix command enhance & flakes support
  };

  # Enable the Niri Wayland Compositor module
  # Make sure you're using a version/channel of Nixpkgs that includes 'niri'
  programs.niri.enable = true;

  # Enable Wayland-Native DM
  services.xserver.enable = true;
  hardware.graphics.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };

    theme = "catppuccin-mocha-mauve";
    settings = {
      General = {
	
      };
    };
  }; 

  # keyboard layout
  services.xserver.xkb.layout = "us";  # set X11 keyboard to us

  # Print Services
  services.printing.enable = true;  # Enable CUPS Print System

  # Audio Config
  services.pulseaudio.enable = false;  
  security.rtkit.enable = true;  
  services.pipewire = {
    enable = true;  
    alsa.enable = true; 
    alsa.support32Bit = true;
    pulse.enable = true;  
  };

  # Windows Disk
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.udisks2.filesystem-mount-system" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';  

  # Define a user account.
  # Make sure to set a password with ‘passwd’ after installation.
  users.users.qimel = {
    isNormalUser = true;
    description = "Qimel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "docker" ];
    shell = pkgs.fish; # Switch to Fish shell
    initialPassword = "Elysia1111";
  };

  # Enable Fish shell
  programs.fish.enable = true;
  
 
  # Disable nvidia 32 bit
  hardware.graphics.enable32Bit = true;

  # Application Configuration
  # programs.firefox.enable = true;  # Enable FireFox browser
  # Flatpak
  services.flatpak.enable = true;

  # Nixpkgs Config
  nixpkgs.config.allowUnfree = true;  # Enable non-free pkgs;

  #Enable Nvidia driver
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; 
    open = true;
    dynamicBoost.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  
    prime = {
      offload  = {
        enable = true;
        enableOffloadCmd = true;
      };
      # use lspci to fetch information
      amdgpuBusId = "PCI:5:0:0"; 
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  networking.firewall.allowedTCPPorts = [ 11434 2017 ];

  xdg.portal = {
    enable = true;
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = [ "gtk" ];
  };

  # NixVim
  programs.nixvim = {
    enable = true;
    imports = [ ./nixvim.nix ];
  };

  # System Packages List
  environment.systemPackages = with pkgs; [
    nil
    vim # text editor
    wget  # file downloader
    kitty  # console
    yazi #tui file mamager
    git
    xwayland-satellite # x11 applications support
    catppuccin-sddm
   # Dev Environment
    vscode
    # Cpp Dev
    gcc
    clang
    cmake
    gnumake
    gdb
    valgrind
    # Python Dev
    python315
    # Csharp Dev
    dotnetCorePackages.sdk_10_0
    # Golang Dev
    go
   # file manager
    nautilus
    ntfs3g
    exfat
    gvfs
    udisks2
    file-roller
    gnome-themes-extra
    adwaita-icon-theme
    hicolor-icon-theme
   # screenshot
    grim
    slurp    
    satty  
    wl-clipboard
   # icon fix
    hicolor-icon-theme
    adwaita-icon-theme
    glib
  ];
  
  # Enable nix-ld
  programs.nix-ld = {
    enable = true;
    # 可选：添加一些常用的库，以防插件依赖它们
    libraries = with pkgs; [
      glibc
      zlib
      openssl
      icu
      libkrb5
      libgcc
      stdenv.cc.cc.lib
      stdenv.cc.cc.lib
      glib
      gtk3
      gtk4
      pango
      cairo
      gdk-pixbuf
      harfbuzz
      freetype
      fontconfig
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXrandr
      libXrender
      libXtst
      libxcb
      libxkbcommon
      dbus
      expat
      libGL
      libglvnd
      mesa
      openssl
      zlib
      nss
      nspr
      alsa-lib
      cups
      systemd
      libdrm
      wayland
      libXi
      atk
      at-spi2-atk
      at-spi2-core
      libuuid
      libcap
      shadow
    ];
  };

  #Enable AppImage
  programs.appimage.enable = true;

  #Enable gvfs udisks2
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Enable cloudfalre warp services
  services.cloudflare-warp = {
    enable = true;
  };
  # Enable v2rayA
  services.v2raya.enable = true;
  # networking.firewall.allowedTCPPorts = [ 2017 ];

  # mihomo
  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    tunMode = true; # Enable tun mode
  };

  systemd.services.v2raya = {
    serviceConfig = {
      # 赋予网络管理能力
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_NET_RAW" ];
      # 确保以 root 运行（默认就是，但显式声明更安全）
      User = "root";
    };
  };
  boot.kernelModules = [ "tun" ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  networking.firewall.checkReversePath = "loose";
  
  # Service Config
  services.openssh.enable = true;  # Enable OpenSSH Server

  # System Version
  system.stateVersion = "25.05";  # Specify NixOS version (Keep first install)

}

