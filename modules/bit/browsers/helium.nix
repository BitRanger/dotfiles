{ inputs, ... }:
{
  flake-file.inputs.helium-flake = {
    url = "github:oxcl/nix-flake-helium-browser";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  bit.browsers.helium = _: {
    nixos = _: {
      imports = [ inputs.helium-flake.nixosModules.default ];
      programs.helium = {
        enable = true;
        flags = [ ];
        policies = {
          "PasswordManagerEnabled" = false;
          "SyncDisabled" = true;
          "SpellcheckEnabled" = true;
          "SpellcheckLanguage" = [ "en-US" ];
          "ExtensionInstallForcelist" = [
            # Pre-install extensions
            #"cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin, it's preinstalled so not necessary
            "ghmbeldphafepmbegfdlkpapadhbakde" # Proton Pass
          ];
        };
      };
    };
  };
}
