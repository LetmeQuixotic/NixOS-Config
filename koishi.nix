{ config, pkgs, ... }:

{
  # Automatically create a persistent storage directory for Koishi
  systemd.tmpfiles.rules = [
    "d /var/lib/koishi 0755 root root -"
  ];

  # Define the OCI container for Koishi (reusing the existing Podman backend)
  virtualisation.oci-containers = {
    containers."koishi" = {
      image = "koishijs/koishi:latest"; # Official image
      
      environment = {
        TZ = "Asia/Shanghai"; # Set timezone
        NPM_CONFIG_REGISTRY = "https://registry.npmmirror.com"; # Use Taobao NPM mirror to speed up plugin downloads
      };

      volumes = [
        "/var/lib/koishi:/koishi" # Mount volume to save config and plugin data
      ];

      # Use host network so Koishi can easily connect to local Ollama (127.0.0.1:11434) and Napcat
      extraOptions = [ "--network=host" ];
      
      autoStart = true;
    };
  };

  # Open the Koishi WebUI port in the firewall
  networking.firewall.allowedTCPPorts = [ 5140 ];
}

