{ inputs, ... }: {
  inputs.flake-file = {
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # sets the hash to the latest build stored by cachix
      #url = "github:noctalia-dev/noctalia";
      #inputs.nixpkgs.follows = "nixpkgs"; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
    };
    nixConfig = {
      extra-substituters = [
        "https://noctalia.cachix.org"
        "https://niri.cachix.org"
      ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
    };
  };
  bit.desktop.niri = {
    nixos = {
      programs.noctalia = {
        #enable = true;
        recommendedServices.enable = true;
        #systemd.enable = true;
        #systemd.target = "niri-session.target";
      };
    };
    homeManager = { pkgs, ... }: {
      imports = [
        inputs.noctalia.homeModules.default
      ];
      stylix.targets.noctalia.enable = true;
      programs.noctalia = {
        enable = true;
        systemd.enable = true;
      };
      programs.niri = {

      };
    };
  };
}
