_: {
  bit.gaming.steam = {
    nixos =
      { pkgs, ... }:
      {
        programs.steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
        programs.gamemode.enable = true;
        #environment.systemPackages = [ pkgs.game-devices-udev-rules ];

      };
  };
}
