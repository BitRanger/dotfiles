{
  bit.messaging.whatsapp = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.karere ];
      };
  };
}
