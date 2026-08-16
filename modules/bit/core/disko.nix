{ inputs, ... }:
{
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  bit.core.disko =
    { host, ... }:
    let
      luksDeviceName = "crypted";
      bootMountpoint = "/key";
      temporaryPath = "/tmp";
      usbKeyLabel = "Keys";
    in
    {
      nixos = { host, ... }: {
        imports = [
          inputs.disko.nixosModules.disko
        ];

        # ----------------------------------------------------------------------
        # Debug logging
        # ----------------------------------------------------------------------

        boot.kernelParams = [
          #"systemd.log_level=debug"
          #"systemd.log_target=console"
          #"rd.systemd.log_level=debug"
          #"rd.systemd.log_target=console"
        ];

        # ----------------------------------------------------------------------
        # Initrd systemd
        #
        # /key is generated as key.mount.
        #
        # DefaultDependencies=false prevents the mount from acquiring the
        # normal local-fs dependency chain, which is important because this
        # mount is needed by initrd cryptsetup itself.
        # ----------------------------------------------------------------------

        boot.initrd.systemd = {
          enable = true;

          # --------------------------------------------------------------
          # systemd's manager-wide default job timeout is 90s. That's what
          # the auto-generated `dev-disk-by\x2duuid-...device` unit for the
          # USB key inherits, since we never declare that unit ourselves
          # and so can't set a timeout on it directly. This lowers the
          # default for the whole initrd so a missing USB key falls
          # through to the interactive password prompt quickly instead of
          # waiting the full 90s. keyFileTimeout below is a separate,
          # already-fast step that only starts once this mount attempt has
          # resolved.
          #
          # (boot.initrd.systemd.extraConfig was removed upstream in favor
          # of this structured settings.Manager form.)
          # --------------------------------------------------------------

          #settings.Manager = {
          #  DefaultTimeoutStartSec = "10s";
          #};

          # Surgical alternative to the global DefaultTimeoutStartSec
          # override: only shortens the wait for this specific device
          # unit. `units.<name>` is the low-level generic unit type, so it
          # only takes raw `text` (no structured `unitConfig`) — and
          # `overrideStrategy = "asDropin"` layers this on top of the
          # unit that systemd-udevd generates at runtime, rather than
          # trying to replace it outright.
          units."dev-disk-by\\x2dlabel-${usbKeyLabel}.device" = {
            overrideStrategy = "asDropin";
            text = ''
              [Unit]
              JobTimeoutSec=3
              JobRunningTimeoutSec=3
            '';
          };

          mounts = [
            {
              what = "/dev/disk/by-label/${usbKeyLabel}";
              where = bootMountpoint;
              type = "exfat";
	      options = "ro,uid=0,gid=0,fmask=0177,dmask=0077";

              unitConfig = {
                DefaultDependencies = false;
              };

              before = [
                "systemd-cryptsetup@${luksDeviceName}.service"
              ];
            }
          ];
        };

        # ----------------------------------------------------------------------
        # USB key filesystem
        # ----------------------------------------------------------------------

        boot.supportedFilesystems = [
          "exfat"
        ];

        boot.initrd.kernelModules = [
          "exfat"
        ];

        # ----------------------------------------------------------------------
        # LUKS
        #
        # IMPORTANT:
        # Do not declare systemd-cryptsetup@crypted.service as an initrd
        # service. NixOS generates this unit from this declaration.
        # ----------------------------------------------------------------------

        boot.initrd.luks.devices."${luksDeviceName}" = {
          keyFile = "${bootMountpoint}/luks_key.bin";
          keyFileTimeout = 5; # this timeout is only to check the keyfile, not to mount the drive so it doesn't really matter
        };

        # ----------------------------------------------------------------------
        # Disko storage configuration
        # ----------------------------------------------------------------------

        disko.devices = {
          disk = {
            main = {
              type = "disk";

              device = "/dev/disk/by-id/${host.hardware.disk.id}";

              content = {
                type = "gpt";

                partitions = {
                  # ----------------------------------------------------------------
                  # EFI System Partition
                  # ----------------------------------------------------------------

                  ESP = {
                    size = "512M";
                    type = "EF00";

                    content = {
                      type = "filesystem";
                      format = "vfat";

                      mountpoint = "/boot";

                      mountOptions = [
                        "umask=0077"
                      ];
                    };
                  };

                  # ----------------------------------------------------------------
                  # LUKS partition
                  # ----------------------------------------------------------------

                  luks = {
                    size = "100%";

                    content = {
                      type = "luks";

                      name = "${luksDeviceName}";

                      passwordFile =
                        "${temporaryPath}/luks_password.txt";

                      settings = {
                        allowDiscards = true;
                      };

                      additionalKeyFiles = [
                        "${temporaryPath}/luks_key.bin"
                      ];

                      content = {
                        type = "btrfs";

                        extraArgs = [
                          "-f"
                        ];

                        subvolumes = {
                          # ------------------------------------------------------
                          # Root
                          # ------------------------------------------------------

                          "/root" = {
                            mountpoint = "/";

                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };

                          # ------------------------------------------------------
                          # Home
                          # ------------------------------------------------------

                          "/home" = {
                            mountpoint = "/home";

                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };

                          # ------------------------------------------------------
                          # Nix
                          # ------------------------------------------------------

                          "/nix" = {
                            mountpoint = "/nix";

                            mountOptions = [
                              "compress=zstd"
                              "noatime"
                            ];
                          };

                          # ------------------------------------------------------
                          # Swap
                          # ------------------------------------------------------

                          "/swap" = {
                            mountpoint = "/.swapvol";

                            swap.swapfile.size = host.hardware.ram;
                          };
                        };
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
}
