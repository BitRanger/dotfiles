{ den, lib, ... }:
let
  email = {
    personal = "crgautam2020@gmail.com";
    school = "gcherukuri@wisc.edu";
  };
  sshKeys = {
    personal = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICv2lIFXne+LS1pX3D1oY1y/MXNrjIDyVnewLDMAVrAh crgautam2020@gmail.com";
  };
in
{
  # user aspect
  den.aspects.bitranger = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
    ];

    nixos = _: {
      sops.secrets."users/bitranger/password".neededForUsers = true;

      # GNOME sets the avatar through accountsservice, which copies the image
      # into /var/lib/AccountsService/icons/<user> and records Icon= in
      # users/<user>. Both sit under a path desktop/gnome.nix already persists,
      # but with no Icon= key accountsservice falls back to ~/.face - a bare
      # file in the home root, and only subdirectories of it are persisted. So a
      # picture set in Settings was gone by the next boot.
      #
      # Declaring both ends rather than persisting them. The image can't live in
      # my home either way: gdm draws the login screen as its own user and
      # /home/tomwrw is 0700, so an avatar in there shows up in Settings and
      # nowhere else.
      #
      # 'f+' truncates, so this owns users/tomwrw outright and the other keys
      # accountsservice keeps there - Language, XSession - are rewritten away on
      # every boot instead of merged. Same trade as users.mutableUsers and the
      # VSCodium extension list: what's in this repo is the only source of
      # truth.
      #
      # Real newlines below, not "\n". The tmpfiles module runs the argument
      # through lib.strings.escapeC, so it emits the escapes itself - writing
      # them here gets the backslash escaped a second time and lands a literal
      # \n in the keyfile. nixpkgs warns about exactly that, which is the only
      # reason I know.
      #systemd.tmpfiles.settings."10-tomwrw-avatar" = {
      #  "/var/lib/AccountsService/icons/tomwrw"."L+".argument = "${./avatar.png}";
      #  "/var/lib/AccountsService/users/tomwrw"."f+" = {
      #    mode = "0600";
      #    user = "root";
      #    group = "root";
      #    argument = ''
      #      [User]
      #      Icon=/var/lib/AccountsService/icons/tomwrw
      #    '';
      #  };
      #};
    };

    # den's 'user' class puts these straight onto users.users.tomwrw. osConfig
    # is the parent NixOS config, since this module's own 'config' belongs to
    # the user class.
    user =
      { osConfig, ... }:
      {
        # Pinned, not left to NixOS to allocate. 'just deploy' chowns the
        # seeded key tree to 1000:100 while the target is still running the
        # installer, which has no account for me - so it has to pass a numeric
        # uid, and the number has to be one this config guarantees rather than
        # one that happened to be handed out first. Auto-allocation starts at
        # 1000 and would be right today; it would stop being right the moment a
        # second user were declared ahead of this one.
        uid = 1000;

        hashedPasswordFile = osConfig.sops.secrets."users/bitranger/password".path;
        openssh.authorizedKeys.keys = lib.attrValues sshKeys;

        extraGroups = [
          "disk"
          "kvm"
          "video"
          "render"
          "audio"
          "input"
        ];
      };

    homeManager =
      { config, ... }:
      {
        #home.packages = [ pkgs.htop ];
        programs.git.settings.user.name = "bitranger";
        programs.git.settings.user.email = email.personal;
        programs.git.settings.user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519";

        xdg.configFile."git/allowed_signers".text = lib.concatMapStrings (k: "${email.personal} ${k}\n") (
          lib.attrValues sshKeys
        );
      };

    # user can provide NixOS configurations
    # to any host it is included on
    provides.to-hosts.nixos = { pkgs, ... }: { };
  };
}
