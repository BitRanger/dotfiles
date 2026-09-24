# defines all hosts + users + homes.
# then config their aspects in as many files you want
{
  # bitranger user at saturn host.
  den.hosts.x86_64-linux.saturn = {
    syncthing.id = "6HKRAL2-KNBLXGU-M4DMRPY-CLTJGR5-WUBWP3A-AWNBRYB-YGWRVJQ-3SKKLQ7";
    hardware = {
      disk = {
        id = "nvme-eui.0025385751a0a050"; # Check via: lsblk -o NAME,UUID
	main-partition-size = "100%";
      };
      ram = "32G";
      usbKeyTimeout = 5;
    };
    users.bitranger = { };
  };

  # define an standalone home-manager for bitranger
  den.homes.x86_64-linux.bitranger = { };

  # be sure to add nix-darwin input for this:
  # den.hosts.aarch64-darwin.apple.users.alice = { };

  # other hosts can also have user tux.
  den.hosts.x86_64-linux.mars = {
    syncthing.id = "FTF6Q56-CZWDNUO-NE7O2D5-HZLAF6O-XD74LLA-HFX7AUV-WS5ZVJ7-P5BM7QX";
    hardware = {
      disk = {
        id = "ata-APPLE_SSD_SM0128G_S1W1NYAH310753"; # Check via: lsblk -o NAME,UUID
	main-partition-size = "100%";
      };
      ram = "8G";
      usbKeyTimeout = 5;
    };
    users.bitranger = { };
  };

  den.hosts.x86_64-linux.terra = {
    syncthing.id = "";
    hardware = {
      disk = {
        id = "nvme-eui.0000000000000000707c181d26007cbe"; # Check via: lsblk -o NAME,UUID
	main-partition-size = "733G"; # leaves approximately 700gb for actual storage and 32gb for hibernation
      };
      ram = "32G";
      usbKeyTimeout = 5;
    };
    users.bitranger = { };
  };
}
