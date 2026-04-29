{ config, pkgs, ... }: 

let
  source-code-vf = pkgs.stdenvNoCC.mkDerivation {
    pname = "source-code-vf";
    version = "2.042";

    src = pkgs.fetchFromGitHub {
      owner = "adobe-fonts";
      repo = "source-code-pro";
      rev = "d3f1a5962cde503f9409c21e58527611d4a19ef1";
      hash = "sha256-Pl7cuBFtbk9tPv421ejKnKFKdsW6oezMnAGCWKI3OVY=";
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm644 VF/SourceCodeVF-*.ttf -t $out/share/fonts/truetype
      runHook postInstall
    '';
  };
in
{  
  # Home Manager needs username and homeDirectory
  home.username = "qimel";
  home.homeDirectory = "/home/qimel";

  # Point out version of Home-Manager 
  home.stateVersion = "24.05"; 

  # Allow Home-Manager to manage itself
  programs.home-manager.enable = true;

  programs.fish.enable = true;

  imports = [ 
    ./kitty.nix
    ./starship.nix
  ];

  fonts.fontconfig.enable = true;
  home.packages = [ source-code-vf ];

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "Xwayland Satellite";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :12";
      Restart = "on-failure";
      # Java environments variables
      Environment = [ "_JAVA_AWT_WM_NONREPARENTING=1" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Ensure X11 Applications can find DISPLAY
  home.sessionVariables = {
    DISPLAY = ":12";
  };
  
}

