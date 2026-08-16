{ den, bit, ... }:
{
  # host aspect
  den.aspects.mars = {
    includes = [
      den.batteries.host-aspects # VERY IMPORTANT, necessary for host homeManager aspects to be projected onto users

      den.aspects.roles.base
      den.aspects.roles.workstation
      den.aspects.roles.dev
      bit.hardware.intel-mac
      #den.aspects.roles.gaming
    ];
    # host NixOS configuration
    nixos =
      { pkgs, ... }:
      {
        #environment.systemPackages = [ pkgs.hello ];
	networking.hostName = "mars";
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        #home.packages = [ pkgs.vim ];
      };
  };
}
