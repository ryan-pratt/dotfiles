{ config, lib, pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "microburst";

  # TODO: integrate with DE
  # - exec-once blueman-applet in hyprland
  # - use blueman-manager GUI to manage connections
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/cd9e2a2a-e4a5-4aff-815c-bd268490afa3";
    fsType = "btrfs";
    options = [ "nofail" "rw" "uid=1000" "gid=100" ];
  };

  # Game streaming
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # Direct GPU buffer access
    openFirewall = true; # TCP 47984-48010 and UDP 47998-48000
  };
  hardware.uinput.enable = true; # Input from streaming client

  environment.systemPackages = with pkgs; [
    # host-specific packages
  ];

  programs.steam.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "26.05";
}
