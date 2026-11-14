{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/server.nix
  ];

  networking.hostName = "mesocyclone";
  networking.hostId = "83b328be";

  boot.loader.systemd-boot = {
    enable = true;
    extraInstallCommands = ''
      ${pkgs.util-linux}/bin/mountpoint -q /sys/firmware/efi/efivars || mount -t efivarfs efivarfs /sys/firmware/efi/efivars || true
      entries=$(${pkgs.efibootmgr}/bin/efibootmgr || true)
      printf '%s' "$entries" | grep -q "NixOS-boot-A" || \
        ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_224467801083 -p 1 -L "NixOS-boot-A" -l '\EFI\systemd\systemd-bootx64.efi' || true
      printf '%s' "$entries" | grep -q "NixOS-boot-B" || \
        ${pkgs.efibootmgr}/bin/efibootmgr -c -d /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_231009804787 -p 1 -L "NixOS-boot-B" -l '\EFI\systemd\systemd-bootx64.efi' || true
      if ${pkgs.util-linux}/bin/mountpoint -q /boot-mirror; then
        ${pkgs.rsync}/bin/rsync -a --delete /boot/ /boot-mirror/ || echo "warning: boot mirror sync failed"
      else
        echo "warning: /boot-mirror not mounted, skipped sync"
      fi
    '';
  };
  boot.loader.efi.canTouchEfiVariables = false;

  systemd.services.boot-entries = {
    description = "Create redundant UEFI boot entries";
    wantedBy = [ "multi-user.target" ];
    unitConfig.ConditionPathIsDirectory = "/sys/firmware/efi";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [ pkgs.efibootmgr ];
    script = ''
      entries=$(efibootmgr || true)
      case "$entries" in
        *NixOS-boot-A*) ;;
        *) efibootmgr -c -d /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_224467801083 -p 1 -L "NixOS-boot-A" -l '\EFI\systemd\systemd-bootx64.efi' || true ;;
      esac
      case "$entries" in
        *NixOS-boot-B*) ;;
        *) efibootmgr -c -d /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_231009804787 -p 1 -L "NixOS-boot-B" -l '\EFI\systemd\systemd-bootx64.efi' || true ;;
      esac
    '';
  };

  system.stateVersion = "26.05";
}
