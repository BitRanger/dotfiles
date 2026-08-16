{ inputs, ... }:
{
  flake-file.inputs.nix-doom-emacs-unstraightened = {
    url = "github:marienz/nix-doom-emacs-unstraightened";
    inputs.nixpkgs.follows = ""; # Optional, to download less. Neither the module nor the overlay uses this input.
  };
  bit.dev.doom-emacs =
    {
      homeManager = {pkgs, ...}:{
        imports = [
          inputs.nix-doom-emacs-unstraightened.homeModule
        ];
        programs.doom-emacs = {
          enable = true;
          emacs = pkgs.emacs-pgtk;
          doomDir = ./doom;
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
      };
    };
}
