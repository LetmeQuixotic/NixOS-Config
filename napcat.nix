{ config, pkgs, ... }:

{
  # 2. Automatically create persistent directories for Napcat
  systemd.tmpfiles.rules = [
    "d /var/lib/napcat/config 0755 root root -"
    "d /var/lib/napcat/qq 0755 root root -"
  ];

  # 3. Define the OCI container for Napcat
  virtualisation.oci-containers = {
    backend = "podman";
    
    containers."napcat" = {
      image = "mlikiowa/napcat-docker:latest"; # Official docker image
      
      environment = {
        # ACCOUNT = "12345678"; # Optional: your QQ number
      };

      volumes = [
        "/var/lib/napcat/config:/app/napcat/config"
        "/var/lib/napcat/qq:/app/.config/QQ"
      ];

      ports = [
        "3000:3000" # WebUI
        "3001:3001" # API port
        "6099:6099" # Optional additional port per docs
      ];
      
      autoStart = true;
    };
  };

  # 4. Open firewall ports
  networking.firewall.allowedTCPPorts = [ 3000 3001 6099 ];
}

