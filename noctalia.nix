{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    fuzzel
    kitty
    fastfetch
    # other pkgs
    vscode
    microsoft-edge
    google-chrome
  ];
}
