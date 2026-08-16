{ den, bit, ... }:
{
  den.aspects.roles.base.includes = [
    bit.core.nix
    bit.core.locale
    bit.core.openssh
    bit.network.network
    bit.network.tailscale
    bit.core.boot
    bit.core.disko
    bit.core.facter
        bit.core.sops
    bit.shell.fish
    bit.shell.cli-apps
    bit.shell.nix-index
    bit.shell.direnv
  ];
}
