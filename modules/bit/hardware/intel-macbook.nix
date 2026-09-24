{
  bit.hardware.intel-mac = {
    nixos =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        boot.kernelPackages = pkgs.linuxPackages;
        boot.initrd.kernelModules = [ "wl" ];
        boot.kernelModules = [
          "kvm-intel"
          "wl"
        ];
        boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
        services.upower.ignoreLid = true; # lid is broken
        programs.steam.enable = true;
        programs.gamescope.enable = true;
        services.flatpak.enable = true;
        nixpkgs.config.allowInsecurePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "broadcom-sta" # aka "wl"
          ];
        zramSwap.enable = true;
        hardware.facetimehd.enable = true;
        hardware.graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-media-driver # For Broadwell (2014) and newer CPUs (iHD driver)
          ];
        };
      };
  };
}
