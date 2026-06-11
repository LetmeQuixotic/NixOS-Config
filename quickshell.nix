{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.quickshell.packages.${system}.default
    unzip
    fuzzel
    fastfetch
    # daily used software
    cloudflare-warp
    microsoft-edge
    google-chrome
    popcorntime 
    # wechat
    motrix
    go-musicfox
    obs-studio
    hmcl
    clash-verge-rev
  ];

  environment.sessionVariables = {
    QSG_RHI_BACKEND = "vulkan";
    QSG_RENDER_LOOP = "basic";
  };
}
