{ inputs, ... }:
{
  flake-file.inputs = {
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    papirus-dynamic = {
      url = "gitlab:paridhips/papirus-dynamic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  bit.desktop.stylix = {
    nixos = { pkgs, ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = true;
        autoEnable = true;
        image = ../../../assets/wallpapers/default.jpg;
        #base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
        opacity.terminal = 0.8;
        opacity.applications = 0.1;
        cursor = {
          name = "Bibata-Modern-Classic";
          package = pkgs.bibata-cursors;
          size = 24;
        };
        fonts = {
          serif = {
            package = pkgs.alegreya;
            name = "Alegreya Serif";
          };
          #sansSerif = {
          #  package = pkgs.alegreya;
          #  name = "Alegreya Sans";
          #};
          sansSerif = {
            package = pkgs.nerd-fonts.ubuntu;
            name = "Ubuntu";
          };
          monospace = {
            package = pkgs.nerd-fonts.iosevka;
            name = "Iosevka Nerd Font";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
        homeManagerIntegration.autoImport = false;
        homeManagerIntegration.followSystem = false;
      };
    };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [
          inputs.stylix.homeModules.stylix
          inputs.papirus-dynamic.homeManagerModules.default
        ];
        stylix = {
          enable = true;
          autoEnable = true;
          image = ../../../assets/wallpapers/default.jpg;
          polarity = "dark";
          base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
          opacity.terminal = 0.8;
          opacity.applications = 0.8;
          cursor = {
            name = "Bibata-Modern-Classic";
            package = pkgs.bibata-cursors;
            size = 24;
          };
          fonts = {
            serif = {
              package = pkgs.alegreya;
              name = "Alegreya Serif";
            };
            #sansSerif = {
            #  package = pkgs.alegreya;
            #  name = "Alegreya Sans";
            #};
            sansSerif = {
              package = pkgs.nerd-fonts.ubuntu;
              name = "Ubuntu";
            };
            monospace = {
              package = pkgs.nerd-fonts.iosevka;
              name = "Iosevka Nerd Font";
            };
            emoji = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
          };
        };
        programs.noctalia = {
          settings = {
            wallpaper.directory = ../../../assets/wallpapers;
            #wallpaper.default.path = ./wallpaper.jpg;
            #wallpaper.last.path = ./wallpaper.jpg;
          };
        };

      };
  };
}
