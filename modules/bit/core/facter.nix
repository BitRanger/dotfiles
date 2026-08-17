{
  bit.core.facter =
    { host, ... }:
    {
      nixos = {
        hardware.facter.enable = true;
        hardware.facter.reportPath = builtins.toString ./../../hosts/${host.hostName}/facter.json;
      };
    };
}
