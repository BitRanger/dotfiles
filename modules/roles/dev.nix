{ den, bit, ... }:
{
  den.aspects.roles.dev = {
    includes = [
      bit.dev.neovim
      bit.dev.doom-emacs
      bit.dev.ghostty
      bit.dev.git
    ];
  };
}
