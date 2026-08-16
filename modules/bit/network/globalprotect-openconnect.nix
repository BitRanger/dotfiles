{ inputs, ... }:
{
  flake-file.inputs.globalprotect-openconnect.url = "github:yuezk/GlobalProtect-openconnect";
  bit.network.globalprotect-openconnect = {
    nixos =
      { host, ... }:
      {
        services.ayatana-indicators.enable = true; # optional??? not sure about this, it's an appindicator package i think
        environment.systemPackages = [
          inputs.globalprotect-openconnect.packages.${host.system}.default
        ];
      };
  };
}
