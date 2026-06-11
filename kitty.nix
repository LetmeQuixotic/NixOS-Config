{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = false;

    # Modern ligatures and coding font
    font = {
      name = "Source Code Pro";
      size = 16;
    };

    # Set theme to Ayu Mirage
    themeFile = "ayu_mirage";

    # Use settings block for standard configuration generation
    settings = {
      # Fix fish shell overriding the block cursor
      # shell_integration = "no-rc no-cursor";

      # Window padding and borderless decorations
      hide_window_decorations = "yes";
      confirm_os_window_close = "0";
      remember_window_size = "yes";

      # Modern cursor settings (beam shape with trail)
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_trail = "3";
      cursor_trail_decay = "0.1 0.4";

      /*
      # Tab bar styling (Powerline slanted style)
      tab_bar_edge = "bottom";
      tab_bar_min_tabs = "1";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      */

      # Ayu Mirage inspired tab bar colors (overrides theme defaults)
      active_tab_foreground = "#212733";
      active_tab_background = "#FFCC66";
      inactive_tab_foreground = "#707A8C";
      inactive_tab_background = "#212733";

      # Special rendering settings
      force_ltr_rendering = "yes";

      # Paste no limit
      paste_actions = "no-op";
    };

    extraConfig = ''
      # Enable ligatures, perfect for FiraCode
      disable_ligatures never

      # Custom tab title template (shows icon and window count)
      tab_title_template " {index}: {title}{'  {}'.format(num_windows) if num_windows > 1 else \'\'}"

      # Allow other programs (like Neovim) to interact with Kitty
      allow_remote_control yes
      listen_on unix:@mykitty
    '';
  };
}

