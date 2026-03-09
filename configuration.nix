# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
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
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-nord
      libsForQt5.fcitx5-qt # Proper QT support
    ];
  };
  
  # Set environment variables for Input Method
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";       # Hint Electron apps to use Wayland
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # Enable the Niri Wayland Compositor module
  # Make sure you're using a version/channel of Nixpkgs that includes 'niri' 
  # (e.g., nixos-unstable or 24.05+ with overrides).
  programs.niri.enable = true;

  # TIP: Niri needs a config file to work (keybindings!). 
  # We place a default one in /etc/niri/config.kdl so you aren't stuck on a blank screen.
  # You should copy this to ~/.config/niri/config.kdl and edit it later.
  environment.etc."niri/config.kdl".text = ''
    // Basic Niri Config for Migration
    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    layout {
        gaps 16
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }
    }

    binds {
        // Keys
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+T { spawn "alacritty"; }
        Mod+D { spawn "fuzzel"; }
        Mod+Q { close-window; }
        
        // Quit Niri
        Mod+Shift+E { quit; }

        // Window management
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }

        Mod+Home { focus-column-first; }
        Mod+End  { focus-column-last; }
        
        // Move windows
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Right { move-column-right; }
    }
  '';

  # Enable OpenGL/Graphics (Required for Wayland)
  hardware.graphics.enable = true;

  # Display Manager and Session Setup
  # We use Greetd with tuigreet for a minimal, text-based login that launches graphical sessions.
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # The command to start the session.
        # Niri session is usually started by just running `niri-session`
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Define a user account.
  users.users.user = {
    isNormalUser = true;
    description = "User";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  # Fonts configuration for UI and Terminal
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    sarasa-gothic
    wqy_zenhei
    wqy_microhei
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
    nerdfonts 
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
  # Core Utils
    wget
    curl
    git
    vim # Text editor for config files
    
  # Archiving tools
    p7zip
    unzip
    zip

  # Wayland/Niri specific tools
    # Important: Niri is just a compositor. You need these for a full desktop experience.
    fuzzel          # Application Launcher (Wayland native)
    waybar          # Status bar
    mako            # Notification daemon
    swaybg          # Wallpaper tool
    wl-clipboard    # Clipboard support
    grim            # Screenshot tool
    slurp           # Region selector for screenshots
    
  # Terminal (Replacing Konsole with a fast, GPU-accelerated terminal)
    alacritty

  # File Manager (Replacing Dolphin with something lighter)
    thunar
    thunar-archive-plugin
    xfce.tumbler    # Thumbnail support for Thunar

  # Development tools
    binutils
    gcc
    gnumake
    
  # PDF/Document tools
    zathura         # Minimal, keyboard-driven PDF viewer
    
  # System Monitoring
    htop
    btop
  ];
  
  # XDG Portal Integration (Essential for Flatpaks, screen sharing, file dialogs)
  xdg.portal = {
    enable = true;
    wlr.enable = true; # Use wlroots portal implementation (works well with niri)
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # This value reflects the NixOS release version.
  system.stateVersion = "24.05"; 

}
