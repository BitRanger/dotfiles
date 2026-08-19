{
  bit.apps.xteink = {
    nixos = { pkgs, ... }: {
      services.udev.packages = [ pkgs.platformio-core.udev ];
      services.udev.extraRules = ''
        SUBSYSTEM=="tty", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0660", TAG+="uaccess"
      '';
    };
  };
}
