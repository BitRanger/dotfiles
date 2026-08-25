{ inputs, ... }:
{
  flake-file.inputs.nix-doom-emacs-unstraightened = {
    url = "github:marienz/nix-doom-emacs-unstraightened";
    inputs.nixpkgs.follows = ""; # Optional, to download less. Neither the module nor the overlay uses this input.
  };
  flake-file.nixConfig = {
    extra-substituters = [
      "https://doom-emacs-unstraightened.cachix.org"
    ];
    extra-trusted-public-keys = [
      "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
    ];
  };
  bit.dev.doom-emacs = {
    homeManager = { config, pkgs, ... }: {
      imports = [
        inputs.nix-doom-emacs-unstraightened.homeModule
      ];
      programs.doom-emacs = {
        enable = true;
        emacs = pkgs.emacs-pgtk;
        doomDir = ./doom;
        tangleArgs = "--all config.org";
        extraPackages =
          epkgs:
          let
            extraPackages = config.programs.emacs.extraPackages epkgs;
          in
          extraPackages
          ++ [
            (epkgs.trivialBuild {
              pname = "stylix-theme";
              # add config from doom's ui/doom module
              src = pkgs.writeText "stylix-theme.el" config.programs.emacs.extraConfig;
              version = "0.1.0";
              packageRequires = extraPackages;
            })
          ];
        provideEmacs = true; # set to false to create a specific doom-emacs binary separate from normal emacs
      };
      services.emacs = {
        enable = true;
        #package = pkgs.emacs-pgtk; # this overrides the emacs daemon to set vanilla emacs, by default, doom-emacs sets itself to this variable
        client.enable = true;
        defaultEditor = true;
        #socketActivation.enable = true; #lazy activation, only starts on first launch
        #startWithUserSession = "graphical" # starts with graphical session target
      };
      home.packages = [
        pkgs.gcc
        pkgs.ispell
      ];
    };
  };
}
