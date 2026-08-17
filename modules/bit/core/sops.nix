{ inputs, ... }:
let
  # Home-relative, because that is what the home-persist quirk deals in. The
  # homeManager block turns it back into an absolute path against
  # config.home.homeDirectory rather than assuming /home/<user>.
  ageKeyDir = ".config/sops/age";
  ageKeyFile = "${ageKeyDir}/keys.txt";
in
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  bit.core.sops = { user, ... }: {
    nixos = {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        defaultSopsFile = ../../../secrets/users/${user.name}.yaml;
        #defaultSopsFile = ../../../secrets/hosts/${config.networking.hostName}.yaml;
        age.keyFile = "/home/${user.name}/${ageKeyFile}";
        age.generateKey = false;
        # One decryption identity, spelled out. Otherwise sops-nix defaults
        # sshKeyPaths to the ed25519 host key and turns it into an age
        # identity at activation, which is a second way in that would change
        # behaviour if I ever rotated the host key.
        age.sshKeyPaths = [ ];
      };
    };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];
        sops = {
          defaultSopsFile = ../../../secrets/users/${config.home.username}.yaml;
          age.keyFile = "${config.home.homeDirectory}/${ageKeyFile}";
          age.generateKey = false;
        };

        systemd.user.services.sops-nix = {
          Unit = {
            DefaultDependencies = false;
            Before = [
              "basic.target"
              "shutdown.target"
            ];
            Conflicts = [ "shutdown.target" ];
          };
          # sops-nix hardcodes WantedBy = default.target with no way to
          # override it, but my secrets have to be on disk before syncthing
          # starts, so pull it forward to basic.target. mkForce is the
          # smallest thing that works. Revisit if sops-nix ever gives me an
          # option for this.
          Install.WantedBy = lib.mkForce [ "basic.target" ];
        };

        home.packages = [
          pkgs.sops
        ];
      };
  };
}
