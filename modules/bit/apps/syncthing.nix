{
  bit.apps.syncthing = {
    homeManager =
      {
        host,
        config,
        lib,
        ...
      }:
      {
        sops.secrets = {
          "syncthing/${host.name}/key" = { };
          "syncthing/${host.name}/cert" = { };
          "syncthing/${host.name}/guiPassword" = { };
        };
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
            #devices = allDevices;
            options = {
              #relaysEnabled = false;
              #globalAnnounceEnabled = false;
              #localAnnounceEnabled = true;
              #natEnabled = false;
              #urAccepted = -1;
            };

            folders.Syncthing = {
              path = "${config.home.homeDirectory}/Syncthing";
              #devices = builtins.attrNames allDevices;
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
