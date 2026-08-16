{ inputs, ... }:
{
  bit.core.boot =
    { host, ... }:
    {
      nixos = _: {
        # Use the systemd-boot EFI boot loader.
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      };
    };
}
