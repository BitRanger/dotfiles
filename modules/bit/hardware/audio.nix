{
  bit.hardware.audio = {
    nixos = {
      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };
    };
  };
}
