{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/desktop.nix
  ];

  networking.hostName = "inversion";

  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.systemd = {
    enable = true;
    tpm2.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    moonlight-qt
    openvpn
    samba
    sbctl
    update-resolv-conf
  ];

  services.openssh.enable = true;

  programs.steam.enable = true;

  # Fix for OpenVPN update-resolve-conf
  environment.etc.openvpn.source = "${pkgs.update-resolv-conf}/libexec/openvpn";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. Don't change this.
  system.stateVersion = "26.05";
}

