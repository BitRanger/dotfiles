{
  bit.core.nix =
    { host, ... }:
    {
      nixos = _: {
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
