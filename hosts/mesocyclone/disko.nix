{
  disko.devices = {
    disk = {
      sandisk1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_224467801083";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "fmask=0022" "dmask=0022" ];
              };
            };
            root = {
              priority = 2;
              size = "100%";
            };
          };
        };
      };
      sandisk2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_231009804787";
        content = {
          type = "gpt";
          partitions = {
            esp = {
              priority = 1;
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot-mirror";
                mountOptions = [ "nofail" ];
              };
            };
            root = {
              priority = 2;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-d raid1"
                  "-m raid1"
                  "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_224467801083-part2"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };
      intel1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-INTEL_SSDSA2CT040G3_PEPR330500LK040AGN";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              priority = 1;
              size = "16G";
              content = {
                type = "swap";
                priority = 10;
              };
            };
            scratch = {
              priority = 2;
              size = "100%";
            };
          };
        };
      };
      intel2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-INTEL_SSDSA2CT040G3_PEPR3306001G040AGN";
        content = {
          type = "gpt";
          partitions = {
            swap = {
              priority = 1;
              size = "16G";
              content = {
                type = "swap";
                priority = 10;
              };
            };
            scratch = {
              priority = 2;
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [
                  "-f"
                  "-d raid1"
                  "-m raid1"
                  "/dev/disk/by-id/ata-INTEL_SSDSA2CT040G3_PEPR330500LK040AGN-part2"
                ];
                subvolumes = {
                  "/scratch" = {
                    mountpoint = "/scratch";
                    mountOptions = [ "compress=zstd" "noatime" "nofail" ];
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
