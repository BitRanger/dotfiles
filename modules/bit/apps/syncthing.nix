{ den, ... }:
{
  bit.apps.syncthing = {
    homeManager =
      {
        host,
        config,
        lib,
        ...
      }:
      let
        # flatten den.hosts.<system>.<hostname> -> <hostname> across all systems
        allHosts = lib.concatMapAttrs (_system: hosts: hosts) den.hosts;
        currentHost = host.name;
        nixHosts = lib.mapAttrs (_: host: { id = host.syncthing.id; }) (
            name: host: name != currentHost && host ? syncthing && host.syncthing ? id
          ) allHosts;
        syncthingHosts = nixHosts // {
          pixel = {
            id = "7NNBLBE-MHC3Q7J-FA7C3SJ-4KY2ZMC-YRTD6S7-ONHDXE5-2ZZ6U7R-ZKY3FQW";
          };
        };
      in
      {
        sops.secrets = {
          "syncthing/${host.name}/key" = { };
          "syncthing/${host.name}/cert" = { };
          "syncthing/${host.name}/guiPassword" = { };
        };
        assertions = [
          #{
          #  assertion =
          #    syncthingHosts.saturn.id == "FTF6Q56-CZWDNUO-NE7O2D5-HZLAF6O-XD74LLA-HFX7AUV-WS5ZVJ7-P5BM7QX";
          #  message = "Syncthing ID of saturn is wrong";
          #}
        ];
        services.syncthing = {
          enable = true;
          key = config.sops.secrets."syncthing/${host.name}/key".path;
          cert = config.sops.secrets."syncthing/${host.name}/cert".path;
          guiCredentials = {
            username = "admin";
            passwordFile = config.sops.secrets."syncthing/${host.name}/guiPassword".path;
          };
          overrideDevices = true;
          overrideFolders = true;
          settings = {
            #devices = syncthingHosts;
            options = {
              #relaysEnabled = false;
              #globalAnnounceEnabled = false;
              #localAnnounceEnabled = true;
              #natEnabled = false;
              #urAccepted = -1;
            };

            folders.Syncthing = {
              path = "${config.home.homeDirectory}/Syncthing";
              #devices = builtins.attrNames syncthingHosts;
              versioning = {
                type = "staggered";
                params = {
                  cleanInterval = "3600";
                  maxAge = "2592000";
                };
              };
            };
          };
        };
      };
  };
}
