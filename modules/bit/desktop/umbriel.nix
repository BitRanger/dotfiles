{ inputs, ... }:
{
  flake-file.inputs.umbriel = {
    url = "github:noctalia-dev/umbriel";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  bit.desktop.umbriel = {
    nixos = {pkgs, ...}:{
      imports = [ inputs.umbriel.nixosModules.default ];
      programs.umbriel.enable = true;
      };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [inputs.umbriel.homeModules.default];
	programs.umbriel.enable = true;
      };
  };
}
