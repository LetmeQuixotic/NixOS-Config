{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    # Enable shell integrations (especially for fish)
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      
      # Overall format, modern two-line compact design
      format = ''
        [╭─](dimmed white) $os$username[@](dimmed white)$hostname$directory$git_branch$git_status
        [╰─](dimmed white)$character
      '';

      # OS indicator (show NixOS icon)
      os = {
        disabled = false;
        symbols = {
          NixOS = " ";
        };
      };

      # Username indicator
      username = {
        style_user = "bold blue";
        style_root = "bold red";
        format = "[$user]($style)";
        show_always = true; # Always show, even if not SSH/root
      };

      # Hostname indicator
      hostname = {
        ssh_only = false; # Always show, even if not SSH
        format = "[$hostname](bold purple) ";
      };

      # Directory indicator styling
      directory = {
        style = "bold cyan";
        read_only = " 󰌾";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      # Git branch indicator
      git_branch = {
        symbol = " ";
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
      };

      # Git status indicator
      git_status = {
        style = "bold red";
        format = "([$all_status$ahead_behind]($style) )";
      };

      # Input prompt styling (❯ arrow)
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold yellow)";
      };

      # Command duration indicator (shown for long-running commands)
      cmd_duration = {
        min_time = 2000;
        format = "[$duration]($style) ";
        style = "bold yellow";
      };
      
      # Nix-shell environment indicator
      nix_shell = {
        symbol = " ";
        format = "via [$symbol$state]($style) ";
        style = "bold blue";
      };
    };
  };
}
