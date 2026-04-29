{ config, pkgs, ... }:

{
  # Enable the Podman engine
  virtualisation.podman = {
    enable = true;

    # Create a 'docker' alias for Podman, using it as a drop-in replacement
    dockerCompat = true;

    # Enable DNS resolution between containers (Required for podman-compose)
    defaultNetwork.settings.dns_enabled = true;

    # Configure automatic pruning (Similar to docker system prune)
    # Periodically clean up unused images and containers to save disk space
    autoPrune = {
      enable = true;
      dates = "weekly";
      flags = [ "--all" ];
    };
  };

  # Expose the Docker socket for compatibility with tools like VS Code Dev Containers and Portainer
  virtualisation.podman.dockerSocket.enable = true;

  # Install useful Podman ecosystem tools
  environment.systemPackages = with pkgs; [
    podman-compose  # Compose tool compatible with docker-compose.yml syntax
    podman-tui      # A useful Terminal UI for managing Podman
  ];
}
