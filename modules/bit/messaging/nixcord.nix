{ inputs, ... }: {
  flake-file.inputs.nixcord = {
    url = "github:4evy/nixcord";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  bit.messaging.nixcord = {
    homeManager = {
      imports = [
        inputs.nixcord.homeModules.nixcord
      ];
      stylix.targets.nixcord = {
        enable = true;
        fonts.enable = true;
      };
      programs.nixcord = {
        enable = true;
        discord.vencord.enable = true;
        config = {
          frameless = true;
        };
      };
    };
  };
}
