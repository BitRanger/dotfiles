{
  bit.dev.arduino-ide = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        pkgs.arduino-ide
      ];
    };
    nixos = {
      services.udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2341", MODE:="0666"
      '';
      #hardware.arduino.enable = true; doesnt exist
    };
  };
}
