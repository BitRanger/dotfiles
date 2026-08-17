{
  bit.core.nix = {
    nixos = {
      nixpkgs.config.allowUnfree = true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    homeManager = {
      nixpkgs.config.allowUnfree = true;
    };
  };
}
