{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];  # 导入硬件配置模块，用于加载硬件扫描结果

  # 引导加载器配置
  boot.loader.systemd-boot.enable = true;  # 启用systemd-boot引导程序
  boot.loader.efi.canTouchEfiVariables = true;  # 允许修改EFI变量，支持UEFI引导

  # Enable VirtualBox Guest Additions for better display/mouse support
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;

  # 网络配置
  networking.hostName = "nixos";  # 设置主机名
  networking.networkmanager.enable = true;  # 启用NetworkManager，支持无线网络管理

  # 时区设置
  time.timeZone = "Asia/Shanghai";  # 设置时区为上海（中国标准时间）
  
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
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      qt6Packages.fcitx5-qt # Proper QT support for fcitx5 (now qt6 based)
    ];
  };

  # Nix包管理器配置
  nix.settings = {
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=10"  # 添加中科大镜像源
      #"https://cache.nixos.org/"  # 默认官方缓存
    ];
    experimental-features = [ "nix-command" "flakes" ];  # 启用实验性功能：nix命令增强和flakes支持
  };

  # Enable the Niri Wayland Compositor module
  # Make sure you're using a version/channel of Nixpkgs that includes 'niri'
  programs.niri.enable = true;
  # Enable SDDM
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # 键盘布局配置
  services.xserver.xkb.layout = "us";  # 设置X11键盘布局为美式

  # 打印服务
  services.printing.enable = true;  # 启用CUPS打印系统

  # 音频配置
  services.pulseaudio.enable = false;  # 禁用PulseAudio（使用PipeWire替代）
  security.rtkit.enable = true;  # 启用RTKit实时内核支持（用于音频权限）
  services.pipewire = {
    enable = true;  # 启用PipeWire多媒体框架
    alsa.enable = true;  # 启用PipeWire的ALSA兼容层
    alsa.support32Bit = true;  # 支持32位ALSA应用
    pulse.enable = true;  # 启用PulseAudio兼容层
  };

  # Define a user account.
  # Make sure to set a password with ‘passwd’ after installation.
  users.users.qimel = {
    isNormalUser = true;
    description = "Qimel";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" "input" "docker" ];
    shell = pkgs.fish; # Switch to Fish shell
  };

  # Enable Fish shell
  programs.fish.enable = true;

  # 应用程序配置
  programs.firefox.enable = true;  # 启用Firefox浏览器（系统级安装）
  # services.flatpak.enable = true;  # 启用Flatpak包管理器，支持第三方应用

  # Nixpkgs配置
  nixpkgs.config.allowUnfree = true;  # 允许安装非自由软件包

  # 系统级包列表
  environment.systemPackages = with pkgs; [
    vim  # 文本编辑器
    wget  # 文件下载工具
    alacritty  # 终端模拟器
  ];

  # 服务配置
  services.openssh.enable = true;  # 启用OpenSSH服务器，支持远程登录

  # 系统版本
  system.stateVersion = "25.05";  # 指定NixOS状态版本（保持为首次安装版本）
}
