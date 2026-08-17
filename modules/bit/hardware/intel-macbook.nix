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
        nixpkgs.config.allowInsecurePredicate =
          pkg:
          builtins.elem (lib.getName pkg) [
            "broadcom-sta" # aka "wl"
          ];
        zramSwap.enable = true;
        hardware.facetimehd.enable = true;
      };
  };
}
