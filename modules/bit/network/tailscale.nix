{
  bit.network.tailscale = {
    nixos = {
      services.tailscale.enable = true;
    };
    homeManager = {
      services.trayscale.enable = true;
      services.tailscale-systray.enable = true;
    };
  };
}
