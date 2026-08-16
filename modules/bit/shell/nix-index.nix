{
  bit.shell.nix-index = {
    homeManager =
      { pkgs, ... }:
      {
        programs.nix-index = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    nixos = {
      programs.command-not-found.enable = false; # honestly have no idea if i need this or not, according to https://github.com/bennofs/nix-index/issues/126 and https://github.com/nix-community/home-manager/blob/release-26.05/modules/programs/nix-index.nix i shouldn't so this is just in case
    };
  };
}
