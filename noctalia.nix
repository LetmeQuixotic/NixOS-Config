{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    unzip
    fuzzel
    fastfetch
    # daily used software
    cloudflare-warp
    microsoft-edge
    google-chrome
    popcorntime    
    motrix
    go-musicfox
    obs-studio
    wechat
    hmcl
  ];
}
