{ inputs, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  bit.desktop.stylix = { pkgs, ... }: {
    nixos = {
      #imports = [ inputs.stylix.nixosModules.stylix ];
      stylix = {
        enable = "trute";
        autoEnable = false;
        image = ./wallpaper.jpg;
        #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
        #imports = [ inputs.stylix.homeModules.stylix ];
        stylix = {
          enable = true;
          autoEnable = false;
          image = ./wallpaper.jpg;
          #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
      };
  };
}
