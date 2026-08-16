{
  bit.gaming.moza = {
    nixos =
      { pkgs, ... }:
      {
        #boot.kernelPatches = [
        #    {
        #    name = "ffb-patchs";
        #    patch = pkgs.fetchurl {
        #      url = "https://lore.kernel.org/all/20260609160031.493353-1-oleg@makarenk.ooo/raw";
        #      hash = "sha256-ewLiW9cwe7jfJ2dUW9mtB8OKYLdK4a4LIc707kwid38=";
        #    };
        #  }
        #];
        services.udev.extraRules = ''
          SUBSYSTEM=="tty", KERNEL=="ttyACM*", ATTRS{idVendor}=="346e", ACTION=="add", MODE="0666", TAG+="uaccess"
        '';
      };
    provides.to-users = {
      nixos =
        { user, ... }:
        {
          users.users.${user.name}.extraGroups = [
            "uinput" # not sure which of these (if any) is necessary, so adding both for boxflat compat
            "tty"
          ];
        };
      homeManager =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.boxflat
            pkgs.beammp-launcher
          ];
        };
    };
  };
}
